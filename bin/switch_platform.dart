// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run bin/switch_platform.dart <platform>');
    print(
        'Available platforms: rede, getnet, cielo, microsoftStore, tablet, webSaleRequestDetails');
    exit(1);
  }

  final inputPlatform = args[0].toLowerCase();
  String targetPlatform;
  String dartEnumName;

  switch (inputPlatform) {
    case 'rede':
      targetPlatform = 'rede';
      dartEnumName = 'rede';
      break;
    case 'getnet':
      targetPlatform = 'getnet';
      dartEnumName = 'getnet';
      break;
    case 'cielo':
      targetPlatform = 'cielo';
      dartEnumName = 'cielo';
      break;
    case 'microsoftstore':
    case 'microsoft_store':
    case 'msstore':
      targetPlatform = 'microsoftStore';
      dartEnumName = 'microsoftStore';
      break;
    case 'tablet':
      targetPlatform = 'tablet';
      dartEnumName = 'tablet';
      break;
    case 'web':
    case 'websalerequestdetails':
    case 'web_sale_request_details':
      targetPlatform = 'webSaleRequestDetails';
      dartEnumName = 'webSaleRequestDetails';
      break;
    default:
      print('Unknown platform: ${args[0]}');
      print(
          'Available platforms: rede, getnet, cielo, microsoftStore, tablet, webSaleRequestDetails');
      exit(1);
  }

  print(
      'Switching platform to: $targetPlatform (Enum: AppPlatform.$dartEnumName)...');

  // 1. Update lib/presentation/helpers/app_platform.dart
  _updateDartPlatform(dartEnumName);

  // 2. Update pubspec.yaml
  _updatePubspec(targetPlatform);

  // 3. Update android/app/build.gradle
  _updateBuildGradle(targetPlatform);

  // 4. Update android/app/src/main/AndroidManifest.xml
  _updateAndroidManifest(targetPlatform);

  // 5. Update MainActivity.kt
  _updateMainActivity(targetPlatform);

  // 6. Update App.kt
  _updateAppKotlin(targetPlatform);

  print('Successfully switched platform configuration!');
}

void _updateDartPlatform(String enumName) {
  final file = File('lib/presentation/helpers/app_platform.dart');
  if (!file.existsSync()) {
    print('Error: lib/presentation/helpers/app_platform.dart not found.');
    return;
  }

  var content = file.readAsStringSync();
  content = content.replaceAll(
    RegExp(r'(const\s+)?AppPlatform activePlatform = AppPlatform\.\w+;'),
    'AppPlatform activePlatform = AppPlatform.$enumName;',
  );
  file.writeAsStringSync(content);
  print('Updated app_platform.dart to AppPlatform.$enumName');
}

void _updatePubspec(String platform) {
  // Comments pubspec deps for cielo and getnet
  final shouldComment = (platform == 'cielo' || platform == 'getnet');
  _toggleFileBlock('pubspec.yaml', 'PLATFORM-DEPS', 'hash', shouldComment);
}

void _updateBuildGradle(String platform) {
  // FIREBASE-DEPS commented for cielo and getnet
  final commentFirebase = (platform == 'cielo' || platform == 'getnet');
  _toggleFileBlock(
      'android/app/build.gradle', 'FIREBASE-DEPS', 'slash', commentFirebase);

  // GETNET-DEPS uncommented only for getnet
  _toggleFileBlock(
      'android/app/build.gradle', 'GETNET-DEPS', 'slash', platform != 'getnet');

  // REDE-DEPS uncommented only for rede
  _toggleFileBlock(
      'android/app/build.gradle', 'REDE-DEPS', 'slash', platform != 'rede');

  // PROFILEINSTALLER uncommented only for getnet
  _toggleFileBlock('android/app/build.gradle', 'PROFILEINSTALLER', 'slash',
      platform != 'getnet');

  // SIGNING-RELEASE commented only for getnet
  _toggleFileBlock('android/app/build.gradle', 'SIGNING-RELEASE', 'slash',
      platform == 'getnet');

  // SIGNING-CONFIG-RELEASE commented only for getnet
  _toggleFileBlock('android/app/build.gradle', 'SIGNING-CONFIG-RELEASE',
      'slash', platform == 'getnet');

  // SIGNING-CONFIG-GETNET uncommented only for getnet
  _toggleFileBlock('android/app/build.gradle', 'SIGNING-CONFIG-GETNET', 'slash',
      platform != 'getnet');
}

void _updateAndroidManifest(String platform) {
  // CIELO-QUERIES uncommented only for cielo
  _toggleFileBlock('android/app/src/main/AndroidManifest.xml', 'CIELO-QUERIES',
      'xml', platform != 'cielo');

  // CIELO-METADATA uncommented only for cielo
  _toggleFileBlock('android/app/src/main/AndroidManifest.xml', 'CIELO-METADATA',
      'xml', platform != 'cielo');

  // CIELO-CALLBACK uncommented only for cielo
  _toggleFileBlock('android/app/src/main/AndroidManifest.xml', 'CIELO-CALLBACK',
      'xml', platform != 'cielo');

  // LAUNCHER-CATEGORIES commented for rede, getnet, cielo
  final commentLauncher =
      (platform == 'rede' || platform == 'getnet' || platform == 'cielo');
  _toggleFileBlock('android/app/src/main/AndroidManifest.xml',
      'LAUNCHER-CATEGORIES', 'xml', commentLauncher);

  // GETNET-PERMISSIONS uncommented only for getnet
  _toggleFileBlock('android/app/src/main/AndroidManifest.xml',
      'GETNET-PERMISSIONS', 'xml', platform != 'getnet');
}

void _updateMainActivity(String platform) {
  // REDE blocks
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'REDE-IMPORTS',
      'slash',
      platform != 'rede');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'REDE-VARS',
      'slash',
      platform != 'rede');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'REDE-SETUP',
      'slash',
      platform != 'rede');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'REDE-RESULT',
      'slash',
      platform != 'rede');

  // GETNET blocks
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'GETNET-IMPORTS',
      'slash',
      platform != 'getnet');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'GETNET-VARS',
      'slash',
      platform != 'getnet');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'GETNET-SETUP',
      'slash',
      platform != 'getnet');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'GETNET-RESULT',
      'slash',
      platform != 'getnet');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'GETNET-DESTROY',
      'slash',
      platform != 'getnet');

  // CIELO blocks
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'CIELO-IMPORTS',
      'slash',
      platform != 'cielo');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'CIELO-VARS',
      'slash',
      platform != 'cielo');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'CIELO-SETUP',
      'slash',
      platform != 'cielo');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'CIELO-RESULT',
      'slash',
      platform != 'cielo');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/MainActivity.kt',
      'CIELO-INTENT',
      'slash',
      platform != 'cielo');
}

void _updateAppKotlin(String platform) {
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/App.kt',
      'REDE-IMPORTS',
      'slash',
      platform != 'rede');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/App.kt',
      'REDE-SETUP',
      'slash',
      platform != 'rede');
  _toggleFileBlock(
      'android/app/src/main/kotlin/br/com/celtaware/comanda/App.kt',
      'REDE-MODULE',
      'slash',
      platform != 'rede');
}

void _toggleFileBlock(
    String filePath, String tag, String commentType, bool shouldComment) {
  final file = File(filePath);
  if (!file.existsSync()) {
    print('Warning: File $filePath not found.');
    return;
  }

  final lines = file.readAsLinesSync();
  final result = <String>[];
  bool inBlock = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trim();

    if (trimmed.contains('[$tag-START]')) {
      inBlock = true;
      result.add(line);
      continue;
    }

    if (trimmed.contains('[$tag-END]')) {
      inBlock = false;
      result.add(line);
      continue;
    }

    if (inBlock) {
      var newLine = line;
      if (shouldComment) {
        if (commentType == 'hash') {
          if (!trimmed.startsWith('#')) {
            final indent = line.length - line.trimLeft().length;
            final space = line.substring(0, indent);
            newLine = '$space# ${line.substring(indent)}';
          }
        } else if (commentType == 'slash') {
          if (!trimmed.startsWith('//')) {
            final indent = line.length - line.trimLeft().length;
            final space = line.substring(0, indent);
            newLine = '$space// ${line.substring(indent)}';
          }
        } else if (commentType == 'xml') {
          if (!trimmed.startsWith('<!--')) {
            final indent = line.length - line.trimLeft().length;
            final space = line.substring(0, indent);
            newLine = '$space<!-- ${line.substring(indent)} -->';
          }
        }
      } else {
        if (commentType == 'hash') {
          if (trimmed.startsWith('#')) {
            final indent = line.length - line.trimLeft().length;
            final space = line.substring(0, indent);
            var content = line.substring(indent + 1);
            if (content.startsWith(' ')) content = content.substring(1);
            newLine = '$space$content';
          }
        } else if (commentType == 'slash') {
          if (trimmed.startsWith('//')) {
            final indent = line.length - line.trimLeft().length;
            final space = line.substring(0, indent);
            var content = line.substring(indent + 2);
            if (content.startsWith(' ')) content = content.substring(1);
            newLine = '$space$content';
          }
        } else if (commentType == 'xml') {
          if (trimmed.startsWith('<!--') && trimmed.endsWith('-->')) {
            final indent = line.length - line.trimLeft().length;
            final space = line.substring(0, indent);
            var content = line.substring(indent + 4, line.length - 3);
            if (content.startsWith(' ')) content = content.substring(1);
            if (content.endsWith(' ')) {
              content = content.substring(0, content.length - 1);
            }
            newLine = '$space$content';
          }
        }
      }
      result.add(newLine);
    } else {
      result.add(line);
    }
  }

  file.writeAsStringSync('${result.join('\n')}\n');
}
