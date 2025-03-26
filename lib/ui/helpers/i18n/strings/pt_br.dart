// ignore_for_file: annotate_overrides

import './translation.dart';

class PtBr implements Translation {
  String get msgAuthorizationIsPendant => "Autorização pendente";
  String get msgAllChildsAreDisabled =>
      "Por favor, chame o garçom para arrumar esse problema.\nTodos os filhos estão desativados no agendamento, habilite pelo menos um";
  String get msgBarcodeNotRead => 'Nenhum código de barras foi lido';
  String get msgBlockedCommand => 'Comanda bloqueada';
  String get msgCantAddCombox => 'Não é permitido adicionar combo por aqui';
  String get msgCantChangeEnterpriseName =>
      "Não é permitido alterar o nome da empresa";
  String get msgCantSendServiceChargeProduct =>
      'Não é permitido enviar o produto de taxa de serviço';
  String get msgClearCartOnLogout =>
      'Ao fazer o logout, o carrinho será limpo!';
  String get msgClearConfirmedPayments => "Limpar pagamentos confirmados";
  String get msgCloseApplication => "Fechar aplicativo";
  String get msgCommandAlreadyPaid =>
      "Essa comanda já foi paga mas houve um erro para liquidar ela. Liquide ou libere a comanda";
  String get msgCommandBlocked => "Essa comanda está bloqueada!";
  String get msgCommandDontHaveOpenValues =>
      "Essa comanda não possui valores em aberto";
  String get msgCommandDontHaveProducts =>
      "Não há produtos solicitados nessa mesa";
  String get msgCompatibleVersion =>
      "Se o dispositivo estiver com uma versão menor do que a digitada, aparecerá uma mensagem a cada hora para atualizar o aplicativo. Na página de configurações aparecerá uma opção para atualizar o aplicativo também";
  String get msgConfirmClearTotalPaid =>
      "Ao sair da tela, o total pago será limpo";
  String get msgConfirmSendProducts => "Deseja realmente enviar os produtos?";
  String get msgConsultCommandToViewProducts =>
      "Consulte alguma comanda para visualizar os produtos solicitados";
  String get msgDaysToPreloadImage =>
      "O aplicativo pré carrega as imagens uma vez por dia. Se quiser aumentar a quantidade de dias, digite um valor maior";
  String get msgDontHaveUnusedPdvs => "Não há PDVs liberados para registro";
  String get msgEmailInUse => 'O email já está em uso.';
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
  String get msgInvalidCpfCnpj => 'CPF/CNPJ inválido';
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  String get msgInvalidCredentialsOrAccessDenied =>
      'Credenciais inválidas ou usuário sem permissão';
  String get msgInvalidField => 'Campo inválido';
  String get msgInvalidNumber => "Número inválido";
  String get msgLiquidadeCommandError =>
      "Ocorreu um erro não esperado para liquidar a comanda";
  String get msgLowBatteryChargeDevice =>
      "Carregue o dispositivo. Ele está com pouca bateria";
  String get msgMaximumQuantityAchieved => "Quantidade máxima atingida";
  String get msgCallWaiterToUpdateApp =>
      "Por favor, chame o garçom para atualizar o aplicativo";
  String get msgNeedUpdateApplication => "Você precisa atualizar o app para conseguir usá-lo";
  String get msgNewCommandMustBeEmpty => "A mesa nova precisa estar vazia";
  String get msgNewTable => "Mesa nova";
  String get msgNotFound => "Valor não encontrado";
  String get msgNotFoundData => "Não foram encontrados dados";
  String get msgNumberCopiedSuccessfully => "Número copiado com sucesso";
  String get msgMinutesVerifyUpdateMenu =>
      "A aplicação vai verificar se precisa atualizar o menu a cada X minutos";
  String get msgObligatoryFixedCommandNumber =>
      'O número da comanda é obrigatório';
  String get msgOldCommandIsEmpty => "A mesa antiga está vazia";
  String get msgOldTable => "Mesa antiga";
  String get msgPaymentCanceled => "Pagamento cancelado";
  String get msgPaymentDeclined => "Pagamento recusado";
  String get msgPaymentPendant => "Transação pendente";
  String get msgPaymentUnexpectedError =>
      'Ocorreu algum erro durante a finalização do pagamento';
  String get msgPaymentEmpty => 'A comanda não possui valores em aberto';
  String get msgPaymentFailed => 'Falha ao efetuar o pagamento';
  String get msgPendantAuthorizationNotification =>
      'A autorização está pendente para confirmar. Se você fizer essa ação, o saldo do cliente continuará comprometido pois já foi gerado uma pendência do saldo dele. O ideal é tentar liquidar a comanda novamente. Deseja realmente fazer essa ação e cancelar a possibilidade de liquidação?';
  String get msgProductNotFound => 'O produto não foi encontrado';
  String get msgRequestSentSuccessfully => 'O pedido foi enviado com sucesso';
  String get msgRequiredField => 'Campo obrigatório';
  String get msgReleasesCommand => "Comanda liberada";
  String get msgSearchCommandToPay =>
      'Consulte alguma comanda para efetuar o pagamento dela';
  String get msgSelectCommand => 'Selecione a comanda';
  String get msgSelectDifferentTables => 'Selecione mesas diferentes';
  String get msgSelectPeopleNumbers => 'Selecione a quantidade de pessoas';
  String get msgSelectProducts => 'Selecione produtos';
  String get msgSelectSeller => 'Selecione o vendedor';
  String get msgSelectTable => 'Selecione a mesa';
  String get msgServiceChargeValueInfo =>
      'Valor em porcentagem para adicionar um acréscimo no valor total do pedido';
  String get msgSuccessToCancelProducts => 'Produto cancelado com sucesso';
  String get msgSuccessToUpdateCommandNumberProducts =>
      "Os produtos foram enviados para a nova comanda";
  String get msgSuccessToUpdateSchedule =>
      "Agendamento configurado com sucesso";
  String get msgSuccessUpdateMenuInAllDevices =>
      'O menu vai ser atualizado em todos dispositivos';
  String get msgTableClosedSuccessfully => 'Mesa fechada com sucesso';
  String get msgTableNumber => 'Número da mesa';
  String get msgUpdatedTableConfigurationsSuccess =>
      "Configurações alteradas com sucesso";
  String get msgUnexpectedError =>
      'Algo errado aconteceu. Tente novamente em breve.';
  String get msgUseOnlyWhenIsFixedTableNumber =>
      'Essa opção deve ser usada somente quando estiver utilizando um tablet fixo por mesa';
  String get msgValidateEnterpriseFirst => "Valide a empresa primeiro";
  String get msgVeryShortField => 'Campo muito curto';
  String get msgWantCloseApplication => "Deseja realmente fechar o aplicativo?";
  String get msgWantCloseTable => "Deseja realmente fechar a mesa?";
  String get msgWantDeleteEnterprise => "Deseja realmente excluir a empresa?";
  String get msgWantDoLogout => "Deseja realmente fazer o logout?";
  String get msgWantUpdateConcentratorEnterpriseParameters =>
      "Essa opção vai atualizar os parâmetros do concentrador em todos dispositivos.\nVocê deve usar essa opção somente quando alterar o cross nos parâmetros do concentrador.\nDeseja continuar?";
  String get msgWantUpdateDeviceInformations =>
      "Deseja realmente atualizar os dados dos dispositivos?\nSomente os dispositivos que estiverem online enviarão seus dados para o firebase. Esse procedimento pode demorar alguns segundos";
  String get msgWantUpdateEnterpriseData =>
      "Deseja realmente atualizar os dados da empresa?\nOs dispositivos atualizarão os dados da empresa automaticamente";
  String get msgWantUpdateMenuInAllDevices =>
      "Deseja atualizar o menu em todos dispositivos?";
  String get msgWhenConfirmProductsAreRequestAndSoonIncome =>
      'Ao confirmar, os produtos serão solicitados e em breve serão servidos';
  String get msgWriteCommandNumber => "Digite o número da comanda";
  String get msgWriteEanOrPlu => "Digite o EAN ou o PLU";
  String get msgWriteName => "Informe o seu nome";
  String get msgWriteOnlyNumbers => "Digite somente números";
  String get msgWritePassword => "Digite a senha";
  String get msgWritePaymentValue => "Digite o valor a pagar";
  String get msgWriteTableNumber => "Digite o número da mesa";
  String get msgWriteThreeNumbers => "Digite 3 números";
  String get msgWriteUrl => "Digite a url";
  String get msgWriteUserCode => "Digite o código do usuário";

  String get accessConfigurations => 'Acessar configurações';
  String get accessDenied => 'O usuário não possui permissão';
  String get advance => 'Avançar';
  String get addAccount => 'Criar conta';
  String get addCommentError => 'Ocorreu um erro para adicionar o comentário';
  String get addFlagOrTable => "Adicionar número da bandeira/mesa";
  String get addItens => "Adicionar itens";
  String get addMoreItens => "Adicionar mais itens";
  String get alwaysUseSameTable => "Usar sempre a mesma mesa";
  String get applicationVersion => "Versão do aplicativo";
  String get avaliate => 'Avaliar';
  String get blockCommand => 'Bloquear comanda';
  String get blockTable => 'Bloquear mesa';
  String get blockUseAppIfIsOutdated => 'Bloquear uso do app se estiver desatualizado';
  String get cart => "Carrinho";
  String get call => "Ligar";
  String get cancel => "Cancelar";
  String get canceledBy => "Cancelado por";
  String get cancelProductsOrRemoveServiceCharge =>
      "Cancelar produtos ou remover taxa de serviço";
  String get cancelProduct => "Cancelar produto";
  String get canInsertCommentManually => "Pode inserir comentário manualmente";
  String get ccsUrl => "Url do CCS";
  String get cashCredit => "Crédito à vista";
  String get cellPhone => "Celular";
  String get change => "Alterar";
  String get changeDate => "Alterar data";
  String get check => "Cheque";
  String get child => "Filho";
  String get clearCart => "Limpar carrinho";
  String get close => "Fechar";
  String get closeApplication => "Fechar APP";
  String get closeTable => "Fechar mesa";
  String get code => "Código";
  String get combox => "Combo";
  String get command => "Comanda";
  String get commandNumber => "Número da comanda";
  String get commandNotAvailable => "Comanda não disponível";
  String get commentsOfProduct => "Comentários do produto";
  String get comments => "Comentários";
  String get comment => "Comentário";
  String get concentratorUrl => "Url do concentrador";
  String get conferenceOfTable => "Conferência da mesa";
  String get configurations => "Configurações";
  String get confirmFlag => "Confirmar bandeira";
  String get confirmPassword => 'Confirmar senha';
  String get confirmSchedule => 'Confirmar agendamento';
  String get confirm => 'Confirmar';
  String get contactUs => 'Fale conosco';
  String get costBenefit => 'Custo benefício';
  String get covenant => "Convênio";
  String get covenants => "Convênios";
  String get cpfCnpj => "CPF ou CNPJ";
  String get credit => "Crédito";
  String get customer => "Cliente";
  String get dateNotUpdated => "Data não atualizada";
  String get debit => "Débito";
  String get deleteEnterprise => "Excluir empresa";
  String get destinyTable => "Mesa de destino";
  String get deviceId => "ID do dispositivo";
  String get detach => "Destaques";
  String get developedByCeltaware => "Desenvolvido por Celtaware";
  String get devicesInformations => "Informações dos dispositivos";
  String get doLogout => "Fazer logout";
  String get doYouWantToAdd => "Deseja adicionar?";
  String get drink => "Bebida";
  String get eanOrPlu => "EAN ou PLU";
  String get email => "E-mail";
  String get emptyCart => 'O carrinho está vazio';
  String get emptySales => 'Não há vendas nessa data';
  String get emptyTable => 'A mesa está vazia';
  String get enableCovenant => 'Habilitar convênio';
  String get enableSearchProducts => 'Habilitar pesquisa de produtos';
  String get enterprise => 'Empresa';
  String get enterpriseId => 'Id da empresa';
  String get enterpriseIdInMysql => 'Id da empresa no MySQL';
  String get enterpriseOrUrlNotFound => 'Empresa e URL não encontrados';
  String get enterprises => 'Empresas';
  String get environment => 'Ambiente';
  String get exit => 'Sair';
  String get expansibleGroup => 'Grupo expansível';
  String get father => 'Pai';
  String get financialCredits => 'Créditos financeiros';
  String get friday => 'Sexta';
  String get getCustomer => 'Pesquisar cliente';
  String get id => 'ID';
  String get insertInCart => 'Inserir no carrinho';
  String get insert => 'Inserir';
  String get internalcodeNameOrCpf => "Código interno, nome ou CPF";
  String get ifWantSelectComments => 'Se desejar, selecione comentários';
  String get ifWantSelectProducts => 'Se desejar, selecione um produto';
  String get jump => 'Pular';
  String get lastDateUpdated => 'Último dia atualizado';
  String get lastUpdate => 'Última atualização';
  String get latestCompatibleVersion => 'Última versão compatível';
  String get liberateCancelProducts => 'Liberar cancelamento de itens';
  String get liberateCommand => 'Liberar comanda';
  String get liberateOrBlockTable => "Liberar ou bloquear mesa";
  String get liberateTable => "Liberar mesa";
  String get liquidateCommand => 'Liquidar comanda';
  String get liquidateCommandSucceeds => "Comanda liquidada com sucesso";
  String get loadMenu => 'Carregar menu';
  String get loadSales => 'Pesquisar vendas';
  String get login => 'Login';
  String get maximumAbbreviated => "Máx";
  String get minimumAbbreviated => "Mín";
  String get minutesVerifyUpdateMenu =>
      "Mínutos para verificar atualização do menu";
  String get missing => 'Faltando';
  String get monday => 'Segunda';
  String get money => 'Dinheiro';
  String get name => 'Nome';
  String get navsUrl => 'Url do navs';
  String get needLiberateCommand =>
      'Necessário liberar a comanda pra conseguir lançar produtos';
  String get neww => 'Novo';
  String get no => 'Não';
  String get obligatory => 'Obrigatório';
  String get obligatoryComments => 'Comentários obrigatórios';
  String get optional => 'Opcional';
  String get originTableIsEmpty => 'A mesa de origem está vazia';
  String get originTable => 'Mesa de origem';
  String get parameters => 'Parâmetros';
  String get password => 'Senha';
  String get pay => 'Pagar';
  String get pdv => 'Pdv';
  String get paymentValue => 'Valor do pagamento';
  String get peopleQuantity => 'Quantidade de pessoas';
  String get per => 'Por';
  String get personalizedCode => 'Código personalizado';
  String get pix => 'Pix';
  String get portion => 'Boleto';
  String get pos => 'Pos';
  String get price => 'Preço';
  String get productsAndComments => 'Produtos e comentários';
  String get productsSchedules => 'Agendamento de produtos';
  String get products => 'Produtos';
  String get product => 'Produto';
  String get promotionWithoutPoints => 'Promocao';
  String get purchaseVale => 'Vale compra';
  String get quantity => 'Quantidade';
  String get quantityAbbreviated => 'Qtd';
  String get register => 'Registrar';
  String get reload => 'Recarregar';
  String get removeProduct => 'Remover produto';
  String get removeServiceCharge => 'Remover taxa';
  String get requested => 'Solicitados';
  String get requestedAt => 'Solicitado às';
  String get requestSentSuccessfully => "O pedido foi enviado com sucesso";
  String get reserved => 'Reservada';
  String get reserveTable => 'Reservar mesa';
  String get sales => "Vendas";
  String get saturday => "Sábado";
  String get search => "Pesquisar";
  String get searchByPersonalizedCode => "Pesquisar pelo código personalizado";
  String get searchDataOfOtherCommandNumber =>
      "Consultar dados de outra comanda";
  String get searchCommandData => "Consultar dados da comanda";
  String get searchProduct => "Consultar produto";
  String get searchType => "Tipo de pesquisa";
  String get selectAll => "Selecionar todos";
  String get selectAllProducts => "Selecionar todos produtos";
  String get selectDate => "Selecione uma data";
  String get selectedDate => "Data selecionada";
  String get selectOneComment => "Selecione um comentário";
  String get selectedProductsAndComments =>
      'Produtos selecionados e comentários';
  String get selectPaymentOption => "Selecione uma opção de pagamento";
  String get selectPdv => "Selecione um PDV";
  String get selectProduct => "Selecione um produto!";
  String get selectQuantity => "Informe a quantidade";
  String get selectUser => "Selecione um usuário";
  String get seller => "Vendedor";
  String get sendAllProductsToAnotherTable =>
      'Enviar TODOS produtos para outra mesa';
  String get sendOneOrMoreProductsToAnotherTable =>
      'Enviar UM OU MAIS produtos para outra mesa';
  String get sendEvaluation => 'Enviar avaliação';
  String get sendMessage => 'Enviar mensagem';
  String get sendProductsToAnotherTable => 'Enviar produtos para outra mesa';
  String get sendRequest => 'Enviar pedido';
  String get send => 'Enviar';
  String get service => 'Atendimento';
  String get serviceCharge => 'Taxa de serviço';
  String get serviceChargeAbbreviated => 'Serviço';
  String get serviceChargePercentage => 'Porcetagem da taxa de serviço';
  String get subtotal => "Subtotal";
  String get suggestionCriticalOrPraise => "Sugestão, crítica ou elogio";
  String get sunday => "Domingo";
  String get support => 'Suporte';
  String get supportContact => 'Contato do suporte';
  String get surveys => 'Enquetes';
  String get surveyResult => 'Resultado da enquete';
  String get table => 'Mesa';
  String get tableConfigurations => 'Configurações da mesa';
  String get thursday => 'Quinta';
  String get time => 'Horário';
  String get total => 'Total';
  String get totalPaid => 'Total pago';
  String get totalByPerson => 'Total por pessoa';
  String get tuesday => 'Terça';
  String get turnBack => 'Voltar';
  String get unselectAll => "Desselecionar todos";
  String get unselectAllProducts => "Desselecionar todos produtos";
  String get updateApplication => "Atualizar aplicativo";
  String get updateConcentratorParameters =>
      "Atualizar parâmetros do concentrador";
  String get updateConfigurations => "Alterar configurações";
  String get updateDevicesData => "Atualizar dados dos dispositivos";
  String get updateDevicesDataInFirebase =>
      "Atualizar dados dos dispositivos no firebase";
  String get updateEnterprise => "Atualizar empresa";
  String get updateMenu => "Atualizar menu";
  String get updateTableNumberAndPeopleNumbers =>
      "Alterar mesa e quantidade de pessoas";
  String get updateTableNumber => "Alterar mesa";
  String get useProductReducedName => 'Usar nome reduzido do produto';
  String get userCode => 'Código do usuário';
  String get user => 'Usuário';
  String get url => 'Empresa ou url';
  String get validateEnterprise => 'Validar empresa';
  String get version => 'Versão';
  String get voucher => 'Voucher';
  String get wait => 'Aguarde...';
  String get waitDaysPreloadImage => 'Dias para pré-carregar imagens';
  String get wantRemoveRequestedProduct =>
      'Deseja realmente remover o produto dos produtos solicitados?';
  String get wednesday => "Quarta";
  String get withoutCovenant => "Sem convênio";
  String get yes => "Sim";
  String get zoomImage => "Dar zoom na imagem";
}
