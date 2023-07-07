import 'package:flutter/material.dart';
import 'package:privacyapp/services/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TopicDrawer extends StatelessWidget{
  final List<Map<String,dynamic>> topics;
  const TopicDrawer({Key?key,required this.topics}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context,int idx){
          //print(topics[idx]['quizzes']);
          List<quiz> quizlistfirebase=[];
          for(int i=0;i<topics[idx]['quizzes'].length;i++){
            String j=i.toString();
            quizlistfirebase.add(quiz(description: topics[idx]['quizzes'][j]['description'],id:topics[idx]['quizzes'][j]['id'],topic:topics[idx]['quizzes'][j]['title']));
          }
          //print(quizlistfirebase);
          Topic topic=Topic(id:topics[idx]['id'],title:topics[idx]['topic'],quizzes:quizlistfirebase,img:topics[idx]['img']);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:10,bottom: 10),
                child: Text(
                  topic.title,
                  style:const TextStyle(
                    fontSize:20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  )
                ),
              ),
              QuizList(topic:topic)
            ],
          );
        },
        separatorBuilder: (BuildContext content,int idx)=> const Divider(), 
        itemCount: topics.length
        ),
    );
  }
}

class QuizList extends StatelessWidget{
  final Topic topic;
  const QuizList({Key?key,required this.topic}):super (key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: topic.quizzes.map(
        (quiz) {
          return Card(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 4,
            margin: const EdgeInsets.all(4),
            child: InkWell(
              onTap: () {
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    quiz.topic,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                    quiz.description,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  leading: QuizBadge(topic: topic, quizId: quiz.id),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class QuizBadge extends StatelessWidget {
  final String quizId;
  final Topic topic;

  const QuizBadge({super.key, required this.quizId, required this.topic});

  @override
  Widget build(BuildContext context) {
    report Report = Provider.of<report>(context);
    print(Report.topics);
    Map<String,dynamic> topicmap=Report.topics[topic.id];
    print(topicmap);
    List completed = topicmap.entries.toList() ?? [];
    if (completed.contains(quizId)) {
      return const Icon(FontAwesomeIcons.checkDouble, color: Colors.green);
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}