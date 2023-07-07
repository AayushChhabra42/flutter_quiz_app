import 'package:flutter/material.dart';
import 'package:privacyapp/services/models.dart';
//import 'package:privacyapp/shared/progress_bar.dart';
//import 'package:privacyapp/topics/drawer.dart';

class TopicItem extends StatelessWidget {
  final Map<String,dynamic> topic;
  const TopicItem({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: topic['img'],
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => TopicScreen(topic: topic),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(
                  child: Image.asset(
                    'assets/covers/${topic['img']}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                fit:FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    topic['topic'].toString().toUpperCase(),
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicScreen extends StatelessWidget {
  final Map<String,dynamic> topic;

  const TopicScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(children: [
        Hero(
          tag: topic['img'],
          child: Image.asset('assets/covers/${topic['img']}',
              width: MediaQuery.of(context).size.width),
        ),
        Padding(
          padding:const EdgeInsets.only(left: 3,right:3),
          child:Text(topic['topic'],style: const TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ),
      ]),
    );
  }
}