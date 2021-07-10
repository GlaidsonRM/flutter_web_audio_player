import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:flutter_web_audio_player/screen/home/home_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // void callbackDispatcher() {
  //   Workmanager().executeTask((taskName, inputData) {
  //     print("Native called background task: $backgroundTask"); //simpleTask will be emitted here.
  //     return Future.value(true);
  //   });
  // }

  await Firebase.initializeApp();

  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'ggrrmm@gmail.com', password: '123456');

  Get.lazyPut(() => MusicController());
  MusicController musicController = Get.find();
  musicController.onInit();

  Get.lazyPut(() => MusicPlayerController());
  MusicPlayerController musicPlayerController = Get.find();
  musicPlayerController.onInit();

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
