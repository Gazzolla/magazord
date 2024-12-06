import 'package:mobx/mobx.dart';
part 'day.g.dart';

class WeekDay = _WeekDayBase with _$WeekDay;

abstract class _WeekDayBase with Store {
  _WeekDayBase(
      {required this.day,
      this.chanceOfRain = 0,
      this.humidity = 0,
      this.windSpeed = 0,
      this.temperature = 0,
      required this.sunlight,
      this.maxTemperature = 0,
      this.minTemperature = 0});

  late DateTime day;

  DateTime sunlight;

  @observable
  ObservableList<HourForecast> hourForecast = <HourForecast>[].asObservable();

  @action
  setHourForecast(List<HourForecast> value) => hourForecast = value.asObservable();

  @observable
  double temperature = 0;

  @observable
  double minTemperature = 0;

  @observable
  double maxTemperature = 0;

  @observable
  double chanceOfRain = 0;

  @observable
  double humidity = 0;

  @observable
  double windSpeed = 0;

  @observable
  double uvIndex = 0;

  @action
  setUvIndex(double value) => uvIndex = value;

  @action
  setTemperature(double value) => temperature = value;

  @action
  setMinTemperature(double value) => minTemperature = value;

  @action
  setMaxTemperature(double value) => maxTemperature = value;

  @action
  setChanceOfRain(double value) => chanceOfRain = value;

  @action
  setHumidity(double value) => humidity = value;

  @action
  setWindSpeed(double value) => windSpeed = value;

  String get windSpeedCategory {
    if (windSpeed >= 0 && windSpeed <= 19) {
      return "Calmo";
    } else if (windSpeed >= 20 && windSpeed <= 39) {
      return "Brisa Leve";
    } else if (windSpeed >= 40 && windSpeed <= 59) {
      return "Brisa Forte";
    } else if (windSpeed >= 60 && windSpeed <= 88) {
      return "Vento Moderado";
    } else if (windSpeed >= 89 && windSpeed <= 117) {
      return "Vento Forte";
    } else if (windSpeed >= 118) {
      return "Tempestade";
    } else {
      return "Valor inválido";
    }
  }

  String get rainRiskCategory {
    if (chanceOfRain >= 0 && chanceOfRain <= 20) {
      return "Pouca Chance";
    } else if (chanceOfRain >= 21 && chanceOfRain <= 40) {
      return "Chance Moderada";
    } else if (chanceOfRain >= 41 && chanceOfRain <= 60) {
      return "Chance Alta";
    } else if (chanceOfRain >= 61 && chanceOfRain <= 80) {
      return "Chance Muito Alta";
    } else if (chanceOfRain >= 81 && chanceOfRain <= 100) {
      return "Chance Extrema";
    } else {
      return "N/A";
    }
  }

  String get uvRiskCategory {
    if (uvIndex >= 0 && uvIndex <= 2) {
      return "Baixo";
    } else if (uvIndex >= 3 && uvIndex <= 5) {
      return "Moderado";
    } else if (uvIndex >= 6 && uvIndex <= 7) {
      return "Alto";
    } else if (uvIndex >= 8 && uvIndex <= 10) {
      return "Muito Alto";
    } else if (uvIndex >= 11) {
      return "Extremamente Alto";
    } else {
      return "N/A";
    }
  }
}

class HourForecast {
  double temperature;
  DateTime time;
  int weather;

  HourForecast({
    required this.temperature,
    required this.time,
    required this.weather,
  });
}
