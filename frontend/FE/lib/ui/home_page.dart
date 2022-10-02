import 'package:drawing_app/models/pen_stroke_model.dart';
import 'package:drawing_app/providers/rec.dart';
import 'dart:convert';
import 'package:flutter/material.dart' hide Ink;
import 'package:drawing_app/ui/styles/icon_styles.dart';
import 'package:drawing_app/ui/constants/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drawing_app/providers/bg_color_provider.dart';
import 'package:drawing_app/providers/eraser_provider.dart';
import 'package:drawing_app/providers/sheetnumber_provider.dart';
import 'package:drawing_app/providers/sheets_provider.dart';
import 'package:drawing_app/ui/painters/draw.dart';
import 'package:drawing_app/ui/components/left_appbar.dart';
import 'package:drawing_app/ui/components/right_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:screenshot/screenshot.dart';

import 'package:flutter/services.dart' show rootBundle;

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  @override
  final controller = ScreenshotController();
  String label = "";
  String _recognizedText = '';
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) => SafeArea(
          child: Stack(
            children: [
              Screenshot(
                controller: controller,
                child: Consumer<SheetsViewProvider>(
                  builder: (context, sheetView, child) {
                    return sheetView.isGrid
                        ? GridPaper(
                            interval: 20,
                            divisions: 1,
                            subdivisions: 1,
                            child: Consumer<SheetNumberProvider>(
                              builder: (context, sheetNProv, child) {
                                return Consumer<EraserProvider>(
                                  builder: (context, eraseProv, child) {
                                    print('ERASER CHANGED');
                                    return Consumer<BgColorProvider>(
                                      builder: (BuildContext context, bg,
                                              Widget child) =>
                                          Container(
                                        color: bg.bgColor,
                                        child: MouseRegion(
                                          cursor: eraseProv.isEraser
                                              ? SystemMouseCursors.copy
                                              : SystemMouseCursors.basic,
                                          child: GestureDetector(
                                            onPanUpdate:
                                                (DragUpdateDetails details) {
                                              setState(
                                                () {
                                                  RenderBox object = context
                                                      .findRenderObject();
                                                  Offset _localPosition = object
                                                      .globalToLocal(details
                                                          .globalPosition);
                                                  PenStroke _localPoint =
                                                      PenStroke();
                                                  _localPoint.color =
                                                      eraseProv.isEraser
                                                          ? bg.bgColor
                                                          : brushColor;
                                                  _localPoint.offset =
                                                      _localPosition;
                                                  _localPoint.brushWidth =
                                                      eraseProv.isEraser
                                                          ? eraserWidth
                                                          : brushWidth;
                                                  _localPoint.strokeCap =
                                                      strokeCap;
                                                  points = List.from(points)
                                                    ..add(_localPoint);
                                                },
                                              );
                                            },
                                            onPanEnd:
                                                (DragEndDetails details) async {
                                              deletedPoints.clear();
                                              points.add(null);
                                              print('POINTS: ${points.length}');
                                              final image =
                                                  await controller.capture();
                                              final base64Image =
                                                  base64Encode(image);

                                              final resp = await context
                                                  .read<RekognizeProvider>()
                                                  .search(base64Image);
                                              setState(() {
                                                label = resp;
                                              });
                                            },
                                            child: CustomPaint(
                                              painter: DrawPen(points: points),
                                              size: Size.infinite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : Consumer<SheetNumberProvider>(
                            builder: (context, sheetNProv, child) {
                              print(
                                  'NUMBER OF SHEETS 2: ${sheetNProv.sheetNumber}');

                              return Consumer<EraserProvider>(
                                builder: (context, eraseProv, child) =>
                                    Consumer<BgColorProvider>(
                                  builder: (context, bg, child) => Container(
                                    color: bg.bgColor,
                                    child: MouseRegion(
                                      cursor: eraseProv.isEraser
                                          ? SystemMouseCursors.disappearing
                                          : SystemMouseCursors.basic,
                                      child: GestureDetector(
                                        onPanUpdate:
                                            (DragUpdateDetails details) {
                                          setState(
                                            () {
                                              RenderBox object =
                                                  context.findRenderObject();
                                              Offset _localPosition =
                                                  object.globalToLocal(
                                                      details.globalPosition);
                                              PenStroke _localPoint =
                                                  PenStroke();
                                              _localPoint.color =
                                                  eraseProv.isEraser
                                                      ? bg.bgColor
                                                      : brushColor;
                                              _localPoint.offset =
                                                  _localPosition;
                                              _localPoint.brushWidth =
                                                  eraseProv.isEraser
                                                      ? eraserWidth
                                                      : brushWidth;
                                              _localPoint.strokeCap = strokeCap;
                                              points = List.from(points)
                                                ..add(_localPoint);
                                            },
                                          );
                                        },
                                        onPanEnd:
                                            (DragEndDetails details) async {
                                          deletedPoints.clear();
                                          points.add(null);
                                          final image =
                                              await controller.capture();
                                          final base64Image =
                                              base64Encode(image);
                                          final resp = await context
                                              .read<RekognizeProvider>()
                                              .search(base64Image);
                                          setState(() {
                                            label = resp;
                                          });
                                          print(label);
                                        },
                                        child: CustomPaint(
                                          painter: DrawPen(points: points),
                                          size: Size.infinite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
              TopAppBar(),
              Positioned.fill(
                bottom: 0.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.amber,
                          child: Text(label,
                              style: TextStyle(fontSize: 25, height:0.9,),
                              textAlign: TextAlign.left),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
