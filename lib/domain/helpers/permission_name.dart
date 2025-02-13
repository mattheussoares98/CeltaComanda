enum PermissionName {
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

extension PermissionNameExtension on PermissionName {
  String get description {
    switch (this) {
      case PermissionName.agendamentoDeProdutos:
        return "Agendamento de produtos";
      case PermissionName.atualizarMenu:
        return "Atualizar menu";
      case PermissionName.cancelarItens:
        return "Cancelar itens";
      case PermissionName.configuracoesDaMesa:
        return "Configurações da Mesa";
      case PermissionName.consultarVendas:
        return "Consultar vendas";
      case PermissionName.fazerLogout:
        return "Fazer logout";
      case PermissionName.fecharMesa:
        return "Fechar mesa";
      case PermissionName.liberarBloquearMesa:
        return "Liberar/Bloquear mesa";
      case PermissionName.parametros:
        return "Parâmetros";
      case PermissionName.reservarMesa:
        return "Reservar mesa";
      case PermissionName.trocarProdutosEntreComandas:
        return "Trocar produtos entre comandas";
    }
  }
}
