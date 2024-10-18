import 'package:flutter/material.dart';
import 'package:yescabank/screens/activity.dart';
import 'package:yescabank/screens/home.dart';
import 'package:yescabank/screens/my_cart.dart';
import 'package:yescabank/screens/profile.dart';
import 'package:yescabank/screens/scan.dart';
import 'package:yescabank/services/token_storage.dart';

import 'screens/login.dart';
import 'screens/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yesca Bank",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 16, 80, 98)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignup = false;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    final token = await TokenStorage().getToken();
    setState(() {
      isAuthenticated = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isAuthenticated) {
      return const MainPage();
    } else {
      return isSignup
          ? SignupPage(
        onSignupSuccess: () {
          setState(() {
            isSignup = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signup successful! Please login.")),
          );
        },
        onSwitchToLogin: () {
          setState(() {
            isSignup = false;
          });
        },
      )
          : LoginPage(
        onLoginSuccess: () async {
          // Guardamos el token y redirigimos a la MainPage
          final token = await TokenStorage().getToken();
          if (token != null) {
            setState(() {
              isAuthenticated = true;
            });
          }
        },
        onSwitchToSignup: () {
          setState(() {
            isSignup = true;
          });
        },
      );
    }
  }
}


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const Home(),
    const MyCardPage(),
    const ScanPage(),
    const ActivityPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            tabItem(Icons.home, "Home", 0),
            tabItem(Icons.credit_card, "My Account", 1),
            FloatingActionButton(
              onPressed: () => onTabTapped(2),
              backgroundColor: const Color.fromARGB(255, 16, 80, 98),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
            ),
            tabItem(Icons.bar_chart, "Activity", 3),
            tabItem(Icons.person, "Profile", 4),
          ],
        ),
      ),
    );
  }

  Widget tabItem(IconData icon, String label, int index) {
    return IconButton(
      onPressed: () => onTabTapped(index),
      icon: Column(
        children: [
          Icon(
            icon,
            color: currentIndex == index ? Colors.black : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: currentIndex == index ? Theme.of(context).primaryColor : Colors.grey),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}