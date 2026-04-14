import 'package:flutter/material.dart';
import 'package:individual_project/screens/main_screen_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DogProvider(),
    );
  }
}