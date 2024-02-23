import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//виджет с 3д картинкой и фиолетовой тенью сзади для weather_screen

// ignore: must_be_immutable
class WeatherIndicator extends StatelessWidget {
  bool selected;
  DateTime dateTime;
  num temperature;
  String iconName;

  WeatherIndicator(
      {super.key,
      required this.selected,
      required this.dateTime,
      required this.temperature,
      required this.iconName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: Colors.white) : null,
          color: selected ? Colors.white.withOpacity(.3) : null),
      child: Column(
        children: [
          Text(DateFormat('HH:mm').format(dateTime)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.asset(
              'assets/images/2d/$iconName.png',
              errorBuilder: (context, error, stackTrace) {
                return const Text("❓");
              },
            ),
          ),
          Text('$temperature°')
        ],
      ),
    );
  }
}
