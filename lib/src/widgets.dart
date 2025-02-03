import 'package:flutter/material.dart';

class chatCard extends StatelessWidget {
  chatCard({required message, required time});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Text("image"),
        Text('Message'),
        Text("time")
      ],),
    );
  }
}