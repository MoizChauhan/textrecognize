import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(File imageFile, int regexNumber) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();
      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text = extractText(visionText, regexNumber);
        return text.isEmpty ? 'No text found in the image' : text;
      } catch (error) {
        return error.toString();
      }
    }
  }

  static extractText(VisionText visionText, regexNumber) {
    String text = '';

    RegExp ticketRegex; // = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");
    switch (regexNumber) {
      case 0:
        print("Lotto");
        ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");

        break;
      case 1:
        print("SZYBKIE 600");
        ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");

        break;
      case 2:
        print("Multi Multi");
        ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");

        break;
      case 3:
        print("Mini Lotto");
        ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");

        break;
      case 4:
        print("KENO");
        ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");
        break;
      case 5:
        print("Euro Jackpot");
        ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");
        break;
      case 6:
        print("EKStra Pensja");
        ticketRegex = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");
        break;
      default:
    }
    RegExp dateRegex = RegExp(r"\b\d\d[.]\d\d[.]\d\d");
    RegExp singleDigit = RegExp(r"\b\d\b$");
    int i = 0;
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        // for (TextElement word in line.elements) {
        //   text = text + word.text + ' ';
        // }
        print("line $i : ${line.text} ");
        if (ticketRegex.hasMatch(line.text)) {
          text = text + line.text + '\n';
        }
        if (regexNumber == 5 || regexNumber == 6) {
          if (singleDigit.hasMatch(line.text)) {
            text = text + line.text + '\n';
          }
        }
        if (dateRegex.hasMatch(line.text)) {
          text = text + dateRegex.stringMatch(line.text) + '\n';
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
