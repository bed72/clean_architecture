/// LoginPresenter
/// Irá ser implementada por alguma Stream com detalhes expecificos
abstract class LoginPresenter {
  /// Generico posso trabalhar com qualquer implementação de Stream
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<String> get mainErrorStream;

  Stream<bool> get isLoadingStream;
  Stream<bool> get isFormValidErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void>? auth();
  void dispose();
}
