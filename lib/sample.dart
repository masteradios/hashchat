import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
class Sample extends StatefulWidget {
  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  String text;
  final FlutterTts flutterTts=FlutterTts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column
        (
        children: [

        ],
      )
    );
  }
}
