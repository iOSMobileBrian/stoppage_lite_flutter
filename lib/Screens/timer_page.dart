import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoppage_lite/Constants/timer_constants.dart';
import 'package:stoppage_lite/Services/timer_service.dart';
import 'package:stoppage_lite/Widgets/elev_btn.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool hasStarted = false;
  bool hasEnded = false;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TimerService>(context);
    var secondsLeft = Duration(seconds: vm.seconds).inSeconds.remainder(60);
    var minLeft = Duration(seconds: vm.seconds).inMinutes.remainder(60);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 50.0,
        actions: [IconButton(onPressed: ()=> vm.playAudioForThreeSeconds(), icon: const Icon(Icons.access_alarms))],
        title: const Text('Stoppage'),
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.restore),
          onPressed: () => vm.reset(),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              '${minLeft.toString().padLeft(2, "0")}:${secondsLeft.toString().padLeft(2, "0")}',
              style: const TextStyle(color: Colors.white, fontSize: 70, fontWeight: FontWeight.bold),
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
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevBtn(
                        timeLabel: kFiveMinutes,
                        onPress: () => setState(() {
                              vm.addTime(300);
                            }),
                        primary: Colors.red),
                    ElevBtn(timeLabel: kThreeMinutes, onPress: () => vm.addTime(180), primary: Colors.redAccent),
                    ElevBtn(timeLabel: kOneMinutes, onPress: () => vm.addTime(60), primary: Colors.deepOrange),
                    ElevBtn(timeLabel: kThirtySeconds, onPress: () => vm.addTime(30), primary: Colors.deepOrangeAccent),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
