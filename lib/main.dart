import 'package:flutter/material.dart';
import 'package:tic_tac_toe/main_screen.dart';
import 'package:tic_tac_toe/start_online_mode.dart';
import 'classic_game.dart';

void main (){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      routes: {
        "/classic": (_) => ClassicGame() ,
        "/online": (_) => StartPage() ,
      },
      home: MainScreen(),
    );
  }
}
