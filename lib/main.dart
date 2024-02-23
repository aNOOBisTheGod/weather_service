import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_service/presentation/pages/splash_screen.dart';

void main() async {
  GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashScreenPage(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0700ff)),
          dialogBackgroundColor: Colors.grey,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff0700ff)),
                  foregroundColor: MaterialStateProperty.all(Colors.white))),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(fontSize: 15),
          ),
          // темы для текста из фигмы
          textTheme: TextTheme(
              titleLarge: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 48,
                      color: Colors.white)),
              titleMedium: GoogleFonts.inter(
                textStyle: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              headlineMedium: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w500)),
              bodyLarge: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontSize: 17,
              )),
              bodyMedium: GoogleFonts.roboto(
                  textStyle:
                      const TextStyle(fontSize: 17, color: Colors.white)),
              bodySmall: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 15, color: Color(0xff8799a5))))),
    );
  }
}
