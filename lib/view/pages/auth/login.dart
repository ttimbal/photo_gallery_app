import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery_app/api/auth.dart';
import 'package:photo_gallery_app/api/fcm.dart';
import 'package:photo_gallery_app/view/pages/auth/register.dart';
import 'package:photo_gallery_app/view/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Iniciar sesión'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    hintText: 'Ingresa tu correo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  controller: identifierController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'El correo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Ingresa tu contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                  obscureText: true,
                  controller: passwordController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                        50), // fromHeight use double.infinity as width and 40 is the height
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                  child: const Text('Iniciar'),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  // When the child is tapped, show a snackbar.
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                    //const snackBar = SnackBar(content: Text('Tap'));

                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  // The custom button

                    child: const Text('Crear cuenta',style:TextStyle(color: Colors.blue),),

                )
              ],
            ),
          ),
        ));
  }

  void login() async {
    Map<String, dynamic> values={
      'identifier': identifierController.value.text,
      'password': passwordController.value.text,

    };
    bool success=await Auth().login(values);
    if(success){
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value) => {
        Fcm().addToken(value!)
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      const snackBar = SnackBar(content: Text('Inténtalo de nuevo'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
