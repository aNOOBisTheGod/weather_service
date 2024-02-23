// класс погоды, получаемой через API

class Weather {
  DateTime dateTime;
  num temperature;
  num temperatureMax;
  num temperatureMin;
  num humidity;
  num windSpeed;
  String description;
  String iconType;
  String windDegreeName;

  Weather({
    required this.dateTime,
    required this.temperature,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconType,
    required this.windDegreeName,
  });

  factory Weather.fromApi(data) {
    late String tmpWindDegreeName;
    if (data['wind']['deg'] >= 0 && data['wind']['deg'] < 22) {
      tmpWindDegreeName = "северный";
    } else if (data['wind']['deg'] < 67) {
      tmpWindDegreeName = 'северо-восточный';
    } else if (data['wind']['deg'] < 112) {
      tmpWindDegreeName = 'восточный';
    } else if (data['wind']['deg'] < 157) {
      tmpWindDegreeName = 'юго-восточный';
    } else if (data['wind']['deg'] < 202) {
      tmpWindDegreeName = 'южный';
    } else if (data['wind']['deg'] < 247) {
      tmpWindDegreeName = 'юго-западный';
    } else if (data['wind']['deg'] < 292) {
      tmpWindDegreeName = 'западный';
    } else if (data['wind']['deg'] < 337) {
      tmpWindDegreeName = 'северо-западный';
    } else {
      tmpWindDegreeName = 'северный';
    }
    return Weather(
        dateTime: DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000),
        temperature: data['main']['temp'],
        temperatureMax: data['main']['temp_max'],
        temperatureMin: data['main']['temp_min'],
        humidity: data['main']['humidity'],
        windSpeed: data['wind']['speed'],
        description: data['weather'][0]['description'],
        iconType: data['weather'][0]['main'],
        windDegreeName: tmpWindDegreeName);
  }
}
