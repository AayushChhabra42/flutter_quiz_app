import 'package:privacyapp/about/about.dart';
import 'package:privacyapp/home/home.dart';
import 'package:privacyapp/login/login.dart';
import 'package:privacyapp/profile/profile.dart';
import 'package:privacyapp/topics/topics.dart';

var appRoutes ={
    '/': (context) => const Homescreen(),
    '/about':(context) => const Aboutscreen(),
    '/login':(context) => const LoginScreen(),
    '/profile':(context) => const ProfileScreen(),
    '/topics':(context) => const Topicsscreen(),
};