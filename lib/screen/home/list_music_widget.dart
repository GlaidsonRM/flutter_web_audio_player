import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/audio_actions.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';

class ListMusicWidget extends StatelessWidget {
  final MusicController musicController = Get.find();
  final AudioActions actions = AudioActions();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      itemCount: musicController.allMusic.length,
      itemBuilder: (context, index) {
        MusicModel musicModel = musicController.allMusic[index];



        return Column(
          children: [
            ListTile(
              onTap: () => actions.playPosition(index),
              leading: Container(
                  height: 50,
                  width: 50,
                  child: musicModel.albumArt == null ?
                  Text('') :
                  Image.memory(musicModel.albumArt)),
              title: Text(musicModel.description),
              subtitle: Text(musicModel.artist),
              trailing: Text('03:12'),
            ),
            Divider(
              thickness: 1,
            )
          ],
        );
      },
    ));
  }
}
