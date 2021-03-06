enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get descripition {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';
      default:
        return 'Algo errado acontetceu.';
    }
  }
}
