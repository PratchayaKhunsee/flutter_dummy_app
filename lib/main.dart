import 'package:flutter/material.dart';

import 'modules/url_linked_app/url_linked_app.dart';
import 'modules/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? errorParams;
  final initialRoute = await handlePathFromLink(
    defaultPath: '/',
    handler: (link) {
      if (link == null) return '/';
      final uri = Uri.tryParse(link);
      if (uri == null) return '/';

      return '/${uri.queryParameters['page'] ?? ''}';
    },
    onError: (error, stacktrace, link) {
      errorParams = '?${[if (link != null) 'errVal=$link', 'errType=${error.runtimeType}'].join('&')}';
    },
  );

  runApp(App(
    initialRoute: initialRoute + (errorParams ?? ''),
  ));
}
