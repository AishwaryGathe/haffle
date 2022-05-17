import 'package:flutter/material.dart';
import 'package:haffle/screens/login_screen.dart';
import 'package:haffle/screens/registration_screen.dart';
import 'package:haffle/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:haffle/screens/welcome_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
          textTheme: const TextTheme(
              bodyText1: TextStyle(color: Colors.black)
          )
      ),
      home: AnimatedSplashScreen(
          duration: 1000,
          splash: 'images/logo.png',
          splashIconSize: 150,
          nextScreen:WelcomeScreen() ,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.black),
      // textTheme: TextTheme(
      //   body1: TextStyle(color: Colors.black54),
      // ),

      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen' : (context) => LoginScreen(),
        'chat_screen' : (context) => ChatScreen(),
      },
    );
  }
}