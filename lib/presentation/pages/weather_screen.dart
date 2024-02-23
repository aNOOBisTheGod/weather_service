import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather_service/data/api/geocoder.dart';
import 'package:weather_service/data/api/get_weather.dart';
import 'package:weather_service/data/models/weather.dart';
import 'package:weather_service/presentation/widgets/weather_indicator.dart';
import 'package:weather_service/presentation/widgets/weather_picture.dart';

class ForecastController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList forecast = [].obs;
  RxBool isPermissionDenied = false.obs;

  loadForecast(List forecastData) => forecast.value = forecastData;

  changeForecastIndex(int index) => selectedIndex.value = index;

  locationPermissionGranted() => isPermissionDenied.value = true;

  locationPermissionDenied() => isPermissionDenied.value = false;
}

// ignore: must_be_immutable
class WeatherPageScreen extends StatelessWidget {
  WeatherPageScreen({super.key});

  final ForecastController _forecastController = Get.put(ForecastController());
  late String city;

  Future<void> getForecast() async {
    List forecast = [];
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      _forecastController.locationPermissionDenied();
      return;
    }

    Position location = await Geolocator.getCurrentPosition();
    Map forecastData = (await GetWeatherAPI().getWeatherForecast(
      location.latitude,
      location.longitude,
    ));
    for (var weatherData in forecastData['list']) {
      forecast.add(Weather.fromApi(weatherData));
    }

    city =
        await Geocoder().decodeLocationRussian(forecastData['city']['name']) ??
            forecastData['city']['name'].toString();

    _forecastController.loadForecast(forecast);
  }

  @override
  Widget build(BuildContext context) {
    getForecast();
    initializeDateFormatting();

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color(0xff010102),
          Color(0xff131081),
        ],
        begin: Alignment.bottomRight,
      )),
      child: Obx(() => _forecastController.forecast.isEmpty
          ? _forecastController.isPermissionDenied.value
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .6,
                    child: Text(
                      "Приложению нужен доступ к Вашей локации для определения погоды",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 27.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      Text(city),
                    ],
                  ),
                ),
                Column(children: [
                  WeatherPictureWidget(
                    pictureName: _forecastController
                        .forecast[_forecastController.selectedIndex.value]
                        .iconType,
                  ),
                  Text(
                    "${_forecastController.forecast[_forecastController.selectedIndex.value].temperature}°",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(_forecastController
                      .forecast[_forecastController.selectedIndex.value]
                      .description),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      "Макс.: ${_forecastController.forecast[_forecastController.selectedIndex.value].temperatureMax}° Мин.: ${_forecastController.forecast[_forecastController.selectedIndex.value].temperatureMin}°")
                ]),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.white.withOpacity(.3)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    int daysBetweenDates = DateUtils.dateOnly(
                                            _forecastController
                                                .forecast[_forecastController
                                                    .selectedIndex.value]
                                                .dateTime)
                                        .difference(
                                            DateUtils.dateOnly(DateTime.now()))
                                        .inDays;
                                    late String dateSign;

                                    if (daysBetweenDates == 0) {
                                      dateSign = 'Сегодня';
                                    } else if (daysBetweenDates == 1) {
                                      dateSign = 'Завтра';
                                    } else {
                                      if (daysBetweenDates >= 5) {
                                        dateSign =
                                            'Через $daysBetweenDates дней';
                                      } else {
                                        dateSign =
                                            'Через $daysBetweenDates дня';
                                      }
                                    }
                                    return Text(
                                      dateSign,
                                      key: ValueKey(dateSign),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(fontWeightDelta: 200),
                                    );
                                  }),
                                  Obx(() => Text(DateFormat.MMMMd('ru').format(
                                      _forecastController
                                          .forecast[_forecastController
                                              .selectedIndex.value]
                                          .dateTime)))
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 2,
                              color: Colors.white.withOpacity(.5),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16),
                                child: SizedBox(
                                  height: 130,
                                  child: Obx(
                                    () => ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount:
                                            _forecastController.forecast.length,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                                onTap: () {
                                                  _forecastController
                                                      .changeForecastIndex(
                                                          index);
                                                },
                                                child: Obx(
                                                  () => WeatherIndicator(
                                                      key: ValueKey(
                                                          _forecastController
                                                                  .selectedIndex *
                                                              index),
                                                      selected: _forecastController
                                                              .selectedIndex ==
                                                          index,
                                                      dateTime:
                                                          _forecastController
                                                              .forecast[index]
                                                              .dateTime,
                                                      temperature:
                                                          _forecastController
                                                              .forecast[index]
                                                              .temperature,
                                                      iconName:
                                                          _forecastController
                                                              .forecast[index]
                                                              .iconType),
                                                ))),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration:
                            BoxDecoration(color: Colors.white.withOpacity(.3)),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Icon(
                                          Icons.air,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${_forecastController.forecast[_forecastController.selectedIndex.value].windSpeed} м/с",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    )),
                                Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.water_drop_outlined,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${_forecastController.forecast[_forecastController.selectedIndex.value].humidity}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  );
                                })
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Ветер ${_forecastController.forecast[_forecastController.selectedIndex.value].windDegreeName}"),
                                    Text(
                                        "${_forecastController.forecast[_forecastController.selectedIndex.value].humidity > 75 ? 'Высокая' : _forecastController.forecast[_forecastController.selectedIndex.value].humidity < 25 ? "Низкая" : "Умеренная"} влажность")
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
    ));
  }
}
