part of 'my_barcode_scanner.dart';

class _MyBarcodeScannerDetectionData extends ChangeNotifier {
  Size? cameraSize;
  List<Offset>? corners;

  void update() {
    notifyListeners();
  }
}

class _MyBarcodeScannerDetectionPainter extends CustomPainter {
  final _MyBarcodeScannerDetectionData data;
  final BoxConstraints constraints;

  _MyBarcodeScannerDetectionPainter({
    required this.data,
    required this.constraints,
  });
  @override
  void paint(Canvas canvas, Size _) {
    final corners = data.corners;
    final cameraSize = data.cameraSize;
    final widgetSize = Size(constraints.maxWidth, constraints.maxHeight);

    if (cameraSize == null || corners == null) return;

    final paint = Paint();
    final diffRatio = widgetSize.aspectRatio - cameraSize.aspectRatio;
    const idealSmallerHeight = 150.0;
    final points = <Offset>[];
    final smallerPoints = <Offset>[];

    for (final c in corners) {
      final smallerCoverWidth = idealSmallerHeight * cameraSize.aspectRatio;
      if (diffRatio < 0) {
        final coverWidth = widgetSize.height * cameraSize.aspectRatio;

        points.add(Offset(
          (widgetSize.width / 2 - coverWidth / 2 + c.dx / cameraSize.width * coverWidth),
          c.dy / cameraSize.height * widgetSize.height,
        ));

        smallerPoints.add(Offset(
          10 + c.dx / cameraSize.width * smallerCoverWidth,
          10 + c.dy / cameraSize.height * idealSmallerHeight,
        ));
      } else if (diffRatio > 0) {
        final coverHeight = widgetSize.width * cameraSize.height / cameraSize.width;

        points.add(Offset(
          c.dx / cameraSize.width * widgetSize.width,
          (widgetSize.height / 2 - coverHeight / 2 + c.dy / cameraSize.height * coverHeight),
        ));

        smallerPoints.add(Offset(
          10 + c.dx / cameraSize.width * smallerCoverWidth,
          10 + c.dy / cameraSize.height * idealSmallerHeight,
        ));
      } else {
        points.add(Offset(
          c.dx / cameraSize.width * widgetSize.width,
          c.dy / cameraSize.height * widgetSize.height,
        ));

        smallerPoints.add(Offset(
          10 + c.dx / cameraSize.width * smallerCoverWidth,
          10 + c.dy / cameraSize.height * idealSmallerHeight,
        ));
      }
    }

    // Painting

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFFFE0000);

    canvas.drawPath(Path()..addPolygon(points, true), paint);

    if (diffRatio < 0) {
      final coverWidth = idealSmallerHeight * cameraSize.aspectRatio;

      // Camera view

      paint
        ..style = PaintingStyle.fill
        ..color = const Color(0x60000000);
      canvas.drawRect(Rect.fromLTWH(10, 10, coverWidth, idealSmallerHeight), paint);

      paint
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFFFFFFF);
      canvas.drawRect(Rect.fromLTWH(10, 10, coverWidth, idealSmallerHeight), paint);

      // Widget view
      paint.color = const Color(0xFFFFFF00);
      canvas.drawRect(
          Rect.fromLTWH(
            10 + coverWidth / 2 - idealSmallerHeight * widgetSize.aspectRatio / 2,
            10,
            idealSmallerHeight * widgetSize.aspectRatio,
            idealSmallerHeight,
          ),
          paint);
    } else if (diffRatio > 0) {
      final coverWidth = idealSmallerHeight * cameraSize.aspectRatio;

      // Camera view
      paint
        ..style = PaintingStyle.fill
        ..color = const Color(0x60000000);
      canvas.drawRect(Rect.fromLTWH(10, 10, coverWidth, idealSmallerHeight), paint);

      paint
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFFFFFFF);

      canvas.drawRect(Rect.fromLTWH(10, 10, coverWidth, idealSmallerHeight), paint);

      // Widget view
      paint.color = const Color(0xFFFFFF00);
      canvas.drawRect(
          Rect.fromLTWH(
            10,
            10 + idealSmallerHeight / 2 - coverWidth * widgetSize.height / widgetSize.width / 2,
            coverWidth,
            coverWidth * widgetSize.height / widgetSize.width,
          ),
          paint);
    } else {
      paint
        ..style = PaintingStyle.fill
        ..color = const Color(0x60000000);
      canvas.drawRect(Rect.fromLTWH(10, 10, idealSmallerHeight * widgetSize.aspectRatio, idealSmallerHeight), paint);

      paint
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFFFFF00);
      canvas.drawRect(Rect.fromLTWH(10, 10, idealSmallerHeight * widgetSize.aspectRatio, idealSmallerHeight), paint);
    }

    paint
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFFE0000);

    canvas.drawPath(Path()..addPolygon(smallerPoints, true), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _MyBarcodeScannerDetectionPaint extends StatefulWidget {
  final _MyBarcodeScannerDetectionData data;

  const _MyBarcodeScannerDetectionPaint({
    required this.data,
  });

  @override
  _MyBarcodeScannerDetectionPaintState createState() => _MyBarcodeScannerDetectionPaintState();
}

class _MyBarcodeScannerDetectionPaintState extends State<_MyBarcodeScannerDetectionPaint> {
  @override
  void initState() {
    super.initState();
    widget.data.addListener(listen);
  }

  @override
  void dispose() {
    widget.data.removeListener(listen);
    super.dispose();
  }

  void listen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CustomPaint(
        painter: _MyBarcodeScannerDetectionPainter(
          data: widget.data,
          constraints: constraints,
        ),
      ),
    );
  }
}
