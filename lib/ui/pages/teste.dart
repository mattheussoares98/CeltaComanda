import 'dart:async';

import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../mixins/mixins.dart';

import 'package:flutter/material.dart';

class EnterpriseValidationPage extends StatefulWidget {
  final EnterpriseValidationPresenter presenter;

  const EnterpriseValidationPage(this.presenter, {super.key});

  @override
  State<EnterpriseValidationPage> createState() =>
      _EnterpriseValidationPageState();
}

class _EnterpriseValidationPageState extends State<EnterpriseValidationPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      await widget.presenter.loadLocalData();

      if (widget.presenter.enterpriseNameController.text.isNotEmpty) {
        widget.presenter.validateEnterpriseInput(
            widget.presenter.enterpriseNameController.text);
      }
    }
  }

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    _rightListController.dispose();
  }

  final ScrollController _rightListController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _scrollListener(List<ExpansibleGroupsViewModel> allGroups,
      List<List<ProductsViewModel>> productsInGroups) {
    // Calcula o índice do produto que está no meio da lista da direita
    final middleIndex = ((_rightListController.offset +
                _rightListController.position.viewportDimension / 2) /
            80)
        .floor();

    // Encontra o grupo correspondente ao produto que está no meio da lista da direita
    int groupIndex = 0;
    int totalItems = 0;
    for (int i = 0; i < productsInGroups.length; i++) {
      totalItems += productsInGroups[i].length;
      if (middleIndex < totalItems) {
        groupIndex = i;
        break;
      }
    }

    // Obtém o grupo correspondente ao produto que está no meio da lista da direita
    final group = allGroups[groupIndex];
    // ignore: avoid_print
    print(group);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          loadingSubscription =
              handleLoading(context, widget.presenter.isLoadingStream);
          mainErrorSubscription =
              handleMainError(context, widget.presenter.mainErrorStream);

          product(String number) => ProductsViewModel(
                IsPromoCombox: "IsPromoCombox",
                ProductsId: "ProductsId",
                SaleRetailPraticed: "SaleRetailPraticed",
                PriceLookupCode: "PriceLookupCode",
                Name: "Product $number",
                PackingAbbreviation: "PackingAbbreviation",
                InternalCodeOnERP: "InternalCodeOnERP",
                InternalCodeOfProductOnERP: "InternalCodeOfProductOnERP",
                EenterpriseId: "EenterpriseId",
                PackingQuantity: "PackingQuantity",
                OfferRetailPrice: "OfferRetailPrice",
                WholeSalePrice: "WholeSalePrice",
                WholeOfferPrice: "WholeOfferPrice",
                OfferECommercePrice: "OfferECommercePrice",
                SaleECommercePrice: "SaleECommercePrice",
                LiquidCost: "LiquidCost",
                LiquidCostMiddle: "LiquidCostMiddle",
                LiquidCostReal: "LiquidCostReal",
                RepositionCost: "RepositionCost",
                RepositionCostMiddle: "RepositionCostMiddle",
                RepositionCostReal: "RepositionCostReal",
                IcmsAliquot: "IcmsAliquot",
                IcmsIVAMargin: "IcmsIVAMargin",
                IcmsReductionMargin: "IcmsReductionMargin",
                IcmsStave: "IcmsStave",
                PercImpNBPTState: "PercImpNBPTState",
                PercImpNBPTMunicipal: "PercImpNBPTMunicipal",
                CofinsType: "CofinsType",
                PisType: "PisType",
                ProductIsFatherComposition: "ProductIsFatherComposition",
                QuantityMinimumWholeSale: "QuantityMinimumWholeSale",
                QuantityMinimumWholeSaleByClass:
                    "QuantityMinimumWholeSaleByClass",
                BalanceTare: "BalanceTare",
                FamilyCode: "FamilyCode",
                DepartmentCode: "DepartmentCode",
                SectionCode: "SectionCode",
                GroupCode: "GroupCode",
                SubGroupCode: "SubGroupCode",
                StockQuantity: "StockQuantity",
                AllowFractionate: "AllowFractionate",
                IsBalance: "IsBalance",
                CanBeWeightyInPdv: "CanBeWeightyInPdv",
                QuantityInBalance: "QuantityInBalance",
                AllowQuantityInPdv: "AllowQuantityInPdv",
                GoesForFastTable: "GoesForFastTable",
                IsAlcoholicProduct: "IsAlcoholicProduct",
                SaleRetailPrice: "SaleRetailPrice",
                PercImpNBPTNational: "PercImpNBPTNational",
                CofinsPercentage: "CofinsPercentage",
                PisPercentage: "PisPercentage",
                CFOP: "CFOP",
                FiscalClassificationNCM: "FiscalClassificationNCM",
                TributarySituationCode: "TributarySituationCode",
                CSTPisCofins: "CSTPisCofins",
                CodeClass: "CodeClass",
                DepartmentName: "DepartmentName",
                SectionName: "SectionName",
                DateOfLastChanged: "DateOfLastChanged",
                GroupName: "GroupName",
                SaleRetailPraticedString: "SaleRetailPraticedString",
                PersonalizedCode: "PersonalizedCode",
                EanCode: "EanCode",
                NameComplete: "NameComplete",
                NameReduced: "NameReduced",
              );

          List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
              loadedMenu = [
            {
              const ExpansibleGroupsViewModel(
                  Name: "Name 1",
                  ExpansibleGroupId: "ExpansibleGroupId 1",
                  ExpansibleGroupType: "ExpansibleGroupType 1",
                  OrderClassification: "OrderClassification 1"): [
                product("1.1"),
                product("1.2"),
                product("1.3"),
                product("1.4"),
                product("1.5"),
                product("1.6"),
                product("1.7"),
                product("1.8"),
                product("1.9"),
                product("1.11"),
                product("1.12"),
                product("1.13"),
                product("1.14"),
                product("1.15"),
              ],
            },
            {
              const ExpansibleGroupsViewModel(
                  Name: "Name 2",
                  ExpansibleGroupId: "ExpansibleGroupId 2",
                  ExpansibleGroupType: "ExpansibleGroupType 2",
                  OrderClassification: "OrderClassification 2"): [
                product("2.1"),
                product("2.2"),
                product("2.3"),
                product("2.4"),
                product("2.5"),
                product("2.6"),
                product("2.7"),
                product("2.8"),
                product("2.9"),
                product("2.11"),
                product("2.12"),
                product("2.13"),
                product("2.14"),
                product("2.15"),
              ],
            },
            {
              const ExpansibleGroupsViewModel(
                  Name: "Name 3",
                  ExpansibleGroupId: "ExpansibleGroupId 3",
                  ExpansibleGroupType: "ExpansibleGroupType 3",
                  OrderClassification: "OrderClassification 3"): [
                product("3.1"),
                product("3.2"),
                product("3.3"),
                product("3.4"),
                product("3.5"),
                product("3.6"),
                product("3.7"),
                product("3.8"),
                product("3.9"),
                product("3.11"),
                product("3.12"),
                product("3.13"),
                product("3.14"),
                product("3.15"),
              ],
            },
          ];

          List<ProductsViewModel> allProducts = loadedMenu
              .expand((group) => group.values.expand((products) => products))
              .toList();
          List<ExpansibleGroupsViewModel> allGroups =
              loadedMenu.map((group) => group.keys.first).toList();

          List<List<ProductsViewModel>> productsInGroups = [];

// Itera sobre loadedMenu para extrair os produtos de cada grupo
          for (var groupData in loadedMenu) {
            // Obtém a lista de produtos para o grupo atual
            List<ProductsViewModel> products = groupData.values.first;

            // Adiciona a lista de produtos à lista de grupos
            productsInGroups.add(products);
          }

          _rightListController
              .addListener(() => _scrollListener(allGroups, productsInGroups));

          return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: allGroups.length,
                  itemBuilder: (context, index) {
                    final group = allGroups[index];
                    return ListTile(
                      title: Text(group.Name),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _rightListController,
                  itemCount: allProducts.length,
                  itemBuilder: (context, index) {
                    final product = allProducts[index];
                    return Container(
                      height: 80,
                      color: Colors.blue,
                      child: ListTile(
                        title: Text(product.Name),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
