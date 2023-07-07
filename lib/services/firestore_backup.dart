import 'dart:async';
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
    var data =snapshot.docs.map((s)=>s.data());
    var possibly_quiz_names = data.map((e)=>(e['quizzes'])).toList();
    print(possibly_quiz_names);
    List<quiz> possibly_quiz_data=[];
    for(int i=0;i<possibly_quiz_names.length;i++){
      possibly_quiz_data.add(quiz(description: possibly_quiz_names[i]['0']['description'],id:possibly_quiz_names[i]['0']['id'],topic: possibly_quiz_names[i]['0']['title']));
    }
    var possibly_topics=data.map((d)=>Topic(id:d['id'],title: d['topic'],img:d['img'],quizzes:possibly_quiz_data));
    //print(possibly_topics);
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

