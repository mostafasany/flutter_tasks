import 'package:weather/weather.dart';

class WeatherViewModel {
  Weather? w;
  Future<void> getWeather() async {
    final double lat = 25.616763;
    final double lon = 29.441032;
    final String key = '3d8c4173b5086720a00f5966da080a9a';
    WeatherFactory wf = new WeatherFactory(key);
    w = await wf.currentWeatherByLocation(lat, lon);
  }
}
