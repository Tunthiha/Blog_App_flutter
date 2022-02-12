import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/post_data.dart';
import 'package:provider/provider.dart';

import 'screens/loading.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PostData())],
      child: MaterialApp(
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
      ),
    );
  }
}
