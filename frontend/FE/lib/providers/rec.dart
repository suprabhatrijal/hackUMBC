import 'package:drawing_app/providers/cred.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/vision/v1.dart';

class RekognizeProvider extends ChangeNotifier{
  var _client = CredentialsProvider().client;

  Future<String> search(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image},
          "features": [
            {"type": "DOCUMENT_TEXT_DETECTION"}
          ]
        }
      ]
    }));

    WebLabel _bestGuessLabel;
    if (_response.responses[0].fullTextAnnotation == null){
      return "";
    }
    else{

      return _response.responses[0].fullTextAnnotation.text;
    }
    // print(_response);

    // return _bestGuessLabel;
  }
}