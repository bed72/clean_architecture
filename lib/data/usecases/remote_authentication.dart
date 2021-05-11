import 'package:bed/data/models/models.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/entities/entities.dart';

import '../models/models.dart';

import '../http/http.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();

    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );

      return RemoteAccountModel.fromJson(httpResponse!).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

/// Especializando nossa Dominio de Autenticação, irá refletir nossa API
class RemoteAuthenticationParams {
  late final String email;
  late final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  /// Pegar params e converter para nossa classe RemoteAuthenticationParams,
  /// gerando uma instância dele mesmo
  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
