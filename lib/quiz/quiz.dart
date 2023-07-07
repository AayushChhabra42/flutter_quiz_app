import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:privacyapp/services/services.dart';
import 'package:privacyapp/shared/loading.dart';
import 'package:privacyapp/shared/progressbar.dart';
import 'package:provider/provider.dart';
import 'package:privacyapp/quiz/quiz_state.dart';

class Quizscreen extends StatelessWidget {
  const Quizscreen({Key?key,required this.quizId}):super(key: key);
  final String quizId;

  @override
  Widget build(BuildContext context) {
    print(quizId);
    return ChangeNotifierProvider(
      create: (_) =>QuizState(),
      child: FutureBuilder<quiz>(
        future:FirestorService().getQuiz(quizId),
        builder:(context,snapshot){
            var state = Provider.of<QuizState>(context);
            if (!snapshot.hasData || snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            else{
              var Quiz = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  title: AnimatedProgressbar(value: state.progress),
                  leading: IconButton(
                    icon: const Icon(FontAwesomeIcons.xmark),
                    onPressed: () =>Navigator.pop(context),
                  ),
                ),
                body: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    controller: state.controller,
                    onPageChanged: (int idx) =>
                      state.progress = (idx/(Quiz.questions.length+1)),
                    itemBuilder: (BuildContext context,int idx){
                      if (idx == 0) {
                      return StartPage(Quiz: Quiz);
                      } 
                      else if (idx == Quiz.questions.length + 1) {
                          return CongratsPage(Quiz: Quiz);
                      } 
                      else {
                      return QuestionPage(Question: Quiz.questions[idx - 1]);
                      }
                    },
                  ),
              );
            }

        },
      ),
      );
  }
}

class StartPage extends StatelessWidget {
  final quiz Quiz;
  const StartPage({super.key, required this.Quiz});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Quiz.topic, style: Theme.of(context).textTheme.headline4),
          const Divider(),
          Expanded(child: Text(Quiz.description)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: state.nextPage,
                label: const Text('Start Quiz!'),
                icon: const Icon(Icons.poll),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CongratsPage extends StatelessWidget {
  final quiz Quiz;
  const CongratsPage({super.key, required this.Quiz});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congrats! You completed the ${Quiz.topic} quiz',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          //Image.asset('assets/congrats.gif'),
          const Divider(),
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            icon: const Icon(FontAwesomeIcons.check),
            label: const Text(' Mark Complete!'),
            onPressed: () {
              FirestorService().updateUserReport(Quiz);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/topics',
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final question Question;
  const QuestionPage({super.key, required this.Question});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(Question.questiontext),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Question.options.map((opt) {
              return Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.black26,
                child: InkWell(
                  onTap: () {
                    state.selected = opt;
                    _bottomSheet(context, opt, state);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                            state.selected == opt
                                ? FontAwesomeIcons.circleCheck
                                : FontAwesomeIcons.circle,
                            size: 30),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              opt.value,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
  _bottomSheet(BuildContext context, option opt, QuizState state) {
    bool correct = opt.correct;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(correct ? 'Good Job!' : 'Wrong'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: correct ? Colors.green : Colors.red),
                child: Text(
                  correct ? 'Onward!' : 'Try Again',
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (correct) {
                    state.nextPage();
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
