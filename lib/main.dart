import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/circle_screen.dart';
import 'package:flutter_application_1/view_models/circle_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CircleViewModel()),
      ],
      child: MaterialApp(
        title: 'flutter tasks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CircleScreen(),
      ),
    );
  }
}
