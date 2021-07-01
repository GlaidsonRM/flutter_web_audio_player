import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/audio_actions.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';

import 'list_music_widget.dart';

class HomeGreat extends StatelessWidget {
  final MusicController musicController = Get.find();
  final AudioActions actions = AudioActions();

  final MusicPlayerController playerController;
  HomeGreat(this.playerController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: playerAudio()),
          Expanded(child: ListMusicWidget())
        ],
      ),
    );
  }

  playerAudio() {
    return Obx(() => Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 300,
              width: 300,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 8,
                child: Center(
                  child: playerController.currentMusic.value.description == 'Nada tocando' ? Icon(
                    Icons.music_off,
                    size: 100,
                  ) : Image.network(playerController.currentMusic.value.urlImage),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            playerController.loadingSong.value ?
                CircularProgressIndicator(color: Colors.green,) :
            Column(
              children: [
                Text(
                  playerController.currentMusic.value.description,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  playerController.currentMusic.value.artist,
                  style: TextStyle(color: Colors.green, fontSize: 15),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: actions.previousMusic,
                  child: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: actions.playOrPause,
                  child: Icon(
                    playerController.player.playing ?
                    Icons.pause :
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 65,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: actions.nextMusic,
                  child: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
            ),
            Container(
              width: 250,
              child: Row(
                children: [
                  Icon(Icons.volume_up_sharp, color: Colors.green,),
                  Expanded(
                    child: SliderTheme(data: SliderThemeData(
                      trackHeight: 0.1,
                      showValueIndicator: ShowValueIndicator.never,
                      valueIndicatorColor: Colors.grey,
                      valueIndicatorShape: SliderComponentShape.noOverlay,
                      thumbColor: Colors.green,
                    ), child: Slider(onChanged: (double value) {
                      playerController.player.setVolume(value);
                    }, value: playerController.player.volume,)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Slider(
              value: playerController.positionMusic.value,
              onChanged: (v) {
                playerController.player.seek(Duration(milliseconds: v.toInt()));
              },
              min: 0,
              max: playerController.maxPositionMusic.value,
              activeColor: Colors.green,
              inactiveColor: Colors.green.shade300,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(playerController.currentTimeMusic.value, style: TextStyle(color: Colors.white),),
                  Text(playerController.maxTimeMusic.value, style: TextStyle(color: Colors.white),)
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
