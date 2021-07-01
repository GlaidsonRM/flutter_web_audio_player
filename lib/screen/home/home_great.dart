import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';

class HomeGreat extends StatelessWidget {
  final MusicController musicController = Get.find();

  final MusicPlayerController playerController;
  HomeGreat(this.playerController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: playerAudio()),
          Expanded(child: listMusic())
        ],
      ),
    );
  }

  listMusic() {
    return Obx(() => ListView.builder(
          itemCount: musicController.allMusic.length,
          itemBuilder: (context, index) {
            MusicModel musicModel = musicController.allMusic[index];
            return Column(
              children: [
                ListTile(
                  onTap: (){
                    playerController.isPaused.value = false;
                    playerController.playing.value = false;
                    playerController.positionMusicPlayer.value = index;
                    //playerController.playPauseMusic();
                  },
                  leading: Container(
                      height: 50,
                      width: 50,
                      child: Image.network(musicModel.urlImage)),
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
                  onTap: (){
                    playerController.isPaused.value = false;
                    playerController.playing.value = false;
                    if(playerController.positionMusicPlayer.value == 0){
                      playerController.positionMusicPlayer.value = musicController.allMusic.length - 1;
                    } else {
                      playerController.positionMusicPlayer.value--;
                    }
                    //playerController.playPauseMusic();
                  },
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
                  onTap: playerController.newPlayer,
                  child: Icon(
                    playerController.playing.value ?
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
                  onTap: (){
                    playerController.isPaused.value = false;
                    playerController.playing.value = false;
                    if(playerController.positionMusicPlayer.value == musicController.allMusic.length-1){
                      playerController.positionMusicPlayer.value = 0;
                    } else {
                      playerController.positionMusicPlayer.value++;
                    }
                    //playerController.playPauseMusic();
                  },
                  child: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
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
