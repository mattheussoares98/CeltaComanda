// ignore_for_file: annotate_overrides

import './translation.dart';

class PtBr implements Translation {
  String get msgBarcodeNotRead => 'Nenhum código de barras foi lido';
  String get msgBlockedCommand => 'Comanda bloqueada';
  String get msgEmailInUse => 'O email já está em uso.';
  String get msgClearCartOnLogout =>
      'Ao fazer o logout, o carrinho será limpo!';
  String get msgCloseApplication => "Fechar aplicativo";
  String get msgCommandBlocked => "Essa comanda está bloqueada!";
  String get msgCommandDontHaveOpenValues =>
      "Essa comanda não possui valores em aberto";
  String get msgCommandDontHaveProducts =>
      "Não há produtos solicitados nessa mesa";
  String get msgConsultCommandToViewProducts =>
      "Consulte alguma comanda para visualizar os produtos solicitados";
  String get msgEvaluateFood => "Avalie a comida";
  String get msgEvaluateDrink => "Avalie a bebida";
  String get msgEvaluateEnvironment => "Avalie o ambiente";
  String get msgEvaluateService => "Avalie o atendimento";
  String get msgEvaluateCostBenefit => "Avalie o custo benefício";
  String get msgIfLogoutClearCart =>
      'Se você fizer o logout, o carrinho será limpo';
  String get msgInsertCommandNumber => "Informe o número da comanda";
  String get msgInvalidCombox =>
      'Selecione todos produtos que são obrigatórios para conseguir salvar o combo';
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  String get msgInvalidCredentialsOrAccessDenied =>
      'Credenciais inválidas ou usuário sem permissão';
  String get msgInvalidField => 'Campo inválido';
  String get msgInvalidNumber => "Número inválido";
  String get msgLowBatteryChargeDevice =>
      "Carregue o dispositivo. Ele está com pouca bateria";
  String get msgMaximumQuantityAchieved => "Quantidade máxima atingida";
  String get msgObligatoryFixedCommandNumber =>
      'O número da comanda é obrigatório';
  String get msgPaymentEmpty => 'A comanda não possui valores em aberto';
  String get msgProductNotFound => 'O produto não foi encontrado';
  String get msgRequestSentSuccessfully => 'O pedido foi enviado com sucesso';
  String get msgRequiredField => 'Campo obrigatório';
  String get msgReleasesCommand => "Comanda liberada";
  String get msgSearchCommandToPay =>
      'Consulte alguma comanda para efetuar o pagamento dela';
  String get msgSelectCommand => 'Selecione a comanda';
  String get msgSelectPeopleNumbers => 'Selecione a quantidade de pessoas';
  String get msgSelectSeller => 'Selecione o vendedor';
  String get msgSuccessToCancelProducts => 'Cancelamento de produtos liberado';
  String get msgTableNumber => 'Número da mesa';
  String get msgUpdatedTableConfigurationsSuccess =>
      "Configurações alteradas com sucesso";
  String get msgUnexpectedError =>
      'Algo errado aconteceu. Tente novamente em breve.';
  String get msgUseOnlyWhenIsFixedTableNumber =>
      'Essa opção deve ser usada somente quando estiver utilizando um tablet fixo por mesa';
  String get msgVeryShortField => 'Campo muito curto';
  String get msgWantCloseApplication => "Deseja realmente fechar o aplicativo?";
  String get msgWantDoLogout => "Deseja realmente fazer o logout?";
  String get msgWhenConfirmProductsAreRequestAndSoonIncome =>
      'Ao confirmar, os produtos serão solicitados e em breve serão servidos';
  String get msgWriteCommandNumber => "Digite o número da comanda";
  String get msgWriteEanOrPlu => "Digite o EAN ou o PLU";
  String get msgWriteName => "Informe o seu nome";
  String get msgWriteOnlyNumbers => "Digite somente números";
  String get msgWritePassword => "Digite a senha";
  String get msgWriteTableNumber => "Digite o número da mesa";
  String get msgWriteThreeNumbers => "Digite 3 números";
  String get msgWriteUserCode => "Digite o código do usuário";

  String get accessDenied => 'O usuário não possui permissão';
  String get advance => 'Avançar';
  String get addAccount => 'Criar conta';
  String get addCommentError => 'Ocorreu um erro para adicionar o comentário';
  String get addFlagOrTable => "Adicionar número da bandeira/mesa";
  String get addItens => "Adicionar itens";
  String get addMoreItens => "Adicionar mais itens";
  String get alwaysUseSameTable => "Usar sempre a mesma mesa";
  String get avaliate => 'Avaliar';
  String get blockCommand => 'Bloquear comanda';
  String get cart => "Carrinho";
  String get cancel => "Cancelar";
  String get cashCredit => "Crédito à vista";
  String get cellPhone => "Celular";
  String get clearCart => "Limpar carrinho";
  String get closeApplication => "Fechar APP";
  String get close => "Fechar";
  String get combox => "Combo";
  String get commandNotAvailable => "Comanda não disponível";
  String get command => "Comanda";
  String get commentsOfProduct => "Comentários do produto";
  String get comments => "Comentários";
  String get comment => "Comentário";
  String get confirmFlag => "Confirmar bandeira";
  String get confirmPassword => 'Confirmar senha';
  String get confirm => 'Confirmar';
  String get costBenefit => 'Custo benefício';
  String get suggestionCriticalOrPraise => "Sugestão, crítica ou elogio";
  String get debit => "Débito";
  String get detach => "Destaques";
  String get doLogout => "Fazer logout";
  String get doYouWantToAdd => "Deseja adicionar?";
  String get drink => "Bebida";
  String get eanOrPlu => "EAN ou PLU";
  String get email => "E-mail";
  String get emptyCart => 'O carrinho está vazio';
  String get enterprise => 'Empresa';
  String get enterpriseOrUrlNotFound => 'Empresa e URL não encontrados';
  String get environment => 'Ambiente';
  String get exit => 'Sair';
  String get insertInCart => 'Inserir no carrinho';
  String get insert => 'Inserir';
  String get ifWantSelectComments => 'Se desejar, selecione comentários';
  String get ifWantSelectProducts => 'Se desejar, selecione um produto';
  String get jump => 'Pular';
  String get liberateCancelProducts => 'Liberar cancelamento de itens';
  String get liberateCommand => 'Liberar comanda';
  String get loadMenu => 'Carregar menu';
  String get login => 'Login';
  String get name => 'Nome';
  String get neww => 'Novo';
  String get no => 'Não';
  String get obligatory => 'Obrigatório';
  String get obligatoryComments => 'Comentários obrigatórios';
  String get optional => 'Opcional';
  String get password => 'Senha';
  String get pay => 'Pagar';
  String get peopleQuantity => 'Quantidade de pessoas';
  String get per => 'Por';
  String get price => 'Preço';
  String get productsAndComments => 'Produtos e comentários';
  String get quantity => 'Quantidade';
  String get quantityAbbreviated => 'Qtd';
  String get reload => 'Recarregar';
  String get removeProduct => 'Remover produto';
  String get requested => 'Solicitados';
  String get requestedAt => 'Solicitado às';
  String get requestSentSuccessfully => "O pedido foi enviado com sucesso";
  String get reserved => 'Reservada';
  String get reserveTable => 'Reservar mesa';
  String get searchCommandData => "Consultar dados da comanda";
  String get searchProduct => "Consultar produto";
  String get selectOneComment => "Selecione um comentário";
  String get selectedProductsAndComments =>
      'Produto selecionados e comentários';
  String get selectPaymentOption => "Selecione uma opção de pagamento";
  String get selectProduct => "Selecione um produto!";
  String get selectQuantity => "Informe a quantidade";
  String get seller => "Vendedor";
  String get sendEvaluation => 'Enviar avaliação';
  String get sendRequest => 'Enviar pedido';
  String get send => 'Enviar';
  String get service => 'Atendimento';
  String get surveys => 'Enquetes';
  String get surveyResult => 'Resultado da enquete';
  String get table => 'Mesa';
  String get time => 'Horário';
  String get total => 'Total';
  String get totalByPerson => 'Total por pessoa';
  String get turnBack => 'Voltar';
  String get updateConfigurations => "Alterar configurações";
  String get updateMenu => "Atualizar menu";
  String get updateTableNumberAndPeopleNumbers =>
      "Alterar mesa e quantidade de pessoas";
  String get updateTableNumber => "Alterar mesa";
  String get userCode => 'Código do usuário';
  String get user => 'Usuário';
  String get url => 'Empresa ou url';
  String get validateEnterprise => 'Validar empresa';
  String get wait => 'Aguarde...';
  String get wantRemoveRequestedProduct =>
      'Deseja realmente remover o produto dos produtos solicitados?';
  String get yes => "Sim";
}
