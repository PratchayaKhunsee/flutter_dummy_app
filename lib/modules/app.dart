import 'package:flutter/material.dart';
import 'my_barcode_scanner/my_barcode_scanner.dart';
import 'url_linked_app/url_linked_app.dart';

class App extends StatelessWidget {
  final String initialRoute;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  App({
    super.key,
    this.initialRoute = '/',
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _scaffoldMessengerKey.currentState?.showSnackBar(
      //   SnackBar(content: Text('Opened at "$initialRoute"'), behavior: SnackBarBehavior.floating),
      // );

      subscribeForLink(
        onData: (link) {
          if (link == null) return;

          final uri = Uri.tryParse(link);
          if (uri == null) return;

          final routeName = '/${uri.queryParameters['page'] ?? ''}';

          _navigatorKey.currentState?.pushNamed(routeName);
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('Opened at "$routeName"'), behavior: SnackBarBehavior.floating),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dummy App',
      initialRoute: initialRoute,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        "/scan-barcode": (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Scan Barcode'),
              ),
              body: const MyBarcodeScanner(),
            ),
        '/': (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Dummy app'),
              ),
              body: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed('/scan-barcode');
                    },
                    title: const Text('Open "Scan Barcode" page'),
                  ),
                ],
              ),
            ),
      },
    );
  }
}
