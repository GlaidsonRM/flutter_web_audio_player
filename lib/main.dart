import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/audio_controller.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/model/file_audio.dart';
import 'package:flutter_web_audio_player/screen/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'ggrrmm@gmail.com', password: '123456');

  Get.lazyPut(() => MusicController());
  MusicController musicController = Get.find();
  musicController.onInit();

  ///flutter_beta run --web-renderer html

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/insert_music',
            page: () => Container(
                  child: Text('Insert Music'),
                ))
      ],
      debugShowCheckedModeBanner: false,
      title: 'Glaidson Flutter Áudio',
      theme: ThemeData(primaryColor: Colors.black),
      home: HomeScreen(),
    );
  }
}
