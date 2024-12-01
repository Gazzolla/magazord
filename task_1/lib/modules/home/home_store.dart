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

  final ObservableList<Task> _tasks = [
    Task(title: 'Comprar mantimentos', description: 'Ir ao mercado e comprar frutas, vegetais e pão', completed: false, category: 'Casa'),
    Task(title: 'Estudar Dart', description: 'Estudar testes unitários', completed: true, category: 'Trabalho'),
    Task(title: 'Limpar a casa', description: 'Fazer uma faxina geral na sala e nos quartos', completed: false, category: 'Casa'),
    Task(title: 'Planejar viagem', description: 'Organizar roteiro para viagem ao litoral', completed: true, category: 'Lazer'),
    Task(title: 'Assistir palestra', description: 'Participar do webinar sobre produtividade', completed: false, category: 'Trabalho'),
    Task(title: 'Revisar projeto', description: 'Revisar o código do projeto antes de entregar', completed: true, category: 'Trabalho'),
    Task(title: 'Marcar consulta', description: 'Agendar consulta com o dentista para a próxima semana', completed: false, category: 'Saúde'),
    Task(title: 'Ler livro', description: 'Terminar de ler o livro "O Poder do Hábito"', completed: true, category: 'Lazer'),
    Task(title: 'Preparar apresentação', description: 'Criar slides para a reunião de segunda-feira', completed: false, category: 'Trabalho'),
    Task(title: 'Correr no parque', description: 'Fazer 5 km de corrida pela manhã', completed: true, category: 'Saúde'),
    Task(title: 'Organizar fotos', description: 'Separar as fotos da viagem para o álbum', completed: false, category: 'Casa'),
    Task(title: 'Resolver pendências bancárias', description: 'Ir ao banco para atualizar dados', completed: true, category: 'Financeiro'),
    Task(title: 'Comprar presente', description: 'Escolher um presente para o aniversário da Ana', completed: false, category: 'Pessoal'),
    Task(title: 'Trocar óleo do carro', description: 'Levar o carro na oficina para manutenção', completed: true, category: 'Carro'),
    Task(title: 'Aprender a cozinhar', description: 'Testar uma receita nova de bolo de chocolate', completed: false, category: 'Casa'),
  ].asObservable();

  clearTasks() {
    _tasks.clear();
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
