import 'package:clean_celta_mobile/main/factories/pages/enterprise_validation/enterprise_validation.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

import 'package:flutter/material.dart';

Widget makeEnterpriseValidationPage() => EnterpriseValidationPage(
      makeGetxEnterpriseValidationPresenter(),
    );
