import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/audio_actions.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';

class PlaylistPlaying extends StatelessWidget {
  final MusicController musicController = Get.find();
  final AudioActions actions = AudioActions();
  final Color background = Colors.black45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Tocando'),
      ),
      body: Obx(() => ListView.builder(
        itemCount: musicController.allMusic.length,
        itemBuilder: (context, index) {
          MusicModel musicModel = musicController.allMusic[index];
          return ListTile(
            onTap: () => actions.playPosition(index),
            leading: Container(
                height: 50,
                width: 50,
                child: musicModel.albumArt == null ?
                Text('No Img') :
                Image.memory(base64Decode(musicModel.albumArt!))),
            title: Text(musicModel.description!.split('-').last, style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
            subtitle: Text('Por ${musicModel.description!}', style: TextStyle(
              color: Colors.white, fontSize: 12
            ),),
            trailing: Icon(Icons.menu, color: Colors.white,),
          );
        },
      )),
    );
  }
}
