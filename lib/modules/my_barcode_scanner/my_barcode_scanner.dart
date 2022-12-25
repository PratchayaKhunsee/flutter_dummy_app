import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part 'my_barcode_scanner_detection.dart';

class MyBarcodeScanner extends StatefulWidget {
  const MyBarcodeScanner({super.key});

  @override
  State<StatefulWidget> createState() => MyBarcodeScannerState();
}

class MyBarcodeScannerState extends State<MyBarcodeScanner> {
  final _controller = MobileScannerController();
  final _detected = _MyBarcodeScannerDetectionData();
  final _paused = ValueNotifier(false);
  var _pauseCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          MobileScanner(
            allowDuplicates: true,
            fit: BoxFit.cover,
            controller: _controller,
            onDetect: (barcode, args) {
              switch (barcode.format) {
                case BarcodeFormat.aztec:
                case BarcodeFormat.dataMatrix:
                case BarcodeFormat.pdf417:
                case BarcodeFormat.qrCode:
                case BarcodeFormat.all:
                case BarcodeFormat.unknown:
                  return;
                default:
              }

              _detected
                ..cameraSize = args?.size
                ..corners = barcode.corners
                ..update();
            },
          ),
          ValueListenableBuilder(
            valueListenable: _paused,
            builder: (context, paused, child) => paused ? const SizedBox() : _MyBarcodeScannerDetectionPaint(data: _detected),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ValueListenableBuilder(
              valueListenable: _paused,
              builder: (context, paused, child) => Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF606060),
                  boxShadow: [BoxShadow(blurRadius: 3)],
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: InkWell(
                  onTap: () async {
                    if (_pauseCompleter.isCompleted) {
                      _pauseCompleter = Completer();
                    }
                    if (_paused.value = !_paused.value) {
                      await _controller.stop();
                    } else {
                      await _controller.start();
                    }

                    _detected
                      ..cameraSize = null
                      ..corners = null
                      ..update();

                    if (!_pauseCompleter.isCompleted) {
                      _pauseCompleter.complete();
                    }
                  },
                  child: Icon(
                    paused ? Icons.play_arrow : Icons.pause,
                    color: const Color(0xFFFFFFFF),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
