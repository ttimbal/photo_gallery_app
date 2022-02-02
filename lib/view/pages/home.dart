import 'package:flutter/material.dart';
import 'package:photo_gallery_app/api/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:photo_gallery_app/api/fcm.dart';
import 'package:photo_gallery_app/view/pages/eventos/my_events.dart';
import 'auth/login.dart';
import 'fotos/my_photos.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int _selectedIndex = 0;
  String _title = 'fotos';


  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MyPhotos(),
    /*Text(
      'fotos',
      style: optionStyle,
    ),*/
    MyEvents(),
    Text(
      'Salir',
      style: optionStyle,
    ),
  ];
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index==0) _title='fotos';
      if(index==1) _title='Eventos';
      if(index==2 ){
        if(Auth().logout()) {
          messaging.deleteToken();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'fotos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Salir',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
