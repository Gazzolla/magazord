import 'package:mobx/mobx.dart';
part 'loading_service.g.dart';

// ignore: library_private_types_in_public_api
class LoadingBarService = _LoadingBarServiceBase with _$LoadingBarService;

abstract class _LoadingBarServiceBase with Store {
  @observable
  bool showLoading = false;

  @observable
  bool blockScreen = false;

  @action
  showHideLoading(bool value, {bool block = false}) {
    showLoading = value;
    blockScreen = block;
  }

  @action
  void start() => showLoading = true;

  @action
  void stop() => showLoading = false;
}
