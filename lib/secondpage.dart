import 'package:flutter/material.dart';
import 'main.dart';

class HomePage2 extends StatefulWidget {
  HomePage2(this.name,this.flag);
  String name;
  bool flag;

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(widget.name),
      ),
      body: Container(
        child: ListView.builder(itemBuilder: (context,index) => CardItem(context, index),itemCount: 5,),
      ),
    );
  }

  CardItem(BuildContext context, int index){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: (){
          SecondPage.name = 'Episode ${index+1}';
          SecondPage.index = index;
          Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
        },
        child: Card(
          color: MyApp.flag[index] ? Colors.blue : Colors.white,
          child: ListTile(
            title: Text('Episode ${index+1}'),
            subtitle: Text('Unwatched or Watched'),
          ),
        ),
      ),
    );
  }
}


class SecondPage extends StatefulWidget {
  static String name;
  static int index;
  static bool flag= true;
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(SecondPage.name),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonStyleNo(context,'Unwatched', Colors.white),
            SizedBox(
              width: 20,
            ),
            ButtonStyleYes(context,'Watched', Colors.blue),
          ],
        ),
      ),
    );
  }
  ButtonStyleNo(BuildContext context,String text, Color color){
    return GestureDetector(
      onTap: (){
        setState(() {
          MyApp.flag[SecondPage.index] = false;
        });
        Navigator.maybePop(context,MaterialPageRoute(builder: (context)=> HomePage2(SecondPage.name, SecondPage.flag)));
      },
      child: Container(
        child: new Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(text),
          ),
        ),
      ),
    );
  }
  ButtonStyleYes(BuildContext context,String text, Color color){
    return GestureDetector(
      onTap: (){
        setState(() {
          MyApp.flag[SecondPage.index] = true;
        });
        Navigator.maybePop(context,MaterialPageRoute(builder: (context)=> HomePage2(SecondPage.name, SecondPage.flag)));
      },
      child: Container(
        child: new Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
