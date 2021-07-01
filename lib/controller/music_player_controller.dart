import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerController extends GetxController {
  final player = AudioPlayer();
  final MusicController musicController = Get.find();

  RxDouble positionMusic = 0.0.obs;
  RxDouble maxPositionMusic = 100.0.obs;
  RxInt positionMusicPlayer = 0.obs;
  RxString currentTimeMusic = '0:00'.obs;
  RxString maxTimeMusic = '0:00'.obs;
  RxBool loadingSong = false.obs;
  RxBool playing = false.obs;
  RxBool isPaused = false.obs;

  List<AudioSource> audiosSource = [];

  var currentMusic = MusicModel(
          artist: 'Nada tocando',
          description: 'Nada tocando',
          isLoading: false,
          isPlaying: false,
          url: '',
          urlImage: '')
      .obs;

  @override
  void onInit() {
    super.onInit();

    audiosSource.clear();

    musicController.loadMusic.listen((e) {
      if(e){
        musicController.allMusic.forEach((element) {
          audiosSource.add(AudioSource.uri(Uri.parse(element.url)));
        });
        setAudioSource(audiosSource);
      }
    });

    player.positionStream.listen((event) {
      currentTimeMusic.value = setTime(event);
      positionMusic.value = event.inMilliseconds.toDouble();
    });

    player.durationStream.listen((event) {

      int? index = player.currentIndex;

      currentMusic.value = musicController.allMusic[index ??0];

      var duration = event;

      if (duration != null) {
        int milleseconds = int.parse(duration.inMilliseconds.toString());
        Duration dur = Duration(milliseconds: milleseconds);
        maxPositionMusic.value = dur.inMilliseconds.toDouble();
        maxTimeMusic.value = setTime(dur);
      }
    });

    player.playerStateStream.listen((event) {
      if (event.playing) {
        playing.value = true;
        isPaused.value = false;
        print('Playing');
      } else {
        switch (event.processingState) {
          case ProcessingState.idle:
            playing.value = false;
            print('Idle');
            break;
          case ProcessingState.loading:
            print('Loading');
            break;
          case ProcessingState.buffering:
            loadingSong.value = true;
            print('Buffering');
            break;
          case ProcessingState.ready:
            loadingSong.value = false;
            print('Ready');
            break;
          case ProcessingState.completed:
            print('Complete');
            break;
        }
      }
    });


  }

  _playPauseMusic() async {
    if (playing.value) {
      player.pause();
      playing.value = false;
      isPaused.value = true;
    } else if (isPaused.value) {
      player.play();
    } else {
      currentMusic.value = musicController.allMusic[positionMusicPlayer.value];
      var duration = await player.setUrl(currentMusic.value.url);

      if (duration != null) {
        int milleseconds = int.parse(duration.inMilliseconds.toString());
        Duration dur = Duration(milliseconds: milleseconds);
        maxPositionMusic.value = dur.inMilliseconds.toDouble();
        maxTimeMusic.value = setTime(dur);
      }

      player.play();
    }
  }

  String setTime(Duration duration) {
    String minuto = '0';
    String segundos = '0';

    minuto = duration.inMinutes.toString();
    segundos = duration.inSeconds.remainder(60).toString();

    if (duration.inSeconds.remainder(60) < 10) {
      segundos = '0${duration.inSeconds.remainder(60)}';
    }
    if (duration.inMinutes < 10) {
      minuto = '0${duration.inMinutes}';
    }

    return '$minuto:$segundos';
  }

  setAudioSource(List<AudioSource> source) async {
    await player.setAudioSource(
      ConcatenatingAudioSource(
        // Start loading next item just before reaching it.
        useLazyPreparation: true, // default
        // Customise the shuffle algorithm.
        shuffleOrder: DefaultShuffleOrder(), // default
        // Specify the items in the playlist.
        children: source,
      ),
      // Playback will be prepared to start from track1.mp3
      initialIndex: 0, // default
      preload: true,
      // Playback will be prepared to start from position zero.
      initialPosition: Duration.zero, // default
    ).onError((error, stackTrace) {
      print(error.toString());
    });
  }
}
