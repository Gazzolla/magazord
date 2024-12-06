import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_3/app_widget.dart';
import 'package:task_3/shared/constants.dart';
import 'package:task_3/shared/models/products.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  products = List<Product>.from(json.decode(await rootBundle.loadString('assets/json/data.json')).map((x) => Product.fromJson(x))).toList();
  runApp(const AppWidget());
}
