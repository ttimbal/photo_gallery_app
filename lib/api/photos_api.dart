import 'dart:math';

import 'package:photo_gallery_app/api/shared_data.dart';
import 'package:photo_gallery_app/constants/Constant.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PhotosApi{
  String url = Constant.url;
  Future<List<String>> yourPhotos() async{
    var jwt=await SharedData().getData('jwt');
    var user=convert.jsonDecode(await SharedData().getData('user'));
    List<String> urls=[];
    var response =
    await http.get(Uri.parse(url + '/your-photos?populate[photo][populate][image]=*&filters[user][id]=${user['id'].toString()}&sort=createdAt:desc')
        ,headers: {
      'Authorization': 'Bearer ${jwt}'
    });

    if (response.statusCode == 200) {

      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      for(var i=0;i<jsonResponse['data'].length;i++){
        var url=jsonResponse['data'][i]['attributes']['photo']['data']['attributes']['image']['data']['attributes']['url'];
        urls.add(url);
      }
      return urls;
    } else {
      print('Request failed with status: ${response.body}.');
      return urls;
    }
  }
}