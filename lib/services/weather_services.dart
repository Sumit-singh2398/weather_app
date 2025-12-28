import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/Models/weather_model.dart';

class WeatherServices {
  final String apikey = '94504a63ba37897cd2b2388950ce9f34';

  Future<Weather> fetchWeather(String cityName) async {
    final uri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikey',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}


