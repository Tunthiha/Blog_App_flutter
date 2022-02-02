import 'package:flutter/material.dart';

import 'screens/loading.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xFF4C4F5E),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF80FFF0),
          )),
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}
