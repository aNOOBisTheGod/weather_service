import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:weather_service/data/auth/authorization_manager.dart';
import 'package:weather_service/presentation/pages/authorization_screen.dart';
import 'package:weather_service/presentation/pages/weather_screen.dart';

// экран, который показывается при входе в приложение
class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (AuthorizationManager().checkAuth()) {
        Get.off(() => WeatherPageScreen(), transition: Transition.fadeIn);
        return;
      }
      Get.off(() => AuthorizationPageScreen(), transition: Transition.fadeIn);
    });
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color(0xff0701fd),
            ],
            transform: GradientRotation(-.5),
            begin: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .4,
              ),
              Text(
                "WEATHER SERVICE",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .3,
              ),
              Text(
                "dawn is coming soon",
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
