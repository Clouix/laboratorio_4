import 'package:flutter/material.dart';
import 'package:laboratorio_4/screens/info_screen.dart';
import 'package:laboratorio_4/screens/links_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LinksScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/link-info') {
          final uri = Uri.parse(settings.arguments as String);
          return MaterialPageRoute(
            builder: (context) => LinkInfoScreen(
              name: uri.queryParameters['name'] ?? '',
              age: uri.queryParameters['age'] ?? '',
              football: uri.queryParameters['football'] ?? '',
              favoriteTeam: uri.queryParameters['favoriteTeam'] ?? '',
              location: uri.queryParameters['location'] ?? '',
            ),
          );
        }
      },
    );
  }
}
