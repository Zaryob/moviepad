import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  final String title;
  final int userNo;
  Dashboard({this.title, this.userNo});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final avatar = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'logo',
          child: SizedBox(
            height: 160,
            child: Center(child: Text('Connection Status: $_connectionStatus',
            style: TextStyle(color: Colors.blue, fontSize: 20))),
            /*Container(
              decoration: const BoxDecoration(color: Colors.blue),
            ),*/
          )),
    );
    final description = Padding(
      padding: EdgeInsets.all(10),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            text:
                'Produced by: \n   Abdulkadir Bozoğlu \n   Kutay Karaman \n   Süleyman Poyraz',
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
    );
    final buttonLogout = FlatButton(
        child: Text(
          'Logout',
          style: TextStyle(color: Colors.red[800], fontSize: 20),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        });
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("User Dashboard"),
          ),
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[avatar, description, buttonLogout],
        ),
      ),
    ));
  }
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubs;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString().substring(19).toUpperCase());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}
