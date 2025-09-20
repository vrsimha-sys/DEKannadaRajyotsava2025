import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/player_roster_page.dart';
import 'pages/team_formation_page.dart';
import 'pages/battle_day_page.dart';
import 'widgets/navigation/main_navigation.dart';

void main() {
  runApp(const DEKannadaRajyotsavaApp());
}

class DEKannadaRajyotsavaApp extends StatelessWidget {
  const DEKannadaRajyotsavaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DE Badminton - Kannada Rajyotsava Cup - 2025',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF9933), // Karnataka flag color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
        '/home': (context) => const HomePage(),
        '/roster': (context) => const PlayerRosterPage(),
        '/formation': (context) => const TeamFormationPage(),
        '/battle': (context) => const BattleDayPage(),
      },
    );
  }
}