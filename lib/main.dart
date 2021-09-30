import 'package:firebase_ml_text_recognition/lotterySelection.dart';
import 'package:firebase_ml_text_recognition/widget/text_recognition_widget.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Text Recognition';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.purple),
        home: LotterySelection(),
      );
}

class LotteryScan extends StatefulWidget {
  final String title;
  final int regexNumber;

  const LotteryScan({
    @required this.title,
    @required this.regexNumber,
  });

  @override
  _LotteryScanState createState() => _LotteryScanState();
}

class _LotteryScanState extends State<LotteryScan> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 25),
              TextRecognitionWidget(
                regexNumber: widget.regexNumber,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );
}
