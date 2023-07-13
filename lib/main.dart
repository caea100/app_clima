import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Previsão do Tempo',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final apiKey = 'b9326cada9feb8c7064e123f8091bbdd';
  final searchController = TextEditingController();
  WeatherData? weatherData;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchWeatherData(String cityName) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = WeatherData.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Widget buildWeatherCard() {
    if (weatherData == null) {
      return Container();
    }

    return Card(
      child: Column(
        children: [
          Text(
            weatherData!.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '${weatherData!.temperature.toStringAsFixed(1)}°C',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Icon(
            getWeatherIcon(weatherData!.weatherCondition),
            size: 64,
          ),
          Text(
            weatherData!.weatherDescription,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  IconData getWeatherIcon(String weatherCondition) {
    switch (weatherCondition) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.umbrella;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsão do Tempo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Cidade',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                fetchWeatherData(searchController.text);
              },
              child: Text('Pesquisar'),
            ),
            SizedBox(height: 16),
            buildWeatherCard(),
          ],
        ),
      ),
    );
  }
}

class WeatherData {
  final String name;
  final double temperature;
  final String weatherCondition;
  final String weatherDescription;

  WeatherData({
    required this.name,
    required this.temperature,
    required this.weatherCondition,
    required this.weatherDescription,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return WeatherData(
      name: json['name'],
      temperature: main['temp'],
      weatherCondition: weather['main'],
      weatherDescription: weather['description'],
    );
  }
}