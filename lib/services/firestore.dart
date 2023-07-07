import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:privacyapp/services/auth.dart';
import 'package:privacyapp/services/models.dart';

class FirestorService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reads all documments from the topics collection
  Future<List<Topic>> getTopics() async {
    var ref = _db.collection('Topics');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    //print(data);
    List<Topic> topics = List.empty(growable: true);
    for(int i=0;i<data.length;i++){
      var d = data.toList()[i];
      quiz quiz1=quiz(description:d['quizzes']['0']['description'],id: d['quizzes']['0']['id'],topic:d['quizzes']['0']['title']);
      List<quiz> quizzes_1 = [quiz1];
      topics.add(Topic(id: d['id'],img: d['img'],title:d['topic'],quizzes: quizzes_1));
    }
    //var topics = data.map((d) => Topic.fromJson(d));
    return topics;
  }

  /// Retrieves a single quiz document
  Future<quiz> getQuiz(String quizId) async {
    var ref = _db.collection('quizzes').doc(quizId);
    var snapshot = await ref.get();
    Map<String,dynamic>? data = snapshot.data();
    quiz Quiz_obj = quiz();
    List <question> questionlist= List.empty(growable: true);
    if(data != null){
      for(int i=0;i<data['questions'].length;i++){
        print(data['questions'].length);
        List<option> optionlist = List.empty(growable: true);
        for(int j=0;j<data['questions'][i.toString()]['options'].length;j++){
          optionlist.add(option(value:data['questions'][i.toString()]['options'][j.toString()]['value'],correct:data['questions'][i.toString()]['options'][j.toString()]['correct']));
        }
        questionlist.add(question(questiontext: data['questions'][i.toString()]['question-text'],options: optionlist));
      }
      print(data['description']);
      print(data['id']);
      print(data['topic']);
      print(questionlist);
      Quiz_obj=quiz(description: data['description'],id:data['id'],questions: questionlist,topic: data['topic']);
    }

    return Quiz_obj;
  }

    /// Listens to current user's report document in Firestore
  Stream<report> streamReport() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) => report.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([report()]);
      }
    });
  }

  /// Updates the current user's report document after completing quiz
  Future<void> updateUserReport(quiz quiz) {
    var user = AuthService().user!;
    var ref = _db.collection('reports').doc(user.uid);

    var data = {
      'total': FieldValue.increment(1),
      'topics': {
        quiz.topic: FieldValue.arrayUnion([quiz.id])
      }
    };

    return ref.set(data, SetOptions(merge: true));
  }
}