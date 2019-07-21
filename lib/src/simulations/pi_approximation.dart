import 'package:flutter/material.dart';
import 'dart:math' as math;

double pi = 0, total = 0, insideCircle = 0;
List<List<double>> coordinates = List();

class PiApproximation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Pi Approximation",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: <Widget>[
          RepaintBoundary(
            child: CustomPaint(
              painter: BackgroundPainter(),
              willChange: false,
              isComplex: true,
              child: Container(),
            ),
          ),
          MakeDots(),
          Positioned(
            top: 20,
            left: 10,
            child: Values(),
          ),
          Align(
            alignment: Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Pi (approx): ",
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                PiValue(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  double R;
  @override
  void paint(Canvas canvas, Size size) {
    R = size.width / 2.1;

    final brush = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      R,
      brush,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        height: 2 * R,
        width: 2 * R,
      ),
      brush,
    );
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BackgroundPainter oldDelegate) => false;
}

class Values extends StatefulWidget {
  _ValuesState createState() => _ValuesState();
}

class _ValuesState extends State<Values> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Text(
      "Dots inside circle (Red): ${insideCircle.toInt()}\n"
      "Total dots (Red + Green): ${total.toInt()}\n\n"
      "Approx Value of Pi = 4 * Red / (Red + Green)",
      style: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }
}

class PiValue extends StatefulWidget {
  _PiValueState createState() => _PiValueState();
}

class _PiValueState extends State<PiValue> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Text(
      "${pi.toStringAsFixed(20)}",
      style: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }
}

class MakeDots extends StatefulWidget {
  _MakeDotsState createState() => _MakeDotsState();
}

class _MakeDotsState extends State<MakeDots> {
  @override
  void dispose() {
    coordinates.clear();
    total = 0;
    insideCircle = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return CustomPaint(
      painter: DotPainter(),
      child: Container(),
    );
  }
}

class DotPainter extends CustomPainter {
  var brush = Paint();
  final random = math.Random();
  double R;

  @override
  void paint(Canvas canvas, Size size) {
    double x, y;
    R = size.width / 2.1;

    for (int i = 0; i < 10; i++) {
      x = -R + 2 * random.nextDouble() * R;
      y = -R + 2 * random.nextDouble() * R;

      coordinates.add([x, y]);
      if (x * x + y * y <= R * R) ++insideCircle;
      ++total;
    }

    coordinates.forEach((coordinate) {
      x = coordinate[0];
      y = coordinate[1];

      (x * x + y * y > R * R)
          ? brush.color = Colors.greenAccent[400]
          : brush.color = Colors.red;

      canvas.drawCircle(
        Offset(size.width / 2 + x, size.height / 2 + y),
        1,
        brush,
      );
    });

    pi = 4 * insideCircle / total;
  }

  @override
  bool shouldRepaint(DotPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(DotPainter oldDelegate) => false;
}
