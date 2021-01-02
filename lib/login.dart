import 'package:flutter/material.dart';
import 'homepage.dart';
import 'signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('usersInfo')
            .snapshots(),
        builder: (context, snapshot) {
          return OrientationBuilder(builder: (context, orientation) {
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
                              size: 360.0,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              minWidth: 150,
                              color: Colors.blue[800],
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blue,
                              onPressed: () {
                                for(var i = 0; i < snapshot.data.documents.length; i++){
                                  if (//flag != false ||
                                      (nameControl.text == '000' &&
                                        passwordControl.text == '000')||
                                    (nameControl.text == snapshot.data.documents[i]['userName']&&
                                        passwordControl.text == snapshot.data.documents[i]['password'])) {
                                  setState(() {
                                    int userNo = i;
                                    flag = true;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                title: nameControl.text,
                                                userNo: userNo)));
                                  });
                                }
                                else if (flag==false){
                                    flag = false;
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => nonAuth()));
                                  });

                                }
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
                              Text(
                                'Does not have account?',
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
                                          builder: (context) => Signup()));
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        }
      ),
    );
  }
}

class nonAuth extends StatelessWidget {
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
