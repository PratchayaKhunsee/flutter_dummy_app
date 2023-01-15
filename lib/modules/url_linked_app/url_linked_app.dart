import 'dart:async';

import 'package:uni_links/uni_links.dart';

Future<String> handlePathFromLink({
  String Function(String? link)? handler,
  String defaultPath = '/',
  void Function(Object error, StackTrace stacktrace, String? link)? onError,
}) async {
  String? obtained;

  try {
    obtained = await getInitialLink();

    if (handler != null) return handler(obtained);

    return obtained ?? defaultPath;
  } catch (e, s) {
    onError?.call(e, s, obtained);
    return defaultPath;
  }
}

StreamSubscription<String?> subscribeForLink({
  required void Function(String? link) onData,
  void Function()? onDone,
  Function? onError,
  bool? cancelOnError,
}) {
  return linkStream.listen(
    onData,
    cancelOnError: cancelOnError,
    onDone: onDone,
    onError: onError,
  );
}
