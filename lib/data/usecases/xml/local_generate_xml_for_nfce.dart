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
          nest: 1
              .toString()
              .padLeft(6, "0")); //TODO verify how get this correct number
      builder.element('NumeroOrdemCupom',
          nest: 1.toString().padLeft(6, "0")); //TODO equal NumeroCupom
      builder.element('DataHoraVenda',
          nest: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()));
      builder.element('PDVTYPE', nest: '1');

      for (var index = 0; index < products.length; index++) {
        final product = products[index];
        builder.element('Produto', nest: () {
          builder.element('Item', nest: index + 1);
          builder.element('PLU', nest: product.ProductPriceLookUpCode);
          if (product.Product.EanCode != null &&
              product.Product.EanCode!.isNotEmpty) {
            builder.element('EAN', nest: product.Product.EanCode);
          }
          builder.element('NomeProduto', nest: product.Product.Name);
          builder.element(
            'AbreviacaoEmbalagem',
            nest: product.Product.PackingAbbreviation,
          );
          builder.element('Desconto', nest: 0);
          builder.element('Acrescimo', nest: 0);
          builder.element('Quantidade',
              nest: _convertToCorrectNumber(product.Quantity));
          builder.element(
            'ValorUnitario',
            nest: _convertToCorrectNumber(product.Product.SaleRetailPraticed),
          );
          builder.element(
            'ValorTotal',
            nest: _convertToCorrectNumber(product.TotalLiquid),
          );
          builder.element('CustoReposicao',
              nest: _convertToCorrectNumber(product.Product.RepositionCost));
          builder.element(
            'CustoReposicaoMedio',
            nest: _convertToCorrectNumber(product.Product.RepositionCostMiddle),
          );
          builder.element(
            'CustoReposicaoReal',
            nest: _convertToCorrectNumber(product.Product.RepositionCostReal),
          );
          builder.element('CustoLiquido',
              nest: _convertToCorrectNumber(product.Product.LiquidCost));
          builder.element('CustoLiquidoMedio',
              nest: _convertToCorrectNumber(product.Product.LiquidCostMiddle));
          builder.element('CustoLiquidoReal',
              nest: _convertToCorrectNumber(product.Product.LiquidCostReal));
          builder.element('VendaVarejo',
              nest: _convertToCorrectNumber(product.Product.SaleRetailPrice));
          builder.element('VendaAtacado',
              nest: _convertToCorrectNumber(product.Product.WholeSalePrice));
          builder.element('OfertaAtacado',
              nest: _convertToCorrectNumber(product.Product.WholeOfferPrice));
          builder.element('OfertaVarejo',
              nest: _convertToCorrectNumber(product.Product.OfferRetailPrice));
          builder.element(
            'VendaECommerce',
            nest: _convertToCorrectNumber(product.Product.SaleECommercePrice),
          );
          builder.element(
            'OfertaECommerce',
            nest: _convertToCorrectNumber(product.Product.OfferECommercePrice),
          );
          builder.element('CFOP', nest: product.Product.CFOP?.toString());
          builder.element('NCM',
              nest: product.Product.FiscalClassificationNCM?.toString());

          builder.element('ICMS', nest: () {
            builder.element('CST',
                nest: product.Product.TributarySituationCode.toString());
            builder.element('ALIQUOTA',
                nest: _convertToCorrectNumber(product.Product.IcmsAliquot));
            builder.element(
              'REDUC',
              nest:
                  _convertToCorrectNumber(product.Product.IcmsReductionMargin),
            );
            builder.element('IVA',
                nest: _convertToCorrectNumber(product.Product.IcmsIVAMargin));
            builder.element('PAUTA',
                nest: _convertToCorrectNumber(product.Product.IcmsStave));
            builder.element('FiscalBenefitCode', nest: "");
          });

          builder.element('PIS', nest: () {
            builder.element('TIPO', nest: product.Product.PisType.toString());
            builder.element('CST',
                nest: product.Product.CSTPisCofins.toString().padLeft(2, "0"));
            builder.element('NatureOperationCode', nest: "");
            builder.element('SocialContributionCodePisCofins', nest: 51);
            builder.element('PERC',
                nest: _convertToCorrectNumber(product.Product.PisPercentage));
          });
          builder.element('COFINS', nest: () {
            builder.element('TIPO',
                nest: product.Product.CofinsType.toString());
            builder.element('CST',
                nest: product.Product.CSTPisCofins.toString());
            builder.element('NatureOperationCodePisCofins', nest: "");
            builder.element('SocialContributionCodePisCofins', nest: 51);
            builder.element('PERC',
                nest:
                    _convertToCorrectNumber(product.Product.CofinsPercentage));
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
