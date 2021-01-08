import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'moviesql.dart';

const simplePeriodicTask = "simplePeriodicTask";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false);
  Workmanager.registerPeriodicTask(
    "1",
    simplePeriodicTask,
    frequency: Duration(minutes: 15),
    initialDelay: Duration(seconds: 15),
  );
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}
FlutterLocalNotificationsPlugin flip =
new FlutterLocalNotificationsPlugin();
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {


    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);

    switch (task) {
      case simplePeriodicTask:

        print("$simplePeriodicTask was executed");

        loadData();
        break;

      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}

Future<void> loadData() async {

  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  final dbHelper = DatabaseHelper.instance;

  // The 'echo' isolate sends its SendPort as the first message
  SendPort sendPort = await receivePort.first;
  String apiURL =
      'https://api.themoviedb.org/3/movie/latest?api_key=f476c933beeb792de073665402a501ad&language=en-US';

  List msg = await sendReceive(
    sendPort,
    apiURL,
  );
  final List<Map<String, dynamic>> maps = await dbHelper.queryAllRowsLatest();
  int last_id=maps[0]["_id"];

  if(msg[0]["id"]!=dbHelper.findLatest(last_id)){
    dbHelper.deleteLatest(last_id);
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : msg[0]["id"],
      DatabaseHelper.columnTitle  : msg[0]["title"],
      DatabaseHelper.columnDate : msg[0]["release_date"],
      DatabaseHelper.columnMT : msg[0]["media_type"],
      DatabaseHelper.columnOverV: msg[0]["overview"],
      DatabaseHelper.columnBPath: msg[0]["backdrop_path"],
      DatabaseHelper.columnPPath: msg[0]["poster_path"],
      DatabaseHelper.columnVote: msg[0]["vote_average"],

    };
    dbHelper.insertLatest(row);
    _showNotificationWithDefaultSound(flip);
  }
}

// the entry point for the isolate
Future<void> dataLoader(SendPort sendPort) async {
// Open the ReceivePort for incoming messages.
  ReceivePort port = ReceivePort();

// Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  await for (var msg in port) {
    String data = msg[0];
    SendPort replyTo = msg[1];

    String dataURL = data;
    http.Response response = await http.get(dataURL);
// Lots of JSON to parse
    replyTo.send(jsonDecode(response.body));
  }
}

Future sendReceive(SendPort port, msg) {
  ReceivePort response = ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}

Future _showNotificationWithDefaultSound(flip) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    "1",
    'Reminder notifications',
    'Remember about it',
    icon: 'flutter_devs',
    largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(
      0,
      'MoviePad',
      'Found a newly released movie. Check to look at it',
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class MyApp extends StatefulWidget {
  static List<bool> flag = [false, false, false, false, false];
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          messageTitle = message["notification"]["title"];
          notificationAlert = "New Notification Alert";
        });
      },
      onResume: (message) async {
        setState(() {
          messageTitle = message["data"]["title"];
          notificationAlert = "Application opened from Notification";
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(),
    );
  }
}
