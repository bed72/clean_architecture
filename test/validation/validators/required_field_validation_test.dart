import 'package:test/test.dart';

import 'package:bed/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation? sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test(' 🔧 Should return null if value is not empty', () {
    expect( sut!.validate('any_value'), '');
  });

  test(' 🔧 Should return error if value is not empty', () {  
    expect(sut!.validate(''), 'Campo obrigatório');
  });

  test(' 🔧 Should return error if value is null', () {  
    expect(sut!.validate(null), 'Campo obrigatório');
  });
}
