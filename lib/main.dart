import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String _apiKey = "b9326cada9feb8c7064e123f8091bbdd";
  final TextEditingController _textEditingController = TextEditingController();
  String _city = "";
  String _weatherDescription = "";
  double _temperature = 0.0;
  String _iconCode = "";
  bool _isWeatherLoaded = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherData(String city) async {
    setState(() {
      _isLoading = true;
      _isWeatherLoaded = false;
    });

    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _city = city;
          _weatherDescription = data["weather"][0]["main"];
          _temperature = data["main"]["temp"];
          _iconCode = data["weather"][0]["icon"];
          _isWeatherLoaded = true;
        });
      }
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTextFieldChanged(String value) {
    setState(() {
      _isWeatherLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              onChanged: _onTextFieldChanged,
              decoration: InputDecoration(
                labelText: 'Procure sua cidade',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _textEditingController.text.isNotEmpty
                      ? () => _fetchWeatherData(_textEditingController.text)
                      : null,
              child: Text('Pesquisar'),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_isWeatherLoaded)
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Temperatura: $_temperature°C",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Clima: $_weatherDescription",
                      style: TextStyle(fontSize: 20),
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
