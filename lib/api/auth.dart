import 'dart:convert';

import 'package:photo_gallery_app/api/shared_data.dart';
import 'package:photo_gallery_app/constants/Constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Auth {
  String url = Constant.url;

  Future<bool> login(Map<String, dynamic> values) async {
    var response =
    await http.post(Uri.parse(url + '/auth/local'), body: values);

    if (response.statusCode == 200) {

      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      String user = convert.jsonEncode(jsonResponse['user']);
      SharedData().storeData('jwt', jsonResponse['jwt']);
      SharedData().storeData('user', user);
      return true;
    } else {
      print('Request failed with status: ${response.body}.');
      return false;
    }
  }

  bool logout() {
    try {
      SharedData().deleteData('jwt');
      SharedData().deleteData('user');
      return true;
    } catch (error) {
      return false;
    }
  }

  Stream<bool> register(Map<String, dynamic> values,String path) async*{
    var postUri = Uri.parse(url+'/upload');
    print(postUri);
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'files', path);
    //request.headers.addAll({'Authorization': 'Bearer 554fac3adbe1b357964d6618bbb30ba9cbee6e4b764acd5929293267b7ab6b5eb1f86e261876eff9a998cd34ca18517d6fbc1d17fdddd33fd7477eeaf166dea0b5074b812da2ab18cd0868769312b6dae99cfb77627525f20f803d12a2d1847303954b8f04953931732de096ba18d4500a04fb9394ed9be745b6bf918e32e523'});
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    if(response.statusCode!=200 && response.statusCode!=201 ){
      var value=await response.stream.transform(utf8.decoder).first;
      print(value);
      yield false;
    }else{
      var value=await response.stream.transform(utf8.decoder).first;
      var res=convert.jsonDecode(value) as List<dynamic>;
      print(res[0]['id']);
      values['profilePhoto']=res[0]['id'].toString();
      values['url']=res[0]['url'];
      yield await createUser(values);
    }
    /*var value=await response.stream.toList();
    print(value);*/
    /*var res=convert.jsonDecode(value) as List<dynamic>;
    values['profilePhoto']=res[0]['url'];
    future=await createUser(values);*/

    /*response.stream.transform(utf8.decoder).listen((value) {
      print(value);

    });*/
  }

  Future<bool> createUser(Map<String, dynamic> values) async{
    var response = await http.post(Uri.parse(url + '/auth/local/register'), body: values);

    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;

      String user = convert.jsonEncode(jsonResponse['user']);
      SharedData().storeData('jwt', jsonResponse['jwt']);
      SharedData().storeData('user', user);
      return true;
    } else {
      print('Request failed with status: ${response.body}.');
      return false;
    }
  }
}
