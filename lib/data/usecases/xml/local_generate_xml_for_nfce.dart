import 'package:xml/xml.dart' as xml;

import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';

class LocalGenerateXmlForNfce implements GenerateXmlForNfce {
  @override
  Future<String> generate({
    required List<PrintedProductsEntity> products,
    required List<ConcentratorFinalizationModel> finalizations,
    required CustomerEntity? customer,
    required int? cpf,
    required int? cnpj,
    required int? pdvNumber,
    required double? incrementValue,
  }) async {
    final builder = xml.XmlBuilder();

    final concentratorEnterprise = EnterpriseBuilder
        .entity?.enterpriseConcentradorParametersEntity?.enterprise;

    builder.processing('xml', 'version=1.0 encoding=ISO-8859-1');
    builder.element('Cupom', nest: () {
      builder.element(
        'CodigoEmpresa',
        nest: concentratorEnterprise?.enterpriseCode.toString(),
      );
      builder.element(
        'FlagSimplesFederalEmpresa',
        nest: concentratorEnterprise?.federalSimpleType.toString(),
      );
      builder.element(
        'FlagConsideraIcmsCalcBasePisCofinsEmpresa',
        nest: concentratorEnterprise?.considerIcmsForCalculateBaseOfPisCofins
            .toString(),
      );
      builder.element('CNPJEmpresa', nest: concentratorEnterprise?.cnpj);
      builder.element(
        'INSCESTEmpresa',
        nest: concentratorEnterprise?.inscriptionState,
      );

      builder.element('NumeroCaixa', nest: pdvNumber);
      builder.element('NumeroCupom',
          nest: 1); //TODO verify how get this correct number
      builder.element('NumeroOrdemCupom', nest: 1); //TODO equal NumeroCupom
      builder.element('DataHoraVenda', nest: DateTime.now().toIso8601String());
      builder.element('PDVTYPE', nest: '1');

      for (var index = 0; index < products.length; index++) {
        final product = products[index];
        builder.element('Produto', nest: () {
          builder.element('Item', nest: index + 1);
          builder.element('PLU', nest: product.ProductPriceLookUpCode);
          if (product.Product.EanCode != null) {
            builder.element('EAN', nest: product.Product.EanCode);
          }
          builder.element('NomeProduto', nest: product.Product.Name);
          builder.element(
            'AbreviacaoEmbalagem',
            nest: product.Product.PackingAbbreviation,
          );
          builder.element('Quantidade', nest: product.Quantity.toString());
          builder.element('ValorUnitario',
              nest: product.Product.SaleRetailPraticedString?.toString());
          builder.element('ValorTotal', nest: product.TotalLiquid.toString());
          builder.element('CustoReposicao',
              nest: product.Product.RepositionCost?.toString());
          builder.element('CustoReposicaoMedio',
              nest: product.Product.RepositionCostMiddle?.toString());
          builder.element('CustoReposicaoReal',
              nest: product.Product.RepositionCostReal?.toString());
          builder.element('CustoLiquido',
              nest: product.Product.LiquidCost?.toString());
          builder.element('CustoLiquidoMedio',
              nest: product.Product.LiquidCostMiddle?.toString());
          builder.element('CustoLiquidoReal',
              nest: product.Product.LiquidCostReal?.toString());
          builder.element('VendaVarejo',
              nest: product.Product.SaleRetailPrice?.toString());
          builder.element('VendaAtacado',
              nest: product.Product.WholeSalePrice?.toString());
          builder.element('OfertaAtacado',
              nest: product.Product.WholeOfferPrice?.toString());
          builder.element('OfertaVarejo',
              nest: product.Product.OfferRetailPrice?.toString());
          builder.element('VendaECommerce',
              nest: product.Product.SaleECommercePrice?.toString());
          builder.element('OfertaECommerce',
              nest: product.Product.OfferECommercePrice?.toString());
          builder.element('CFOP', nest: product.Product.CFOP?.toString());
          builder.element('NCM',
              nest: product.Product.FiscalClassificationNCM?.toString());

          builder.element('ICMS', nest: () {
            builder.element('CST',
                nest: product.Product.TributarySituationCode.toString());
            builder.element('ALIQUOTA',
                nest: product.Product.IcmsAliquot.toString());
            builder.element('REDUC',
                nest: product.Product.IcmsReductionMargin.toString());
            builder.element('IVA',
                nest: product.Product.IcmsIVAMargin.toString());
            builder.element('PAUTA',
                nest: product.Product.IcmsStave.toString());
          });

          builder.element('PIS', nest: () {
            builder.element('TIPO', nest: product.Product.PisType.toString());
            builder.element('CST',
                nest: product.Product.CSTPisCofins.toString());
            builder.element('PERC',
                nest: product.Product.PisPercentage.toString());
          });
          builder.element('COFINS', nest: () {
            builder.element('TIPO',
                nest: product.Product.CofinsType.toString());
            builder.element('CST',
                nest: product.Product.CSTPisCofins.toString());
            builder.element('PERC',
                nest: product.Product.CofinsPercentage.toString());

            builder.element('TIPO', nest: product.Product.PisType.toString());
            builder.element('CST',
                nest: product.Product.CSTPisCofins.toString());
            builder.element('PERC',
                nest: product.Product.PisPercentage.toString());
          });
        });
      }

      // if (sale.seller != null) {
      //   builder.element('Vendedor', nest: () {
      //     builder.element('Codigo', nest: sale.seller.personalizedCode);
      //   });
      // }

      if (customer != null) {
        builder.element('Cliente', nest: () {
          builder.element('Codigo', nest: customer.Code);
          builder.element('Nome', nest: customer.Name);
          // if (sale.customerAdditional != null) {
          //   builder.element('CodigoAdicional',
          //       nest: sale.customerAdditional.customerAdditionalCode);
          // }

          //for this, I need create a option to add the CPF or CNPJ in the sale
        });
      }

      if (cpf != null) {
        builder.element('CPF', nest: cpf);
      } else if (cnpj != null) {
        builder.element('CNPJ', nest: cnpj);
      }

      builder.element('Finalizacao', nest: () {
        builder.element('Desconto', nest: 0);
        builder.element('Acrescimo', nest: incrementValue.toString());

        for (var finalization in finalizations) {
          builder.element('Pagamento', nest: () {
            builder.element('Finalizadora',
                nest: finalization.FinalizationId.toString());
            builder.element('Valor', nest: finalization.ValueLiquid.toString());
          });
        }
      });

      builder.element(
        'InfAdic',
        nest: () {
          double totalTaxFromPercImpNBPTNational = products
              .where((e) =>
                  e.Product.PercImpNBPTNational != null &&
                  e.Product.PercImpNBPTNational! > 0)
              .map((product) => product)
              .fold(0.0, (previous, element) {
            return element.TotalLiquid * (element.Product.PercImpNBPTNational!);
          });

          double totalTaxFromPercImpNBPTState = products
              .where((e) =>
                  e.Product.PercImpNBPTState != null &&
                  e.Product.PercImpNBPTState! > 0)
              .map((product) => product)
              .fold(0.0, (previous, element) {
            return element.TotalLiquid * (element.Product.PercImpNBPTState!);
          });

          double totalTaxFromPercImpNBPTMunicipal = products
              .where((e) =>
                  e.Product.PercImpNBPTMunicipal != null &&
                  e.Product.PercImpNBPTMunicipal! > 0)
              .map((product) => product)
              .fold(0.0, (previous, element) {
            return element.TotalLiquid *
                (element.Product.PercImpNBPTMunicipal!);
          });

          double totalTaxFromPercImpNBPT = totalTaxFromPercImpNBPTNational +
              totalTaxFromPercImpNBPTState +
              totalTaxFromPercImpNBPTMunicipal;

          builder.element(
            'Observacoes',
            nest:
                'Valor aproximado dos tributos deste cupom (R\$) $totalTaxFromPercImpNBPT. Federal $totalTaxFromPercImpNBPTNational / Estadual $totalTaxFromPercImpNBPTState / Municipal $totalTaxFromPercImpNBPTMunicipal. Fonte IBPT(Conforme Lei Federal 12.741/2012)',
          );
        },
      );
    });

    final xmlDoc = builder.buildDocument();
    return xmlDoc.toXmlString(pretty: true);
  }
}
