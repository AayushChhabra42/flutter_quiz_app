import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:privacyapp/services/auth.dart';
import 'package:privacyapp/services/models.dart';

class FirestorService{
  final FirebaseFirestore _db =FirebaseFirestore.instance;
    Future<List<Topic>> getTopics() async{
    //Future<List<Map<String,dynamic>>> getTopics() async{
    var ref =_db.collection('Topics');
    var snapshot = await ref.get();
    List<QueryDocumentSnapshot>data =snapshot.docs;

    List <Map> possible_items = data.map((e) =>{
      'id':e['id'],
      'img':e['img'],
      'quizzes':e['quizzes'],
      'topic':e['topic']
    }).toList();
    //print(possible_items);
    List<List<quiz>> possibly_quiz_data=[];
    for(int i=0;i<possible_items.length;i++){
      String new_description='';
      String new_id='';
      String new_topic='';
      List<quiz> New_quiz = [];
      for(int j=0;j<possible_items[i]['quizzes'].length;j++){
        new_description=possible_items[i]['quizzes'][j.toString()]['description'];
        new_id=possible_items[i]['quizzes'][j.toString()]['id'];
        new_topic=possible_items[i]['quizzes'][j.toString()]['title'];
        New_quiz.add(quiz(description: new_description,id: new_id,topic: new_topic));
      }
      possibly_quiz_data.add(New_quiz);
      //possibly_quiz_data.add(quiz(description: new_description,id: new_id,topic: new_topic));
      //possibly_quiz_data.add(quiz(description: possible_items[i]['quizzes']['0']['description'],id:possible_items[i]['quizzes']['0']['id'],topic: possible_items[i]['quizzes']['0']['title']));
    }
    Map<String, List<quiz>> quiz_data_map = {};
    for(int i=0;i<possibly_quiz_data.length;i++){
      List<quiz> quiz_list_for_map=List.empty(growable: true);
      for(int j=0;j<possibly_quiz_data[i].length;j++){
        quiz_list_for_map.add(possibly_quiz_data[i][j]);
      }
      possibly_quiz_data[i].forEach((e) => quiz_data_map[e.id]=quiz_list_for_map);
    }
    print(quiz_data_map['pass-basics']);
    //var possibly_topics=data.map((d)=>Topic(id:d['id'],title: d['topic'],img:d['img'],quizzes:possibly_quiz_data[0]));
    var possibly_topics = data.map((d) {
    List<quiz>? quizzes = quiz_data_map[d['id']];
    return Topic(
      id: d['id'],
      title: d['topic'],
      img: d['img'],
      quizzes: quizzes ?? [], // Use the empty list if quizzes is null
      );
    });
    print(possibly_topics.toList()[0].id);
    //var data2=ref.snapshots().map((list) => list.docs.map((doc) => doc.data()));
    var data_testing=data.toList();
    //print(data_testing[0]);
    //var topics = data_testing.map((d)=>Topic.fromJson(d));
    return possibly_topics.toList();
    //return data_testing;
  }

  Future<quiz> getQuiz(String quizId) async{
    var ref=_db.collection('quizzes').doc(quizId);
    var snapshot = await ref.get();
    return quiz.fromJson(snapshot.data()??{});
  }

  Stream<report> streamReport(){
    return AuthService().userStream.switchMap((user){
      if(user!=null){
        var ref=_db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) => report.fromJson(doc.data()!));
      }
      else{
        return Stream.fromIterable([report()]);
      }
    });
  }

  Future<void> updateUserReport(quiz quiz){
    var user = AuthService().user!;
    var ref =_db.collection('reports').doc(user.uid);

    var data = {
      'total':FieldValue.increment(1),
      'topics':{
        quiz.topic:FieldValue.arrayUnion([quiz.id])
      }

    };

    return ref.set(data,SetOptions(merge: true));
  }
}

