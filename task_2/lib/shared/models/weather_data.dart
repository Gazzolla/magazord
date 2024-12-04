class WeatherData {
  final double latitude;
  final double longitude;
  final double generationTimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final Current current;
  final List<Hourly> hourly;
  final List<Daily> daily;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.generationTimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      generationTimeMs: json['generationtime_ms'],
      utcOffsetSeconds: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezoneAbbreviation: json['timezone_abbreviation'],
      elevation: json['elevation'],
      current: Current.fromJson(json['current']),
      hourly: Hourly.fromJson(json['hourly']),
      daily: Daily.fromJson(json['daily']),
    );
  }
}

class Current {
  final DateTime time;
  final int interval;
  final double temperature;
  final double relativeHumidity;
  final int isDay;
  final double precipitation;
  final double rain;
  final double windSpeed;

  Current({
    required this.time,
    required this.interval,
    required this.temperature,
    required this.relativeHumidity,
    required this.isDay,
    required this.precipitation,
    required this.rain,
    required this.windSpeed,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      time: DateTime.parse(json['time']),
      interval: json['interval'],
      temperature: json['temperature_2m'].toDouble(),
      relativeHumidity: json['relative_humidity_2m'].toDouble(),
      isDay: json['is_day'],
      precipitation: json['precipitation'].toDouble(),
      rain: json['rain'].toDouble(),
      windSpeed: json['wind_speed_10m'].toDouble(),
    );
  }
}

class Hourly {
  final DateTime time;
  final double temperature;
  final double rain;

  Hourly({
    required this.time,
    required this.temperature,
    required this.rain,
  });

  static List<Hourly> fromJson(Map<String, dynamic> json) {
    List<Hourly> result = [];
    for (var i = 0; i < json['time'].length; i++) {
      result.add(Hourly(
        time: DateTime.parse(json['time'][i]),
        temperature: json['temperature_2m'][i].toDouble(),
        rain: json['rain'][i].toDouble(),
      ));
    }
    return result;
  }
}

class Daily {
  final DateTime time;
  final double temperatureMax;
  final double temperatureMin;
  final DateTime sunrise;
  final double uvIndexMax;
  final double precipitationProbabilityMax;

  Daily({
    required this.time,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.sunrise,
    required this.uvIndexMax,
    required this.precipitationProbabilityMax,
  });

  static List<Daily> fromJson(Map<String, dynamic> json) {
    List<Daily> result = [];
    for (var i = 0; i < json['time'].length; i++) {
      result.add(Daily(
        time: DateTime.parse(json['time'][i]),
        temperatureMax: json['temperature_2m_max'][i].toDouble(),
        temperatureMin: json['temperature_2m_min'][i].toDouble(),
        sunrise: DateTime.parse(json['sunrise'][i]),
        uvIndexMax: json['uv_index_max'][i],
        precipitationProbabilityMax: json['precipitation_probability_max'][i].toDouble(),
      ));
    }
    return result;
  }
}
