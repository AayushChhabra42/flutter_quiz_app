import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:privacyapp/routes.dart';
import 'package:privacyapp/services/models.dart';
import 'package:privacyapp/services/firestore.dart';
import 'package:privacyapp/theme.dart';
import 'package:provider/provider.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _Appstate createState() => _Appstate();
}

class _Appstate extends State<MyApp>{
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: _initialization,
      builder: (context,snapshot) {
        if(snapshot.hasError){
          return const Text('error', textDirection: TextDirection.ltr);
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider(
            create: (_)=>FirestorService().streamReport(), 
            initialData: report(),
            child:MaterialApp(
            routes: appRoutes,
            theme:appTheme,
          ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Text('loading', textDirection: TextDirection.ltr);
      },
    );
  }
}