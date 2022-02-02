import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:photo_gallery_app/api/auth.dart';
import 'package:photo_gallery_app/api/fcm.dart';
import '../home.dart';

enum UserType { normal, photographer }

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserType? _userType = UserType.normal;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Iniciar sesión'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*GestureDetector(
                    onTap: () async {
                      image = await _picker.pickImage(source: ImageSource.gallery);
                    },
                    child: const Text('Crear cuenta',style:TextStyle(color: Colors.blue),),
                  ),*/
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        XFile? selectedImage = await _picker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          _image = File(selectedImage!.path);
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.fitHeight,
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade200),
                                width: 200,
                                height: 200,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre de usuario',
                      hintText: 'Ingresa tu usuario',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person_pin_rounded,
                      ),
                    ),
                    controller: usernameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'El usuario es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      hintText: 'Ingresa tu nombre completo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                    ),
                    controller: fullNameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      hintText: 'Ingresa tu correo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                    ),
                    controller: emailController,
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
                  ListTile(
                    title: const Text('Normal'),
                    leading: Radio<UserType>(
                      value: UserType.normal,
                      groupValue: _userType,
                      onChanged: (UserType? value) {
                        setState(() {
                          _userType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Fotógrafo'),
                    leading: Radio<UserType>(
                      value: UserType.photographer,
                      groupValue: _userType,
                      onChanged: (UserType? value) {
                        setState(() {
                          _userType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                          50), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    child: const Text('Registrarme'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void register() async {
    Map<String, dynamic> values = {
      'username': usernameController.value.text,
      'fullName': fullNameController.value.text,
      'email': emailController.value.text,
      'password': passwordController.value.text,
      'role': _userType == UserType.normal ? '3' : '4',
      'profilePhoto': '',
    };
    if (_image?.path != null) {
      Auth().register(values, _image!.path).listen((event) {
        print(event);
        if (event) {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          messaging.getToken().then((value) => {
            Fcm().addToken(value!)
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  }

}
