import 'package:flutter_web_audio_player/model/file_audio.dart';
import 'package:just_audio/just_audio.dart';

class AudioController {
  final player = AudioPlayer();
  List<FileAudio> audios = [];

  Future<List<FileAudio>> generateAudios() async {
    FileAudio fileAudio = FileAudio();
    fileAudio.name = 'ATB - Your Love (9PM)';
    fileAudio.artist = 'ATB';
    fileAudio.url =
        'https://drive.google.com/uc?id=1gCnyCcK8RNo3to2KGnMY7dBPXio-COVC&export=download';
    fileAudio.milliseconds = await getMilliseconds(fileAudio.url);

    audios.add(fileAudio);

    fileAudio = FileAudio();
    fileAudio.name = 'Tiësto - Ritual';
    fileAudio.artist = 'Tiësto';
    fileAudio.url =
    'https://drive.google.com/uc?id=1w0v1IB3mJYFX2miHDLX528qH9CNuM1yX&export=download';
    fileAudio.milliseconds = await getMilliseconds(fileAudio.url);

    audios.add(fileAudio);

    fileAudio = FileAudio();
    fileAudio.name = 'Sia - Unstoppable';
    fileAudio.artist = 'Sia';
    fileAudio.url =
    'https://drive.google.com/uc?id=1u353xWcVoprA7Gm3MwCyt3PUPfJ9dtCw&export=download';
    fileAudio.milliseconds = await getMilliseconds(fileAudio.url);

    audios.add(fileAudio);

    fileAudio = FileAudio();
    fileAudio.name = 'Chris Brown - Ayo';
    fileAudio.artist = 'Chris Brown';
    fileAudio.url =
    'https://drive.google.com/uc?id=1iNPM-Dv04JdF9kbyJi_43GiSzzdRiz1V&export=download';
    fileAudio.milliseconds = await getMilliseconds(fileAudio.url);

    audios.add(fileAudio);

    return audios;
  }

  Future<Duration> getMilliseconds(String s) async {
    Duration dur = Duration(milliseconds: 0);
    var duration = await player.setUrl(s);
    if (duration != null) {
      int milleseconds = int.parse(duration.inMilliseconds.toString());
      dur = Duration(milliseconds: milleseconds);
    }
    return dur;
  }
}
