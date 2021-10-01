import 'package:firebase_ml_text_recognition/main.dart';
import 'package:flutter/material.dart';

class LotterySelection extends StatelessWidget {
  const LotterySelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lottery Seletion"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            button("Lotto", 0, context),
            button("SZYBKIE 600", 1, context),
            button("Multi Multi", 2, context),
            button("Mini Lotto", 3, context),
            button("KENO", 4, context),
            button("Euro Jackpot", 5, context),
            button("EKStra Pensja", 6, context),
          ],
        ),
      ),
    );
  }

  Widget button(text, regex, context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LotteryScan(title: text, regexNumber: regex),
              ));
        },
        child: Text(text));
  }
}
