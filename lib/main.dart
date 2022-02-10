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
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(secondary: Color(0xFF3f37cc)),
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF3f37cc),
              iconTheme: IconThemeData(color: Colors.white))),
      debugShowCheckedModeBanner: false,
      home: const Loading(),
    );
  }
}
