import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(File? imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();
      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text = extractText(visionText);
        return text.isEmpty ? 'No text found in the image' : text;
      } catch (error) {
        return error.toString();
      }
    }
  }

  static extractText(VisionText visionText) {
    String text = '';
    int i = 0;
    int j = 0;
    for (TextBlock block in visionText.blocks) {
      print("block $i ${block.text}");
      for (TextLine line in block.lines) {
        // print("line $j ${line.text}");
        for (TextElement word in line.elements) {
          // print("word $i ${word.text}");
          text = text + word.text! + ' ';
        }
        j++;
        text = text + '\n';
      }
      i++;
    }

    return text;
  }
}
