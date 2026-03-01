import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoppage_lite/Constants/timer_constants.dart';
import 'package:stoppage_lite/Models/timeout_log.dart';
import 'package:stoppage_lite/Screens/child_list_page.dart';
import 'package:stoppage_lite/Screens/child_select_page.dart';
import 'package:stoppage_lite/Services/child_service.dart';
import 'package:stoppage_lite/Services/timer_service.dart';
import 'package:stoppage_lite/Widgets/child_avatar.dart';
import 'package:stoppage_lite/Widgets/elev_btn.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool hasStarted = false;
  bool hasEnded = false;
  bool _hasLoggedCurrentSession = false;

  void _onTimerTick() {
    final vm = Provider.of<TimerService>(context, listen: false);
    if (vm.seconds == 0 && vm.elapsedSeconds > 0 && !_hasLoggedCurrentSession) {
      _hasLoggedCurrentSession = true;
      _logTimeout(vm.elapsedSeconds);
    }
  }

  void _logTimeout(int durationSeconds) {
    final childService = Provider.of<ChildService>(context, listen: false);
    final child = childService.selectedChild;
    if (child == null) return;

    final log = TimeoutLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: child.id,
      dateTime: DateTime.now(),
      durationSeconds: durationSeconds,
    );
    childService.addLog(log);

    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    final durStr = '${minutes}m ${seconds}s';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timeout logged for ${child.name}: $durStr'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TimerService>(context);
    final childService = Provider.of<ChildService>(context);
    var secondsLeft = Duration(seconds: vm.seconds).inSeconds.remainder(60);
    var minLeft = Duration(seconds: vm.seconds).inMinutes.remainder(60);

    // Check if timer just hit zero
    if (vm.seconds == 0 && vm.elapsedSeconds > 0 && !_hasLoggedCurrentSession) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onTimerTick());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 50.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.restore),
          onPressed: () {
            vm.reset();
            _hasLoggedCurrentSession = false;
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChildSelectPage()),
            ),
            icon: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChildListPage()),
            ),
            icon: const Icon(Icons.people, color: Colors.white, size: 30),
          ),
          IconButton(
            onPressed: () =>
                vm.playAudioForThreeSeconds(warningAudioPath),
            icon: const Icon(Icons.warning, color: Colors.orange, size: 40),
          ),
        ],
        title: const Text('Stoppage'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (childService.selectedChild != null) ...[
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChildSelectPage()),
                ),
                child: Column(
                  children: [
                    ChildAvatar(
                        emoji: childService.selectedChild!.avatar,
                        size: 48),
                    const SizedBox(height: 4),
                    Text(
                      childService.selectedChild!.name,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ] else
              const SizedBox(height: 20),
            Text(
              '${minLeft.toString().padLeft(2, "0")}:${secondsLeft.toString().padLeft(2, "0")}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                setState(() {
                  vm.timer?.isActive == true ? vm.stop() : vm.start();
                });
              },
              child: Container(
                width: 90,
                height: 90,
                alignment: Alignment.center,
                child: vm.timer?.isActive == true ? pause : play,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevBtn(
                      timeLabel: kFiveMinutes,
                      onPress: () => setState(() {
                            vm.addTime(300);
                          }),
                      primary: Colors.red),
                  ElevBtn(
                      timeLabel: kThreeMinutes,
                      onPress: () => vm.addTime(180),
                      primary: Colors.redAccent),
                  ElevBtn(
                      timeLabel: kOneMinutes,
                      onPress: () => vm.addTime(60),
                      primary: Colors.deepOrange),
                  ElevBtn(
                      timeLabel: kThirtySeconds,
                      onPress: () => vm.addTime(30),
                      primary: Colors.deepOrangeAccent),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
