import 'package:ai_chat/views/pages/chats_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Aquí puedes decidir si cada pantalla trae su AppBar o no
    Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Tab 1')),
    ),
    Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: Center(child: Text('Tab 2')),
    ),
    ChatsPage(), // 👈 esta ya tiene su AppBar propio
    Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(child: Text('Tab 4')),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color(0xFF1EEF1E),
        selectedItemColor: Colors.deepOrange,
        selectedIconTheme: IconThemeData(size: 36),
        selectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle tab changes
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.social_distance_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tire_repair),
            label: 'Desavare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
