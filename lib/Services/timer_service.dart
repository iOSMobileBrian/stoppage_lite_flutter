import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class TimerService extends ChangeNotifier {
  int seconds;
  Timer? timer;
  TimerService({required this.seconds});

  void start() {
    const milliSec = Duration(seconds: 1);
    timer = Timer.periodic(milliSec, (timer) {
      if (seconds > 0) {
        seconds--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void addTime(int time) {
    seconds += time;
    notifyListeners();
  }

  void stop() {
    if (timer!.isActive) {
      timer!.cancel();
      !timer!.isActive;
      notifyListeners();
    }
  }

  void reset() {
    timer?.cancel();
    timer?.isActive == false;
    seconds = 0;
    notifyListeners();
  }

  Future<void> playAudioForThreeSeconds() async {
    final player = AudioPlayer();

    // Replace with your audio file path or URL
    const audioPath = 'assets/audio/Warning Siren.mp3';

    // Play the audio
    await player.play(AssetSource(audioPath));

    // Stop after 3 seconds
    Timer(const Duration(seconds: 3), () {
      player.stop();
    });
  }
}
