import 'package:blogapp/pages/feedpage.dart';
import 'package:blogapp/pages/loginpage.dart';
import 'package:blogapp/pages/registerpage.dart';
import 'package:blogapp/widgets/bottombarwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: GoogleFonts.hankenGrotesk().fontFamily),
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginPage(),
        "/register": (context) => const RegisterPage(),
        "/home": (context) => const BottomBarWidget(),
      },
    );
  }
}
