import 'package:flutter/material.dart';
import 'package:realtoomflix/screens/home_screen.dart';

void main() {
  //ApiService().getTodayToons(); //ApiService.getTodaytoons��� �ϸ� �ȵǴ°���?
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //--google form application
      home: HomeScreen(),
    );
  }
}
