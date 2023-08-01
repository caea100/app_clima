import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _apiKey = "b9326cada9feb8c7064e123f8091bbdd";
  String _city = "";
  String _weatherDescription = "";
  double _temperature = 0.0;
  String _iconCode = "";

  Future<void> fetchWeatherData(String city) async {
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _city = city;
        _weatherDescription = data["weather"][0]["main"];
        _temperature = data["main"]["temp"];
        _iconCode = data["weather"][0]["icon"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool _isButtonEnabled() {
    return _city.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _city = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Procure sua cidade',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isButtonEnabled() ? () => fetchWeatherData(_city) : null,
              child: Text('Pesquisar'),
            ),
            SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  if (_iconCode.isNotEmpty)
                    Image.network(
                      "http://openweathermap.org/img/w/$_iconCode.png",
                      height: 100,
                    ),
                  Text(
                    _city,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Temperatura: $_temperature°C",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Clima: $_weatherDescription",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





/**b9326cada9feb8c7064e123f8091bbdd */