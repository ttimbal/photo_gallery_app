import 'package:flutter/material.dart';
import 'package:photo_gallery_app/api/shared_data.dart';
import 'package:photo_gallery_app/constants/Constant.dart';
import 'package:photo_gallery_app/view/pages/auth/login.dart';
import 'package:photo_gallery_app/view/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery',
      theme: ThemeData(
        primarySwatch: Constant.black,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedData().getData('jwt').then((value) => {

      if(value!=null){
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage()))
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginPage()))
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:  const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}



