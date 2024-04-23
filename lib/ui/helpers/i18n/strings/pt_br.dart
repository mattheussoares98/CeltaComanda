// ignore_for_file: annotate_overrides

import './translation.dart';

class PtBr implements Translation {
  String get msgEmailInUse => 'O email já está em uso.';
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  String get msgInvalidField => 'Campo inválido';
  String get msgRequiredField => 'Campo obrigatório';
  String get msgUnexpectedError =>
      'Algo errado aconteceu. Tente novamente em breve.';
  String get msgVeryShortField => 'Campo muito curto';

  String get addAccount => 'Criar conta';
  String get commandNotAvailable => "Comanda não disponível";
  String get confirmPassword => 'Confirmar senha';
  String get enterprise => 'Empresa';
  String get enterpriseOrUrlNotFound => 'Empresa e URL não encontrados';
  String get login => 'Login';
  String get name => 'Nome';
  String get password => 'Senha';
  String get reload => 'Recarregar';
  String get surveys => 'Enquetes';
  String get surveyResult => 'Resultado da enquete';
  String get user => 'Usuário';
  String get url => 'Empresa ou url';
  String get validateEnterprise => 'Validar empresa';
  String get wait => 'Aguarde...';
}
