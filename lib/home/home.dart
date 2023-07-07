import 'package:flutter/material.dart';
import 'package:privacyapp/login/login.dart';
import 'package:privacyapp/topics/topics.dart';
import 'package:privacyapp/services/auth.dart';


class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('loading');
        }
        else if(snapshot.hasError){
          return const Center(
            child:Text('error'),
          );
        }
        else if(snapshot.hasData){
          return const Topicsscreen();
        }
        else{
          return const LoginScreen();
        }
      },
      );
  }
}