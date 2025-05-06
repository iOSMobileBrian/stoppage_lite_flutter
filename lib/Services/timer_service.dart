import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stoppage_lite/Constants/timer_constants.dart';

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
        playAudioForThreeSeconds(hornAudioPath);
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

  Future<void> playAudioForThreeSeconds(String audioPath) async {
    final player = AudioPlayer();
    await player.setAudioSource(AudioSource.asset(audioPath));
    await player.play();
    Timer(const Duration(seconds: 3), () {
      player.stop();
    });
  }
}
