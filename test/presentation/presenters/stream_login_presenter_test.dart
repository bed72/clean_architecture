import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bed/domain/helpers/helpers.dart';
import 'package:bed/domain/entities/entities.dart';
import 'package:bed/domain/usecases/usecases.dart';
import 'package:bed/presentation/presenters/presenters.dart';
import 'package:bed/presentation/dependencies/dependencies.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class AuthenticationParamsFake extends Fake implements AuthenticationParams {}

void main() {
  String? email;
  String? password;

  StreamLoginPresenter? sut;

  ValidationSpy? validation;
  AuthenticationSpy? authentication;

  When<String?> _mockValidationCall(String? field) => when(
        () => validation!.validate(
          field: field ?? any(named: 'field'),
          value: any(named: 'value'),
        ),
      );

  void _mockValidation({
    String? field,
    String? value,
  }) {
    _mockValidationCall(field).thenReturn(value);
  }

  When<Future<AccountEntity>?> _mockAuthenticationCall() => when(
        () => authentication!.auth(any()),
      );

  void _mockAuthentication() {
    _mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void _mockAuthenticationError(DomainError error) {
    _mockAuthenticationCall().thenThrow(error);
  }

  setUpAll(() {
    registerFallbackValue<AuthenticationParams>(AuthenticationParamsFake());
  });

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();

    sut = StreamLoginPresenter(
        validation: validation!, authentication: authentication!);

    email = faker.internet.email();
    password = faker.internet.password();

    _mockValidation();
    _mockAuthentication();
  });

  test(' 🔧 Should call validation with correct email', () {
    sut!.validateEmail(email!);

    verify(
      () => validation!.validate(
        field: 'email',
        value: email!,
      ),
    ).called(1);
  });

  test(' 🔧 Should emit email error if validation fails', () {
    _mockValidation(value: 'error');

    /// Observando stream
    /// Garantindo que o validate email só será chamado uma unica vez
    sut!.emailErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));

    /// Form valido
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email!);
    sut!.validateEmail(email!);
  });

  test(' 🔧 Should emit null if validation succeeds email', () {
    /// Observando stream
    /// Garantindo que o validate email só será chamado uma unica vez
    sut!.emailErrorStream!.listen(expectAsync1((error) => expect(error, '')));

    /// Form valido
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email!);
    sut!.validateEmail(email!);
  });

  test(' 🔧 Should call validation with correct password', () {
    sut!.validatePassword(password!);

    verify(
      () => validation!.validate(
        field: 'password',
        value: password!,
      ),
    ).called(1);
  });

  test(' 🔧 Should emit password error if validation fails', () {
    _mockValidation(value: 'error');

    /// Observando stream
    /// Garantindo que o validate email só será chamado uma unica vez
    sut!.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));

    /// Form valido
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password!);
    sut!.validatePassword(password!);
  });

  test(' 🔧 Should emit null if validation succeeds password', () {
    /// Observando stream
    /// Garantindo que o validate email só será chamado uma unica vez
    sut!.passwordErrorStream!.listen(expectAsync1((error) => expect(error, '')));

    /// Form valido
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password!);
    sut!.validatePassword(password!);
  });

  test(' 🔧 Test email with error and correct password', () {
    _mockValidation(field: 'email', value: 'error');

    sut!.emailErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));

    /// Observando stream
    /// Garantindo que o validate email só será chamado uma unica vez
    sut!.passwordErrorStream!.listen(expectAsync1((error) => expect(error, '')));

    /// Form valido
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email!);
    sut!.validatePassword(password!);
  });

  test(' 🔧 You must return a valid form, as the fields are correct', () {
    sut!.emailErrorStream!.listen(expectAsync1((error) => expect(error, '')));
    sut!.passwordErrorStream!.listen(expectAsync1((error) => expect(error, '')));

    /// Form valido
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, true)));

    /// Só com email preenchido -> false
    /// Com email e password preenchido -> true
    // ignore: unawaited_futures
    expectLater(sut!.isFormValidStream, emits(true));

    sut!.validateEmail(email!);
    // await Future.delayed(Duration(seconds: 3));
    sut!.validatePassword(password!);
  });

  test(' 🔧 Should call Authentication with correct values', () async {
    sut!.validateEmail(email!);
    sut!.validatePassword(password!);

    await sut!.auth();

    verify(() => authentication!
            .auth(AuthenticationParams(email: email!, secret: password!)))
        .called(1);
  });

  test(' 🔧 Should emit correct events on Authentication success', () async {
    sut!.validateEmail(email!);
    sut!.validatePassword(password!);

    // ignore: unawaited_futures
    expectLater(sut!.isLoadingStream, emitsInOrder([true, false]));

    await sut!.auth();
  });

  test(' 🔧 Should emit correct events on Invalid Credential Error', () async {
    _mockAuthenticationError(DomainError.invalidCredentials);

    sut!.validateEmail(email!);
    sut!.validatePassword(password!);

    // ignore: unawaited_futures
    expectLater(sut!.isLoadingStream, emits(false));
    sut!.mainErrorStream!.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut!.auth();
  });

  test(' 🔧 Should emit correct events on Unexpected Error', () async {
    _mockAuthenticationError(DomainError.unexpected);

    sut!.validateEmail(email!);
    sut!.validatePassword(password!);

    // ignore: unawaited_futures
    expectLater(sut!.isLoadingStream, emits(false));
    sut!.mainErrorStream!.listen(
        expectAsync1((error) => expect(error, 'Algo errado acontetceu.')));

    await sut!.auth();
  });

  test(' 🔧 Should not emit after dispose', () async {
    // ignore: unawaited_futures
    expectLater(sut!.emailErrorStream, neverEmits(null));

    sut!.dispose();
    sut!.validateEmail(email!);
  });
}
