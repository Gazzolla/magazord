import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

class Task = _TaskBase with _$Task;

abstract class _TaskBase with Store {
  @observable
  String id;

  @observable
  String title;

  @observable
  String description;

  @observable
  bool completed;

  @observable
  String category;

  _TaskBase({
    required this.title,
    required this.description,
    this.completed = false,
    required this.category,
  }) : id = Uuid().v4();
}

class CategoryIndicators {
  String title;
  double progress;
  int taskQuantity;
  late Color color;

  CategoryIndicators({
    required this.title,
    required this.progress,
    required this.taskQuantity,
  }) {
    color = getColorForCategory(title);
  }

  static Color getColorForCategory(String category) {
    switch (category) {
      case 'Casa':
        return Colors.green;
      case 'Trabalho':
        return Colors.blue;
      case 'Lazer':
        return Colors.orange;
      case 'Saúde':
        return Colors.red;
      case 'Financeiro':
        return Colors.purple;
      case 'Pessoal':
        return Colors.pink;
      case 'Carro':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
