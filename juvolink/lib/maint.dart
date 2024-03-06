import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Notification App'),
    );
 }
}

class MyHomePage extends StatefulWidget {
 const MyHomePage({Key key, this.title}) : super(key: key);
 final String title;

 @override
 _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
 final TextEditingController _tokenController = TextEditingController();
 final TextEditingController _messageController = TextEditingController();

 String _message = '';
 String _token = '';

 @override
 void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      _token = token;
      _tokenController.text = token;
      print('token: $_token');
    });
    _firebaseMessaging.subscribeToTopic('flutter_notification_app');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        setState(() {
          _message = message['notification']['body'].toString();
        });
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
 }

 static Future<void> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text('FCM Token'),
              subtitle: TextFormField(
                controller: _tokenController,
                readOnly: true,
              ),
            ),
            ListTile(
              title: const Text('Message'),
              subtitle: TextFormField(
                controller: _messageController,
                readOnly: true,
              ),
            ),
            ListTile(
              title: const Text('Last Notification Message'),
              subtitle: Text(_message),
            ),
          ],
        ),
      ),
    );
 }
}