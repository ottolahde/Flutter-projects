import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      title: 'Weather app',
      initialRoute: '/',
      routes: {
        '/': (context) => const CurrentWeatherScreen(),
        '/second': (context) => const ForecastScreen(),
      },
    ),
  );
}

class CurrentWeatherScreen extends StatefulWidget {
  const CurrentWeatherScreen({Key? key}) : super(key: key);

  @override
  State<CurrentWeatherScreen> createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  @override
  static const String apiKey = "5bf8f6840ca09945410e569e5fa3352a";
  static const String openWeatherMapURL =
      "https://api.openweathermap.org/data/2.5/weather";
  String cityName = "Tampere";
  String currentWeather = "-";
  double temperature = 0;
  double windSpeed = 0;
  int condition = 0;
  TextEditingController cityController = TextEditingController();

  void fetchWeatherData() async {
    Uri uri =
        Uri.parse("$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        temperature = weatherData['main']['temp'];
        currentWeather = weatherData['weather'][0]['description'];
        condition = weatherData['weather'][0]['id'];
        windSpeed = weatherData['wind']['speed'];
      });
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather app"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                child: TextField(
              controller: cityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City name',
              ),
              onChanged: (text) {
                setState(() {
                  cityName = text;
                });
              },
            )),
            Text(cityName, style: const TextStyle(fontSize: 60)),
            Text(currentWeather + getWeatherIcon(condition), style: const TextStyle(fontSize: 40)),
            
            Text('$temperature C', style: const TextStyle(fontSize: 40)),
            Text('$windSpeed m/s', style: const TextStyle(fontSize: 40)),
            ElevatedButton(
                onPressed: () {
                  fetchWeatherData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Loading weather data ..')),
                  );
                },
                child: const Text('Get current weather')),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('Forecast'),
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast'),
      ),
      body: Center(
        child: ElevatedButton(
          // Within the SecondScreen widget
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
