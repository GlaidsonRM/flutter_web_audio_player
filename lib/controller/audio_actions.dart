import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:get/get.dart';

class AudioActions {
  final MusicController musicController = Get.find();
  final MusicPlayerController playerController = Get.find();

  void previousMusic() {
    if (playerController.player.hasPrevious) {
      playerController.player.seekToPrevious();
    } else {
      playerController.player.seek(Duration(milliseconds: 0),
          index: musicController.allMusic.length - 1);
    }
    playerController.player.play();
  }

  void playOrPause() {
    if (playerController.player.playing) {
      playerController.player.pause();
    } else {
      playerController.player.play();
    }
  }

  void nextMusic() {
    if (playerController.player.hasNext) {
      playerController.player.seekToNext();
    } else {
      playerController.player.seek(Duration(milliseconds: 0), index: 0);
    }
    playerController.player.play();
  }

  playPosition(int index) {
    playerController.player.seek(Duration(milliseconds: 0),
        index: index);

    playerController.player.play();
  }
}
