import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkInfoScreen extends StatelessWidget {
  final String name;
  final String age;
  final String football;
  final String favoriteTeam;
  final String location;

  LinkInfoScreen({
    required this.name,
    required this.age,
    required this.football,
    required this.favoriteTeam,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Enlace'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Nombre'),
            subtitle: Text(name),
          ),
          ListTile(
            title: Text('Edad'),
            subtitle: Text(age),
          ),
          ListTile(
            title: Text('¿Te gusta el fútbol?'),
            subtitle: Text(football),
          ),
          ListTile(
            title: Text('Equipo favorito'),
            subtitle: Text(favoriteTeam),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Ubicación: $location',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              launchMapsUrl(); // Llama a la función para abrir Google Maps
            },
            child: Text('Mostrar Mapa'),
          ),
        ],
      ),
    );
  }

  void launchMapsUrl() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la aplicación de Google Maps.';
    }
  }
}
