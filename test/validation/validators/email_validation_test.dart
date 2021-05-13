import 'package:bed/validation/dependencies/dependencies.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  @override
  late final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : 'Campo inválido';
  }
}

void main() {
  EmailValidation? sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test(' 🔧 Should return null if email is empty', () {
    expect(sut!.validate(''), null);
  });

  test(' 🔧 Should return null if email is null', () {
    expect(sut!.validate(null), null);
  });

  test(' 🔧 Should return null if email is valid', () {
    expect(sut!.validate('gjramos100@gmail.com'), null);
  });

  test(' 🔧 Should return error if email is invalid', () {
    expect(sut!.validate('gjramos100'), 'Campo inválido');
  });
}
