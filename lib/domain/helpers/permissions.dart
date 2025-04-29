enum Permissions {
  agendamentoDeProdutos,
  atualizarMenu,
  cancelarItens,
  configuracoesDaMesa,
  consultarVendas,
  fazerLogout,
  fecharMesa,
  liberarBloquearMesa,
  parametros,
  reservarMesa,
  trocarProdutosEntreComandas,
}

extension PermissionsExtension on Permissions {
  String get description {
    switch (this) {
      case Permissions.agendamentoDeProdutos:
        return "Agendamento de produtos";
      case Permissions.atualizarMenu:
        return "Atualizar menu";
      case Permissions.cancelarItens:
        return "Cancelar itens";
      case Permissions.configuracoesDaMesa:
        return "Configurações da Mesa";
      case Permissions.consultarVendas:
        return "Consultar vendas";
      case Permissions.fazerLogout:
        return "Fazer logout";
      case Permissions.fecharMesa:
        return "Fechar mesa";
      case Permissions.liberarBloquearMesa:
        return "Liberar/Bloquear mesa";
      case Permissions.parametros:
        return "Parâmetros";
      case Permissions.reservarMesa:
        return "Reservar mesa";
      case Permissions.trocarProdutosEntreComandas:
        return "Trocar produtos entre comandas";
    }
  }
}
