import 'package:get/get.dart';

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return 'Digite seu E-mail!';
  }
  if (!email.isEmail) {
    return 'Digite um E-mail válido!';
  }
  return null;
}

String? passwordValidator(String? password) {
  if (password == null || password.isEmpty) {
    return 'Digite sua Senha!';
  }
  if (password.length < 8) {
    return 'A senha deve ter no Mínimo 8 Caracteres!';
  }
  return null;
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return 'Digite seu Nome!';
  }

  if (!RegExp(r'[\D]+').hasMatch(name)) {
    return 'O nome deve conter apenas Letras!';
  }

  if (name.split('').length < 2) {
    return 'Digite seu nome completo!';
  }

  return null;
}

String? phoneValidator(String? phone) {
  if (phone == null || phone.isEmpty) {
    return 'Digite seu Celular!';
  }

  if (phone.length < 15 || !phone.isPhoneNumber) {
    return 'Digite um número válido!';
  }

  return null;
}

String? cpfValidator(String? cpf) {
  if (cpf == null || cpf.isEmpty) {
    return 'Digite seu CPF!';
  }

  if (!cpf.isCpf) {
    return 'Digite um CPF válido!';
  }

  return null;
}
