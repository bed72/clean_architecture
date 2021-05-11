import 'dart:async';

import '../dependencies/dependencies.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class LoginState {
  String email = '';
  String password = '';

  String mainError = '';
  String emailError = '';
  String passwordError = '';

  bool isLoading = false;

  bool get isFormValid =>
      emailError == '' && passwordError == '' && email != '' && password != '';
}

class StreamLoginPresenter {
  late final Validation validation;
  late final Authentication authentication;

  StreamLoginPresenter(
      {required this.validation, required this.authentication});

  /// controlador para mais de uma Stream
  // ignore: close_sinks
  StreamController<LoginState>? _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String>? get mainErrorStream =>
      _controller?.stream.map((state) => state.mainError).distinct();

  /// [distinct()] só emita valor se for diferente do anterior
  Stream<String>? get emailErrorStream =>
      _controller?.stream.map((state) => state.emailError).distinct();

  /// [distinct()] só emita valor se for diferente do anterior
  /// Se for null traga uma string vazia
  Stream<String>? get passwordErrorStream =>
      _controller?.stream.map((state) => state.passwordError).distinct();

  Stream<bool>? get isFormValidStream =>
      _controller?.stream.map((state) => state.isFormValid).distinct();

  Stream<bool>? get isLoadingStream =>
      _controller?.stream.map((state) => state.isLoading).distinct();

  void _update() => _controller?.add(_state);

  void validateEmail(String email) {
    _state.email = email;

    /// Se for null traga uma string vazia
    _state.emailError = validation.validate(field: 'email', value: email) ?? '';
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;

    /// Se for null traga uma string vazia
    _state.passwordError =
        validation.validate(field: 'password', value: password) ?? '';
    _update();
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();

    try {
      /// Aqui estamos comparando objetos, o teste não irá passar
      await authentication.auth(
          AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      _state.mainError = error.descripition;
    }

    _state.isLoading = false;
    _update();
  }
}
