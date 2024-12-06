import 'package:mobx/mobx.dart';
part 'product_store.g.dart';

class ProductController = _ProductControllerBase with _$ProductController;

abstract class _ProductControllerBase with Store {}
