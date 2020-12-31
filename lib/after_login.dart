import 'package:flutter/material.dart';

class nonAuth extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(''),
      ),
      body: Container(
        child: Center(
            child: Text('WRONG NAME OR PASSWORD',
                style: TextStyle(color: Colors.red, fontSize: 25))),
      ),
    );
  }
}
