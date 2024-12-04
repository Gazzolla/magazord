import 'package:reactive_forms/reactive_forms.dart';

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
