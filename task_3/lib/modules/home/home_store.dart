import 'package:mobx/mobx.dart';
import 'package:task_3/shared/constants.dart' as constants;
import 'package:task_3/shared/models/products.dart';
part 'home_store.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  String search = "";

  @action
  setSearch(String value) => search = value;

  @observable
  ObservableList<Product> productList = constants.products.asObservable();

  @computed
  List<Product> get products {
    return productList.where((x) => x.title.toLowerCase().contains(search.toLowerCase())).toList();
  }
}
