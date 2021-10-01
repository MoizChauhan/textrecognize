import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_ml_text_recognition/Utils/colors.dart';
import 'package:firebase_ml_text_recognition/api/firebase_ml_api.dart';
import 'package:firebase_ml_text_recognition/widget/text_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'controls_widget.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key key,
    this.regexNumber,
  }) : super(key: key);
  final int regexNumber;

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String text = '';
  File image;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Expanded(child: buildImage()),
            const SizedBox(height: 16),
            ControlsWidget(
              onClickedPickImage: cameraAction,
              onClickedScanText: scanText,
              onClickedClear: clear,
            ),
            const SizedBox(height: 16),
            TextAreaWidget(
              text: text,
              onClickedCopy: copyToClipboard,
            ),
          ],
        ),
      );
  //Camera Actions
  cameraAction() {
    showAdaptiveActionSheet(
      title: Text(
        "Select Option",
        style: TextStyle(fontSize: 25),
      ),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text("Camera", style: TextStyle(color: primaryColor)),
          onPressed: () {
            Navigator.pop(context);
            captureImage();
          },
        ),
        BottomSheetAction(
          title: Text(
            "Gallery",
            style: TextStyle(color: primaryColor),
          ),
          onPressed: () {
            Navigator.pop(context);
            pickImage();
          },
        )
      ],
      cancelAction: CancelAction(
        title: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      context: context,
    );
    // showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget buildImage() => Container(
        child: image != null ? Image.file(image) : Icon(Icons.photo, size: 80, color: Colors.black),
      );

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    setImage(File(file.path));
    // cropView(file);
  }

  Future captureImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
    // cropView(file);
    setImage(File(file.path));
  }

  cropView(PickedFile image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio4x3,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop for lottery",
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    setImage(File(croppedFile.path));
  }

  Future scanText() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final text = await FirebaseMLApi.recogniseText(image, widget.regexNumber);
    setText(text);

    Navigator.of(context).pop();
  }

  void clear() {
    setImage(null);
    setText('');
  }

  void copyToClipboard() {
    if (text.trim() != '') {
      FlutterClipboard.copy(text);
    }
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
    scanText();
  }

  void setText(String newText) {
    setState(() {
      text = newText;
    });
  }
}
