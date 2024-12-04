import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart' hide Image;
import 'package:task_2/modules/home/home_store.dart';
import 'package:task_2/services/apiService.dart';
import 'package:task_2/shared/constants.dart';
import 'package:task_2/shared/models/day.dart';
import 'package:task_2/shared/models/weather_data.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget getWeatherIcon([int? weather, DateTime? time]) {
    if (weather == 1) {
      return Icon(WeatherIcons.rain, color: Colors.blue);
    } else if (time != null && (time.hour < 6 || time.hour >= 18)) {
      return Icon(WeatherIcons.night_clear, color: Colors.deepPurple);
    } else {
      return Icon(WeatherIcons.day_sunny, color: Colors.amber);
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeController controller = HomeController();

    void scheduleAnimation() {
      DateTime now = DateTime.now();

      DateTime targetTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour > 6 && now.hour < 18 ? 18 : 6,
        0,
        0,
      );

      if (!now.isAfter(targetTime)) {
        Duration durationUntilTarget = targetTime.difference(now);

        Future.delayed(durationUntilTarget, () {
          controller.isDayTime!.fire();
        });
      }
    }

    Future<void> loadRiveFile() async {
      final riveFile = await RiveFile.asset('assets/animations/day_to_night_switch.riv');

      final artboard = riveFile.mainArtboard.instance();
      var stateController = StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (stateController != null) {
        artboard.addController(stateController);
        controller.setIsDayTime(stateController.findSMI("Switch"));
      }
      controller.riveArtboard = artboard;
    }

    Future<Position> getCurrentLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Serviços de localização estão desativados.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Permissões de localização foram negadas');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Permissões de localização foram permanentemente negadas');
      }

      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      // Extrair o país e a cidade
      Placemark placemark = placemarks.first;
      controller.setCountry(placemark.isoCountryCode ?? 'Desconhecido');
      controller.setCity(placemark.locality ?? 'Desconhecido');

      return position;
    }

    getData() async {
      loadingBarService.start();
      Position position = await getCurrentLocation();
      Response response = await ApiService.get("&longitude=${position.longitude}&latitude=${position.latitude}");

      if (response.statusCode == 200) {
        WeatherData data = WeatherData.fromJson(response.data);
        DateTime now = DateTime.now();

        controller.curentDay.setChanceOfRain(data.current.rain > 0 ? .5 : 0);
        controller.curentDay.setHumidity(data.current.relativeHumidity);
        controller.curentDay.setTemperature(data.current.temperature);
        controller.curentDay.setWindSpeed(data.current.windSpeed);
        controller.curentDay.setUvIndex(data.daily.first.uvIndexMax);
        controller.curentDay.setMinTemperature(data.daily.first.temperatureMin);
        controller.curentDay.setMaxTemperature(data.daily.first.temperatureMax);

        controller.curentDay.setHourForecast(data.hourly
            .where((x) => x.time.hour > now.hour)
            .map((e) => HourForecast(
                  temperature: e.temperature,
                  time: e.time,
                  weather: e.rain > 0 ? 1 : 0,
                ))
            .toList());

        controller.setForecast(data.daily
            .map((day) => WeekDay(
                  day: day.time,
                  sunlight: day.sunrise,
                  chanceOfRain: day.precipitationProbabilityMax,
                  maxTemperature: day.temperatureMax,
                  minTemperature: day.temperatureMin,
                ))
            .toList());
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Atenção"),
            content: Text("Não foi possível obter os dados do clima"),
          ),
        );
      }
      loadingBarService.stop();
    }

    loadRiveFile().then((value) async {
      await getData();
      scheduleAnimation();
      if (DateTime.now().hour >= 18) {
        controller.isDayTime!.fire();
      }
    });

    return Scaffold(
        backgroundColor: Color(0xfff4f4f4),
        drawerEnableOpenDragGesture: false,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Observer(builder: (_) {
                if (controller.riveArtboard == null) return SizedBox();
                return Stack(
                  children: [
                    Rive(
                      fit: BoxFit.cover,
                      artboard: controller.riveArtboard!,
                      alignment: Alignment.topCenter,
                    ),
                    Container(color: Color.fromRGBO(0, 0, 0, .17))
                  ],
                );
              }),
            ),
            Observer(builder: (_) {
              if (!controller.raining) return SizedBox();
              return RiveAnimation.asset(
                "assets/animations/rain.riv",
                fit: BoxFit.fitHeight,
              );
            }),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Observer(builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20, left: 30, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 32,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${controller.city}, ${controller.country.toUpperCase()}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              getData();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Observer(builder: (_) {
                                if (!loadingBarService.showLoading) {
                                  return Icon(
                                    FontAwesomeIcons.arrowsRotate,
                                    color: Colors.white,
                                  );
                                }
                                return AnimatedRotation(
                                  duration: Duration(minutes: 17),
                                  turns: -999,
                                  child: Icon(
                                    FontAwesomeIcons.arrowsRotate,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 30),
                  Observer(builder: (_) {
                    return Text(
                      DateFormat("EEE, dd MMM", "pt_BR").format(controller.curentDay.day).replaceAll(".", "").capitalize(),
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    );
                  }),
                  Observer(builder: (_) {
                    return Observer(builder: (_) {
                      return Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              controller.curentDay.temperature.toStringAsFixed(0),
                              style: TextStyle(
                                height: 1,
                                color: Colors.white,
                                fontSize: 150,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 0,
                            child: Text(
                              "o",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      );
                    });
                  }),
                  Observer(
                    builder: (_) {
                      return Text(
                        "Min: ${controller.curentDay.minTemperature.toStringAsFixed(0)}° Max: ${controller.curentDay.maxTemperature.toStringAsFixed(0)}°",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Observer(builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        constraints: BoxConstraints(minHeight: 100),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, .3),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        WeatherIcons.cloud,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${controller.curentDay.chanceOfRain.toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    controller.curentDay.rainRiskCategory,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 80,
                              width: 1,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        WeatherIcons.strong_wind,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${controller.curentDay.windSpeed.toStringAsFixed(0)} km/h",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    controller.curentDay.windSpeedCategory,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 80,
                              width: 1,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sunny,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        controller.curentDay.uvIndex.toStringAsFixed(0),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    controller.curentDay.uvRiskCategory,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 40, 0, 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      ),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Observer(builder: (_) {
                              return Row(
                                children: [
                                  for (HourForecast hour in controller.curentDay.hourForecast)
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[200],
                                            ),
                                            child: getWeatherIcon(hour.weather, hour.time),
                                          ),
                                          Text(
                                            DateFormat.Hm('pt_BR').format(hour.time),
                                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "${hour.temperature.toStringAsFixed(0)}°",
                                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Amanhã",
                                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                          ),
                          Observer(builder: (_) {
                            if (controller.forecast.isEmpty) return SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200],
                                      ),
                                      child: getWeatherIcon(controller.forecast[1].chanceOfRain > 0 ? 1 : 0),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat.EEEE('pt_BR').format(controller.forecast[1].day).capitalize(),
                                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          controller.forecast[1].rainRiskCategory,
                                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: SizedBox(
                                        height: 60,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                                            Text(
                                              "${controller.forecast[1].maxTemperature.toStringAsFixed(0)}°",
                                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                            Text(
                                              "${controller.forecast[1].minTemperature.toStringAsFixed(0)}°",
                                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}