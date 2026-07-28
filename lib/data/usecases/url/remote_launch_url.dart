// [URL-LAUNCHER-ACTIVE-START]
import 'package:url_launcher/url_launcher.dart';
// [URL-LAUNCHER-ACTIVE-END]

import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLaunchUrl implements LaunchUrl {
  final HttpClient httpAdapter;

  RemoteLaunchUrl({required this.httpAdapter});

  @override
// [URL-LAUNCHER-ACTIVE-START]
  Future<void> launch(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      throw Exception();
    }
  }
// [URL-LAUNCHER-ACTIVE-END]
// [URL-LAUNCHER-INACTIVE-START]
  // Future<void> launch(String url) async {}
// [URL-LAUNCHER-INACTIVE-END]
}
