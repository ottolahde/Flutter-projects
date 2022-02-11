import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'networking.dart';
import 'weather.dart';
import 'package:saappi/utilities/constants.dart';
import 'package:saappi/main.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Saappi',
    home: MaterialApp(),
  ));
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

// jutut
WeatherModel weather = WeatherModel();
int temperature = 0;
String weatherIcon = '';
String cityName = '';
String weatherMessage = '';

void updateUI(dynamic weatherData) {
  if (weatherData == null) {
    temperature = 0;
    weatherIcon = 'Error';
    weatherMessage = "Couldn't get weather data.";
    cityName = '';
    return;
  }
  var temp = weatherData['main']['temp'];
  temperature = temp.toInt();
  cityName = weatherData['name'];
  int condition = weatherData['weather'][0]['id'];
  weatherIcon = weather.getWeatherIcon(condition);
  weatherMessage = weather.getMessage(temperature);
}

///

class _FirstRouteState extends State<FirstRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather app'),
        
      ),
      
      
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [

              ElevatedButton(
                child: const Text('Live sää'),
                onPressed: () async {
                  //pitäis tehä jotain
                  print('Nappi painettu');
                  await weather.getCityWeather('Tampere');
                  updateUI(weather);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    ////   const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    // textStyle: const TextStyle(fontSize: 30)
                    ),
              ),

              ElevatedButton(
                child: const Text('Sääennuste'),
                onPressed: () {
                  print('Sääennuste painettu');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecondRoute()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                    // padding:
                      //  const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    //textStyle: const TextStyle(fontSize: 30)
                    ),
              ),
                
                  
                Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
              
            ],
            
          ),

          

        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sääennuste'),
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
