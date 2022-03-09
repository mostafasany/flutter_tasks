import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/finance_quote_screen.dart';
import 'package:flutter_application_1/view_models/circle_view_model.dart';
import 'package:flutter_application_1/view_models/send_message_view_model.dart';
import 'package:flutter_application_1/view_models/weather_view_model.dart';
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
        ChangeNotifierProvider(create: (_) => SendMessageViewModel()),
        Provider(create: (_) => WeatherViewModel()),
      ],
      child: MaterialApp(
        title: 'flutter tasks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FinanceQuoteScreen(),
      ),
    );
  }
}
