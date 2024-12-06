import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:task_1/shared/models/task.dart';
part 'home_store.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  TextEditingController searchController = TextEditingController();

  @observable
  bool showSearchField = false;

  @action
  void toggleSearchField() => showSearchField = !showSearchField;

  @action
  clearSearchText() {
    searchText = "";
    searchController.clear();
  }

  @observable
  String searchText = "";

  @action
  setSearchText(String value) => searchText = value;

  @observable
  double remainingSpace = 0;

  @action
  setRemainingSpaceValue(double value) => remainingSpace = value;

  final ObservableList<Task> _tasks = <Task>[].asObservable();

  clearTasks() {
    _tasks.clear();
  }

  addTask(Map value) {
    _tasks.add(Task(title: value['title'], description: value['description'] ?? '', category: value['category'], completed: value['completed'] ?? false));
  }

  @computed
  List<Task> get tasks => _tasks.where((x) => x.title.toLowerCase().contains(searchText.toLowerCase()) || x.category.toLowerCase().contains(searchText.toLowerCase())).toList();

  @computed
  List<CategoryIndicators> get completionResume {
    var categoryMap = <String, List<Task>>{};

    for (var task in tasks) {
      categoryMap.putIfAbsent(task.category, () => []).add(task);
    }
    List<CategoryIndicators> categoryIndicators = [];
    categoryMap.forEach((category, tasksInCategory) {
      int totalTasks = tasksInCategory.length;
      int completedTasks = tasksInCategory.where((task) => task.completed).length;
      double progress = totalTasks > 0 ? completedTasks / totalTasks : 0;

      // Adicionar categoria com dados calculados
      categoryIndicators.add(CategoryIndicators(
        title: category,
        progress: progress,
        taskQuantity: totalTasks,
      ));
    });

    return categoryIndicators;
  }
}
