import 'package:flutter/material.dart';

class TextAreaWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedCopy;

  const TextAreaWidget({
    required this.text,
    required this.onClickedCopy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Container(
              height: 100,
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: SelectableText(
                text.isEmpty ? 'Scan an Image to get text' : text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.black),
            color: Colors.grey[200],
            onPressed: onClickedCopy,
          ),
        ],
      );
}
// Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Date " +
//                               state.text.split("\n")[1].split(' ')[0],
//                           style: TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                         Text(
//                           state.text.split("\n")[5],
//                         ),
//                         Text(
//                           state.text.split("\n")[6],
//                         ),
//                         Text(
//                           state.text.split("\n")[7],
//                         ),
//                         Text(
//                           state.text.split("\n")[8],
//                         ),
//                         Text(
//                           state.text.split("\n")[9],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
