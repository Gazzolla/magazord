import 'package:mobx/mobx.dart';
import 'package:rive/rive.dart';
import 'package:task_2/shared/constants.dart';
import 'package:task_2/shared/models/day.dart';
part 'home_store.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  WeekDay curentDay = WeekDay(day: DateTime.now(), sunlight: DateTime.now());

  @observable
  Artboard? backgroudArtboard;

  @observable
  Artboard? switchArtboard;

  @observable
  bool raining = false;

  @observable
  SMITrigger? dayLightTrigger;

  @observable
  SMIBool? themeSwitchTrigger;

  @observable
  String city = '';

  @observable
  String country = '';

  @observable
  double latitude = 0;

  @observable
  double longitude = 0;

  @observable
  ObservableList<WeekDay> forecast = <WeekDay>[].asObservable();

  @observable
  bool disableDaylightButton = false;

  @action
  setForecast(List<WeekDay> value) => forecast = value.asObservable();

  @action
  setRain(bool value) => raining = value;

  @action
  setDayLightTrigger(SMITrigger value) => dayLightTrigger = value;

  @action
  setThemeSwitchTrigger(SMIBool value) => themeSwitchTrigger = value;

  @action
  toggleDaylight() async {
    disableDaylightButton = true;
    themeService.toggleTheme();
    dayLightTrigger?.fire();
    themeSwitchTrigger?.value = themeService.isDarkTheme;

    await Future.delayed(Duration(seconds: 1));
    disableDaylightButton = false;
  }

  @action
  setCity(String value) => city = value;

  @action
  setCountry(String value) => country = value;

  @action
  setLatitude(double value) => latitude = value;

  @action
  setLongitude(double value) => longitude = value;
}
