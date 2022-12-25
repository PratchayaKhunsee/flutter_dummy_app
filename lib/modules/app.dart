import 'package:flutter/material.dart';
import 'my_barcode_scanner/my_barcode_scanner.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dummy App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dummy App'),
        ),
        body: const MyBarcodeScanner(),
      ),
    );
  }
}
