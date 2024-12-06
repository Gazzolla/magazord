import 'package:reactive_forms/reactive_forms.dart';
import 'package:task_2/services/loading_service.dart';
import 'package:task_2/services/theme_service.dart';

Map<String, String Function(Object)>? validationMessages = {
  ValidationMessage.required: (x) => '',
  ValidationMessage.any: (x) => '',
  ValidationMessage.compare: (x) => '',
  ValidationMessage.contains: (x) => '',
  ValidationMessage.creditCard: (x) => '',
  ValidationMessage.email: (x) => '',
  ValidationMessage.max: (x) => '',
  ValidationMessage.equals: (x) => '',
  ValidationMessage.maxLength: (x) => '',
  ValidationMessage.min: (x) => '',
  ValidationMessage.minLength: (x) => '',
  ValidationMessage.mustMatch: (x) => '',
  ValidationMessage.number: (x) => '',
  ValidationMessage.pattern: (x) => '',
  ValidationMessage.requiredTrue: (x) => '',
};

final loadingBarService = LoadingBarService();
final themeService = ThemeService();

final apiAddress =
    "https://api.open-meteo.com/v1/forecast?current=temperature_2m,relative_humidity_2m,is_day,precipitation,rain,wind_speed_10m&hourly=temperature_2m,rain&daily=temperature_2m_max,temperature_2m_min,sunrise,uv_index_max,precipitation_probability_max&timezone=America%2FSao_Paulo&forecast_days=2";

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
