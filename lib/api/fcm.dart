import 'package:photo_gallery_app/api/shared_data.dart';
import 'package:photo_gallery_app/constants/Constant.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Fcm{
  String url = Constant.url;
  addToken(String token) async{
    var jwt=await SharedData().getData('jwt');
    var user=convert.jsonDecode(await SharedData().getData('user'));
    Map<String, dynamic> map={
        'token':token,
        'user':user['id'].toString()
    };

    var response =
    await http.post(Uri.parse(url + '/fcms'), body: map,headers: {
      'Authorization': 'Bearer ${jwt}'
    });

    if (response.statusCode == 200) {

      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
    } else {
      print('Request failed with status: ${response.body}.');
    }
  }
}