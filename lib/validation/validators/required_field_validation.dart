import '../dependencies/dependencies.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  late final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String? value) {
    return value?.isNotEmpty == true ? '' : 'Campo obrigatório';
  }
}