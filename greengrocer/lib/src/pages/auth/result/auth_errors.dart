
String authErrorsString (String? error){

  switch(error){

    case 'INVALID_CREDENTIALS':
      return 'Credenciais Inválidas!';

    case 'INVALID_FULLNAME':
      return 'Nome Inválido!';

    case 'INVALID_PHONE':
      return 'Celular Inválido!';

    case 'Account already exists for this username.':
      return 'Já existe um usuário com este e-mail!';

    case 'INVALID_CPF':
      return 'CPF Inválido!';

    case 'Invalid session token':
      return 'Token Inválido!';
      
    default:
      return 'Falha não mapeada!';  
  }
}