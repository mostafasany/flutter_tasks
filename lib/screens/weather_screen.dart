import 'package:flutter/material.dart';
import 'package:flutter_application_1/view_models/weather_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  Weather? weather;
  @override
  void initState() {
    Provider.of<WeatherViewModel>(context, listen: false)
        .getWeather()
        .then((_) {
      isLoading = false;
      weather = Provider.of<WeatherViewModel>(context, listen: false).w;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  final TextStyle _textStyle = TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Container(
                  height: 120.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://assets.heart.co.uk/2017/28/weather-1499781833-herowidev4-0.jpg'),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black12, Colors.black12],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                weather!.areaName ?? 'area name',
                                style: _textStyle,
                              ),
                              Text(
                                DateFormat.jm().format(
                                  weather!.date ?? DateTime.now(),
                                ),
                                style: _textStyle.copyWith(
                                    fontSize: 12, color: Colors.grey.shade300),
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              Text(
                                weather!.weatherDescription ?? 'desctiption',
                                style: _textStyle.copyWith(
                                    fontSize: 14, color: Colors.grey.shade300),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                weather!.temperature!.celsius!
                                        .toStringAsFixed(0) +
                                    '°',
                                style: _textStyle.copyWith(fontSize: 24),
                              ),
                              Text(
                                'H:${weather!.tempMax!.celsius!.toStringAsFixed(0)} L:${weather!.tempMin!.celsius!.toStringAsFixed(0)}',
                                style: _textStyle.copyWith(
                                    fontSize: 14, color: Colors.grey.shade300),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
