import 'package:flutter/material.dart';
import 'package:privacyapp/services/firestore.dart';
import 'package:privacyapp/shared/bottomnavbar.dart';
import 'package:privacyapp/shared/error.dart';
import 'package:privacyapp/shared/loading.dart';
import 'package:privacyapp/topics/topic_item.dart';
import 'package:privacyapp/topics/drawer.dart';

class Topicsscreen extends StatelessWidget {
  const Topicsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestorService().getTopics(),
      builder:(context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const LoadingScreen();
        }
        else if(snapshot.hasError){
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        }
        else if(snapshot.hasData){
          var topics =snapshot.data!;
          // var child_list=topics.map((topic) => topic['topic']).toList();
          // for(int i=0;i<child_list.length;i++){
          //   child_list[i]=child_list[i][0].toUpperCase()+child_list[i].substring(1).toLowerCase();
          // }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple ,
              title: const Text('Topics'),
              ),
            drawer: TopicDrawer(topics:topics),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic:topic)).toList(),
            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        }
        else{
          return const Text('No topics found in firestore.Check database');
        }
      },
    );
  }
}