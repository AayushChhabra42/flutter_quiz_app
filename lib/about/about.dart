import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class Aboutscreen extends StatelessWidget {
  const Aboutscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Column(
        children: [
          Image.asset(
            'assets/covers/student.jpg',
            width: MediaQuery.of(context).size.width,
          ),
          Flexible(
              child:Padding(
                padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child:Text('Created by')
                ),
          ),
          Flexible(
              child:Padding(
                padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child:Text('Aayush Chhabra')
                ),
          ),
        ]
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        final Uri _url = Uri.parse('https://www.linkedin.com/in/aayush-chhabra-199992167/');
        if (!await launchUrl(_url)) {
          throw Exception('Could not launch $_url');
        }
      }
      )
    );
  }
}