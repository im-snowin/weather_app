import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

Future main() async {
  await dotenv.load();

  runApp(const MaterialApp(
    title: 'Snow Weather cast',
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var API_ENDPOINT = "https://api.openweathermap.org/data/2.5/weather";
  var API_KEY = dotenv.env['API_KEY'];
  var city = 'Tirunelveli';

  Future getWeather() async {
    http.Response response = await http
        .get(Uri.parse("$API_ENDPOINT?q=$city&units=metric&appid=$API_KEY"));
    var results = jsonDecode(response.body);

    setState(() {
      temp = results['main']['temp'];
      description = results['weather'][0]['description'];
      currently = results['weather'][0]['main'];
      humidity = results['main']['humidity'];
      windspeed = results['wind']['speed'];
    });
  }

  @override
  initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Current weather in $city",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  temp != null ? "$temp\u00B0" : "Loading",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    currently != null ? "$currently\u00B0" : "Loading",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.temperatureHalf),
                    title: const Text('Temperature'),
                    trailing: Text(temp != null ? "$temp\u00B0" : "Loading"),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.cloud),
                    title: const Text('Weather'),
                    trailing: Text(
                      description != null ? "$description" : "Loading",
                    ),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.sun),
                    title: const Text("Humidity"),
                    trailing: Text(humidity != null ? "$humidity" : "Loading"),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.wind),
                    title: const Text('Wind Speed'),
                    trailing:
                        Text(windspeed != null ? "$windspeed" : "Loading"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
