import 'package:firebase_ml_text_recognition/google_ml/camera_view.dart';
import 'package:firebase_ml_text_recognition/google_ml/text_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextDetectorView extends StatefulWidget {
  @override
  _TextDetectorViewState createState() => _TextDetectorViewState();
}

class _TextDetectorViewState extends State<TextDetectorView> {
  // TextDetector textDetector = GoogleMlKit.vision.textDetector();
  TextDetector textDetector = GoogleMlKit.vision.textDetector();

  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(
      inputImage,
    );
    textDetector.close();
    print('Found textBlocks');
    recognisedText.blocks.forEach((element) {
      print("${element.text}");
    });
    // RecognisedText text = await extractText(recognisedText, 6);
    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final painter = TextDetectorPainter(recognisedText, inputImage.inputImageData!.size, inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  List<String> extractText(visionText, regexNumber) {
    List<String> text = [];

    late RegExp ticketRegex; // = RegExp(r"\d[:][\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d[\s]\d\d");
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
          text.add(line.text);
        }
        if (regexNumber == 5 || regexNumber == 6) {
          if (singleDigit.hasMatch(line.text)) {
            text.add(line.text);
          }
        }
        if (dateRegex.hasMatch(line.text)) {
          text.add(dateRegex.stringMatch(line.text)!);
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
