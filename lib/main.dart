import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

void main(){
  runApp(MaterialApp(
    home: SignPad(),
  ));
}

class SignPad extends StatefulWidget {
  @override
  _SignPadState createState() => _SignPadState();
}

class _SignPadState extends State<SignPad> {
  ByteData _img = ByteData(0);
  Color black = Colors.black;
  double strokeWidth = 2;
  final GlobalKey<SignatureState> _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signature Pad'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            height: 350,
            decoration: BoxDecoration(border: Border.all(color: black)),
            padding: const EdgeInsets.all(8.0),
            child: Signature(
              color: black,
              key: _sign,
              onSign: (){
                final sign = _sign.currentState;
              },
              strokeWidth: strokeWidth,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            _materialButton(
              Colors.green,
              () async {
                final sign = _sign.currentState;
                final image = await sign.getData();
                var data = await image.toByteData(format: ui.ImageByteFormat.png);
                sign.clear();
                final encode = base64.encode(data.buffer.asUint8List());
                setState(() {
                  _img = data;
                });
              },
              'Save'
            ),
            _materialButton(
              Colors.grey,
              (){
                final sign = _sign.currentState;
                sign.clear();
                setState(() {
                  _img = ByteData(0);
                });
              },
              'Clear'
            )
          ],)
        ],
      ),
    );
  }

  Widget _materialButton(Color color, Function onPressed, String text){
    return MaterialButton(
      color: color,
      onPressed: onPressed,
      child: Text(text),
    );
  }

}
