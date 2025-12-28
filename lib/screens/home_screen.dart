import 'package:flutter/material.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  Weather? _weather;

  void _getWeather() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherServices.fetchWeather(_controller.text);

      setState(() {
        _weather = weather as Weather?; // fixed here
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching weather data')),
      );
    }
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: _weather != null &&
                  _weather!.description.toLowerCase().contains('rain')
              ? const LinearGradient(
                  colors: [Colors.grey, Colors.blueGrey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter city name',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _getWeather,
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 30),

            if (_isLoading) const CircularProgressIndicator(),

            if (_weather != null && !_isLoading) ...[
              Text(
                _weather!.cityName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_weather!.temperature.toStringAsFixed(1)} °C',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _weather!.description,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Humidity',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '${_weather!.humidity}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Wind',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '${_weather?.windspeed.toStringAsFixed(1)??'0.0'} m/s',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Sunrise',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        _formatTime(_weather!.sunrise),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Sunset',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        _formatTime(_weather!.sunset),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}



