import 'package:equatable/equatable.dart';

/// Nossos própios packages, arquivo raiz
import '../entities/entities.dart';

/// Authentication
/// --
/// Classe Abstrata que contem o método de auth
/// - **email** e-mail do usúario;
/// - **password** password  do usúario.
abstract class Authentication {
  Future<AccountEntity>? auth(AuthenticationParams params);
}

/// Usando equatable 
class AuthenticationParams extends Equatable {
  late final String email;
  late final String secret;

  AuthenticationParams({
    required this.email,
    required this.secret,
  });

  @override
  List<Object?> get props => [
    email,
    secret
  ];
}
