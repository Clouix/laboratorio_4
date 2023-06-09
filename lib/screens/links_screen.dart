import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:laboratorio_4/screens/info_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksScreen extends StatefulWidget {
  const LinksScreen({Key? key}) : super(key: key);

  @override
  _LinksScreenState createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _footballController = TextEditingController();
  TextEditingController _favoriteTeamController = TextEditingController();

  String _location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generador de Links'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Edad'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu edad';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _footballController,
                decoration: InputDecoration(labelText: '¿Te gusta el fútbol?'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa si te gusta el fútbol';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _favoriteTeamController,
                decoration: InputDecoration(labelText: 'Equipo favorito'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu equipo favorito';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  print('Generar enlace button pressed');
                  if (_formKey.currentState!.validate()) {
                    _getLocation().then((location) {
                      String name = _nameController.text;
                      String age = _ageController.text;
                      String football = _footballController.text;
                      String favoriteTeam = _favoriteTeamController.text;

                      String link = _generateLink(
                          name, age, football, favoriteTeam, location);

                      _launchTelegram(link);
                    });
                  }
                },
                child: Text('Generar enlace'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return '${position.latitude},${position.longitude}';
  }

  String _generateLink(String name, String age, String football,
      String favoriteTeam, String location) {
    String encodedName = Uri.encodeComponent(name);
    String encodedAge = Uri.encodeComponent(age);
    String encodedFootball = Uri.encodeComponent(football);
    String encodedFavoriteTeam = Uri.encodeComponent(favoriteTeam);
    String encodedLocation = Uri.encodeComponent(location);

    String queryString =
        'name=$encodedName&age=$encodedAge&football=$encodedFootball&favoriteTeam=$encodedFavoriteTeam&location=$encodedLocation';

    String link = 'myapp://example.com/?$queryString';

    return link;
  }

  void _parseLink(Uri uri) {
    String name = uri.queryParameters['name'] ?? '';
    String age = uri.queryParameters['age'] ?? '';
    String football = uri.queryParameters['football'] ?? '';
    String favoriteTeam = uri.queryParameters['favoriteTeam'] ?? '';
    String location = uri.queryParameters['location'] ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LinkInfoScreen(
          name: name,
          age: age,
          football: football,
          favoriteTeam: favoriteTeam,
          location: location,
        ),
      ),
    );
  }

  void _launchTelegram(String link) async {
    String encodedLink = Uri.encodeComponent(link);
    String telegramUrl = 'tg://msg?text=$encodedLink';

    try {
      if (await canLaunch(telegramUrl)) {
        print('Telegram launch condition met');
        await launch(telegramUrl, forceSafariVC: false);
        Navigator.pushNamed(context, '/link-info', arguments: link);
      } else {
        throw 'No se puede abrir Telegram';
      }
    } catch (e) {
      String errorMessage = 'Error al abrir Telegram: $e';
      print(errorMessage);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
