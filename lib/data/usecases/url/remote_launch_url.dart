import 'package:url_launcher/url_launcher.dart';

import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLaunchUrl implements LaunchUrl {
  final HttpClient httpAdapter;

  RemoteLaunchUrl({required this.httpAdapter});

  @override
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
}
