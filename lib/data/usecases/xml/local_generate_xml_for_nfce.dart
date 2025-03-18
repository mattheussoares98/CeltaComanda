import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../../ui/helpers/helpers.dart';

class LocalGenerateXmlForNfce implements GenerateXmlForNfce {
  @override
  Future<String> generate({
    required PrintedEntity printed,
    required List<ConcentratorFinalizationModel> finalizations,
    required CustomerEntity? customer,
    required int? cpfCnpj,
    required int? pdvNumber,
    required double? incrementValue,
    required int couponFiscalNumber,
  }) async {
    final builder = xml.XmlBuilder();

    final concentratorEnterprise = EnterpriseBuilder
        .entity?.enterpriseConcentradorParametersEntity?.enterprise;

    builder.processing('xml', 'version="1.0" encoding="ISO-8859-1"');
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
        nest: concentratorEnterprise?.considerIcmsForCalculateBaseOfPisCofins ==
                true
            ? 1
            : 0,
      );
      builder.element('CNPJEmpresa', nest: concentratorEnterprise?.cnpj);
      builder.element(
        'INSCESTEmpresa',
        nest: concentratorEnterprise?.inscriptionState,
      );

      builder.element('NumeroCaixa',
          nest: pdvNumber?.toString().padLeft(3, "0"));
      builder.element('NumeroCupom',
          nest: couponFiscalNumber.toString().padLeft(6, "0"));
      builder.element('NumeroOrdemCupom',
          nest: couponFiscalNumber.toString().padLeft(6, "0"));
      builder.element('DataHoraVenda',
          nest: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()));
      builder.element('PDVTYPE', nest: '1');

      final notCanceledProducts =
          printed.Products.where((e) => e.IsCancelled != true);

      int itemIndex = 1;
      for (var index = 0; index < notCanceledProducts.length; index++) {
        final product = notCanceledProducts.toList()[index];

        if (product.childs.isNotEmpty) {
          //TODO fix correct index
          for (var child in product.childs) {
            _addProduct(
              builder,
              itemIndex,
              child.Product!,
              price: child.Value!,
              ean: child.Product?.EanCode,
              productName: child.Product?.Name,
              packingAbbreviation: child.Product?.PackingAbbreviation,
              plu: child.ProductPriceLookUpCode,
              quantity: child.Quantity!,
              totalLiquid: child.TotalLiquid!,
            );
            itemIndex++;
          }
        } else {
          _addProduct(
            builder,
            itemIndex,
            product.Product!,
            price: product.Value!,
            ean: product.Product?.EanCode,
            packingAbbreviation: product.Product?.PackingAbbreviation,
            plu: product.ProductPriceLookUpCode,
            productName: product.Product!.Name,
            quantity: product.Quantity!,
            totalLiquid: product.TotalLiquid!,
          );
        }
        itemIndex++;
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

      if (cpfCnpj != null) {
        builder.element(cpfCnpj.toString().length == 11 ? 'CPF' : "CNPJ",
            nest: cpfCnpj);
      }

      builder.element('Finalizacao', nest: () {
        builder.element('Desconto', nest: 0);
        builder.element('Acrescimo',
            nest: incrementValue != null && incrementValue > 0
                ? _convertToCorrectNumber(incrementValue)
                : 0);

        for (var finalization in finalizations) {
          builder.element('Pagamento', nest: () {
            builder.element('Finalizadora',
                nest: finalization.FinalizationId.toString());
            builder.element('Valor',
                nest: _convertToCorrectNumber(finalization.ValueLiquid));
          });
        }
      });

      builder.element(
        'InfAdic',
        nest: () {
          double totalTaxFromPercImpNBPTNational = printed.Products.where((e) =>
                  e.Product?.PercImpNBPTNational != null &&
                  e.Product!.PercImpNBPTNational! > 0)
              .map((product) => product)
              .fold(0.0, (previous, element) {
            return element.TotalLiquid! *
                (element.Product!.PercImpNBPTNational!);
          });

          double totalTaxFromPercImpNBPTState = printed.Products.where((e) =>
                  e.Product?.PercImpNBPTState != null &&
                  e.Product!.PercImpNBPTState! > 0)
              .map((product) => product)
              .fold(0.0, (previous, element) {
            return element.TotalLiquid! * (element.Product!.PercImpNBPTState!);
          });

          double totalTaxFromPercImpNBPTMunicipal = printed.Products.where(
                  (e) =>
                      e.Product?.PercImpNBPTMunicipal != null &&
                      e.Product!.PercImpNBPTMunicipal! > 0)
              .map((product) => product)
              .fold(0.0, (previous, element) {
            return element.TotalLiquid! *
                (element.Product!.PercImpNBPTMunicipal!);
          });

          double totalTaxFromPercImpNBPT = totalTaxFromPercImpNBPTNational +
              totalTaxFromPercImpNBPTState +
              totalTaxFromPercImpNBPTMunicipal;

          builder.element(
            'Observacoes',
            nest:
                'Valor aproximado dos tributos deste cupom (R\$) ${totalTaxFromPercImpNBPT.toString().toBrazilianNumber()}. Federal ${totalTaxFromPercImpNBPTNational.toString().toBrazilianNumber()} / Estadual ${totalTaxFromPercImpNBPTState.toString().toBrazilianNumber()} / Municipal ${totalTaxFromPercImpNBPTMunicipal.toString().toBrazilianNumber()}. Fonte IBPT(Conforme Lei Federal 12.741/2012)',
          );
        },
      );
    });

    final xmlDoc = builder.buildDocument();
    return xmlDoc.toXmlString(pretty: true);
  }

  void _addProduct(
    xml.XmlBuilder builder,
    int index,
    ProductEntity product, {
    required double price,
    required String? ean,
    required String? productName,
    required String? plu,
    required String? packingAbbreviation,
    required double quantity,
    required double totalLiquid,
  }) {
    builder.element('Produto', nest: () {
      builder.element('Item', nest: index);
      builder.element('PLU', nest: plu);
      if (ean != null && ean.isNotEmpty == true) {
        builder.element('EAN', nest: ean);
      }
      builder.element('NomeProduto', nest: productName);
      builder.element(
        'AbreviacaoEmbalagem',
        nest: packingAbbreviation,
      );
      builder.element('Desconto', nest: 0);
      builder.element('Acrescimo', nest: 0);
      builder.element('Quantidade', nest: _convertToCorrectNumber(quantity));
      builder.element(
        'ValorUnitario',
        nest: _convertToCorrectNumber(price),
      );
      builder.element(
        'ValorTotal',
        nest: _convertToCorrectNumber(totalLiquid),
      );
      builder.element('CustoReposicao',
          nest: _convertToCorrectNumber(product.RepositionCost));
      builder.element(
        'CustoReposicaoMedio',
        nest: _convertToCorrectNumber(product.RepositionCostMiddle),
      );
      builder.element(
        'CustoReposicaoReal',
        nest: _convertToCorrectNumber(product.RepositionCostReal),
      );
      builder.element('CustoLiquido',
          nest: _convertToCorrectNumber(product.LiquidCost));
      builder.element('CustoLiquidoMedio',
          nest: _convertToCorrectNumber(product.LiquidCostMiddle));
      builder.element('CustoLiquidoReal',
          nest: _convertToCorrectNumber(product.LiquidCostReal));
      builder.element('VendaVarejo',
          nest: _convertToCorrectNumber(product.SaleRetailPrice));
      builder.element('VendaAtacado',
          nest: _convertToCorrectNumber(product.WholeSalePrice));
      builder.element('OfertaAtacado',
          nest: _convertToCorrectNumber(product.WholeOfferPrice));
      builder.element('OfertaVarejo',
          nest: _convertToCorrectNumber(product.OfferRetailPrice));
      builder.element(
        'VendaECommerce',
        nest: _convertToCorrectNumber(product.SaleECommercePrice),
      );
      builder.element(
        'OfertaECommerce',
        nest: _convertToCorrectNumber(product.OfferECommercePrice),
      );
      builder.element('CFOP', nest: product.CFOP?.toString());
      builder.element('NCM', nest: product.FiscalClassificationNCM?.toString());

      builder.element('ICMS', nest: () {
        builder.element('CST', nest: product.TributarySituationCode.toString());
        builder.element('ALIQUOTA',
            nest: _convertToCorrectNumber(product.IcmsAliquot));
        builder.element(
          'REDUC',
          nest: _convertToCorrectNumber(product.IcmsReductionMargin),
        );
        builder.element('IVA',
            nest: _convertToCorrectNumber(product.IcmsIVAMargin));
        builder.element('PAUTA',
            nest: _convertToCorrectNumber(product.IcmsStave));
        builder.element('FiscalBenefitCode', nest: "");
      });

      builder.element('PIS', nest: () {
        builder.element('TIPO', nest: product.PisType.toString());
        builder.element('CST',
            nest: product.CSTPisCofins.toString().padLeft(2, "0"));
        builder.element('NatureOperationCode', nest: "");
        builder.element('SocialContributionCodePisCofins', nest: 51);
        builder.element('PERC',
            nest: _convertToCorrectNumber(product.PisPercentage));
      });
      builder.element('COFINS', nest: () {
        builder.element('TIPO', nest: product.CofinsType.toString());
        builder.element('CST', nest: product.CSTPisCofins.toString());
        builder.element('NatureOperationCodePisCofins', nest: "");
        builder.element('SocialContributionCodePisCofins', nest: 51);
        builder.element('PERC',
            nest: _convertToCorrectNumber(product.CofinsPercentage));
      });
    });
  }

  String _convertToCorrectNumber(dynamic value) {
    if (value == null) {
      return "0";
    } else if (value is int) {
      if (value == 0) {
        return "0";
      }
      return value.toString().toInt().toString();
    } else if (value is double) {
      if (value == 0) {
        return "0";
      } else if (value % 1 == 0) {
        return value.toInt().toString();
      }
      return value.toString().toBrazilianNumber();
    } else {
      return "0";
    }
  }
}
