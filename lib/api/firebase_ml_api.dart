import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(File imageFile) async {
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
    RegExp ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");
    RegExp dateRegex = RegExp(r"\b\d\d[.]\d\d[.]\d\d");
    int i =0;
    for (TextBlock block in visionText.blocks) {

      for (TextLine line in block.lines) {
        // for (TextElement word in line.elements) {
        //   text = text + word.text + ' ';
        // }
        print("line $i : ${line.text} ");
        if(ticketRegex.hasMatch(line.text)){

        text = text+ line.text + '\n';
        }
        if(dateRegex.hasMatch(line.text)){
          text = text+ dateRegex.stringMatch(line.text)+ '\n';

        }
      }
      // print("block $i : ${block.text} ");
      // if(block.text.contains("1:") && block.text.contains("2:")){
      //   text = text + block.text + '\n';
      // }
    i++;
    }

    return text;
  }
}
