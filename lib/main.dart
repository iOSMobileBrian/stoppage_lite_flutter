import 'package:flutter/material.dart';
import 'package:stoppage_lite/Screens/timer_page.dart';
import 'package:provider/provider.dart';
import 'package:stoppage_lite/Services/timer_service.dart';
import 'package:stoppage_lite/Services/child_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final childService = ChildService();
  await childService.loadData();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TimerService(seconds: 60)),
    ChangeNotifierProvider.value(value: childService),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoppageLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerPage(),
    );
  }
}
