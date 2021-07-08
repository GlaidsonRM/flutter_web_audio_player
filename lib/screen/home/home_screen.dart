import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:flutter_web_audio_player/features/metadata/presentation/controller/metadata_controller.dart';
import 'package:flutter_web_audio_player/screen/home/home_great.dart';
import 'package:flutter_web_audio_player/screen/home/home_little.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final MusicPlayerController playerController = Get.find();

  final MetaDataController metaDataController = MetaDataController();

  @override
  Widget build(BuildContext context) {

    playerController.onInit();
    metaDataController.onInit();

    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        print(constraints.maxWidth);
        if(constraints.maxWidth >= 800) {
          return HomeGreat(playerController);
        } else {
          return HomeLittle(playerController);
        }
      }),
    );
  }
}
