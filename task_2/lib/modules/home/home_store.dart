import 'package:mobx/mobx.dart';
import 'package:rive/rive.dart';
import 'package:task_2/shared/models/day.dart';
part 'home_store.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  WeekDay curentDay = WeekDay(day: DateTime.now(), sunlight: DateTime.now());

  @observable
  Artboard? riveArtboard;

  @observable
  bool raining = false;

  @observable
  SMITrigger? isDayTime;

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

  @action
  setForecast(List<WeekDay> value) => forecast = value.asObservable();

  @action
  setRain(bool value) => raining = value;

  @action
  setIsDayTime(SMITrigger value) => isDayTime = value;

  @action
  setCity(String value) => city = value;

  @action
  setCountry(String value) => country = value;

  @action
  setLatitude(double value) => latitude = value;

  @action
  setLongitude(double value) => longitude = value;
}
