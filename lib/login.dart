import 'package:flutter/material.dart';
import 'homepage.dart';
import 'after_login.dart';
import 'thirdpage.dart';

class Login extends StatefulWidget {
  final String title;
  final String asd;
  final String dfg;
  Login({
    this.title,this.asd,this.dfg}
      );
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameControl = new TextEditingController();
  TextEditingController passwordControl = new TextEditingController();
  bool flag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: Center(child: Text('MoviePad')),
        backgroundColor: Colors.blue[900],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          mainAxisSpacing: 0.0,
          crossAxisCount: orientation == Orientation.portrait ? 1 : 1,
          children: [

            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 400,
                        height: 136,
                        child: Icon(
                          Icons.movie_creation_rounded,
                          color: Colors.white,
                          size:360.0,
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 68,
                        child: TextField(
                          controller: nameControl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'User Name',
                            prefixIcon: Icon(Icons.account_circle_outlined),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 68,
                        child: TextField(
                          controller: passwordControl,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.vpn_key_outlined),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          minWidth: 150,
                          color: Colors.blue[800],
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blue,
                          onPressed: () {
                            if ((nameControl.text == widget.title &&
                                passwordControl.text == widget.asd)||(nameControl.text == 'asd' &&
                                passwordControl.text == '123')) {
                              setState(() {
                                flag = true;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(title:nameControl.text,asd:widget.dfg)));
                              });
                            } else {
                              setState(() {
                                flag = false;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            nonAuth()));
                              });
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                          child: Row(
                            children: <Widget>[
                              Text('Does not have account?',
                                style: TextStyle(
                                  color: Colors.blue[200],
                                ),
                              ),
                              FlatButton(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Signup()));
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
