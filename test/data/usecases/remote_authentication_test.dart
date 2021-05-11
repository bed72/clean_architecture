import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bed/domain/helpers/helpers.dart';
import 'package:bed/domain/usecases/usecases.dart';

import 'package:bed/data/http/http.dart';
import 'package:bed/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

/// Pattern **Triple A** *(Arrange, Act, Assert)*
void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteAuthentication sut;
  late AuthenticationParams params;

  Map<String, dynamic> mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  When<Future<Map<String, dynamic>?>> _mockRequest() =>
      when(() => httpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            body: any(named: 'body'),
          ));

  void mockHttpData(Map<String, dynamic> data) {
    _mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    _mockRequest().thenThrow(error);
  }

  /// Tratar errors do tipo any
  setUpAll(() {
    registerFallbackValue<Map<dynamic, dynamic>>(<dynamic, dynamic>{});
  });

  /// Códigos que irão rodar para todos os testes
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    /// [sut]: System under test - Sistema em teste refere-se a um sistema que está sendo testado para operação correta.
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    /// mockando caso de sucesso
    mockHttpData(mockValidData());
  });

  test(' 🔧 Should call HttpClient with correct values', () async {
    /// Ação
    await sut.auth(params);

    /// Valor esperado
    verify(
      () => httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}),
    );
  });

  test(' 🔧 Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    /// Ação
    final feature = sut.auth(params);

    /// Valor esperado
    expect(feature, throwsA(DomainError.unexpected));
  });

  test(' 🔧 Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    /// Ação
    final feature = sut.auth(params);

    /// Valor esperado
    expect(feature, throwsA(DomainError.unexpected));
  });

  test(' 🔧 Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    /// Ação
    final feature = sut.auth(params);

    /// Valor esperado
    expect(feature, throwsA(DomainError.unexpected));
  });

  test(' 🔧 Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    mockHttpError(HttpError.unauthorized);

    /// Ação
    final feature = sut.auth(params);

    /// Valor esperado
    expect(feature, throwsA(DomainError.invalidCredentials));
  });

  test(' 🔧 Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    /// Ação
    final account = await sut.auth(params);

    /// Valor esperado
    expect(account.token, validData['accessToken']);
  });

  test(
      ' 🔧 Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    /// Ação
    final future = sut.auth(params);

    /// Valor esperado
    expect(future, throwsA(DomainError.unexpected));
  });
}
