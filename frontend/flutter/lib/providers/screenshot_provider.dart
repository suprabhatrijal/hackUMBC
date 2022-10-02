
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ScreenshotProvider extends ChangeNotifier {
  final _controller = ScreenshotController();

  ScreenshotController get controller => _controller;

   void  takeScreenshot() async {
     var appDocDir = await getTemporaryDirectory();
     String savePath = appDocDir.path + "/temp.mp4";
     var image = await _controller.capture();
     print(image);
     final result = await ImageGallerySaver.saveImage(
          image,
         quality: 60,
         name: "hello");
     // print(result);
  }

}
