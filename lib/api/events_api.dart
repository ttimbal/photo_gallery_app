import 'dart:math';

import 'package:photo_gallery_app/api/shared_data.dart';
import 'package:photo_gallery_app/constants/Constant.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EventsApi{
  String url = Constant.url;
  Future<List<Map<String,dynamic>>> yourEvents() async{
    var jwt=await SharedData().getData('jwt');
    var user=convert.jsonDecode(await SharedData().getData('user'));
    List<Map<String,dynamic>> dataEvent=[];
    var response =
    await http.get(Uri.parse(url + '/events?populate=*&sort=createdAt:desc&filters[user][id]=${user['id'].toString()}')
        ,headers: {
      'Authorization': 'Bearer ${jwt}'
    });

    if (response.statusCode == 200) {

      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      for(var i=0;i<jsonResponse['data'].length;i++){
        Map<String,dynamic> data={
          'name':jsonResponse['data'][i]['attributes']['name'],
          'date':jsonResponse['data'][i]['attributes']['date'],
          'description':jsonResponse['data'][i]['attributes']['description'],
          'url':jsonResponse['data'][i]['attributes']['cover']['data'][0]['attributes']['url'],
          'status':jsonResponse['data'][i]['attributes']['status']['data']['attributes']['name'],
        };
        dataEvent.add(data);
      }
      print(dataEvent);
      return dataEvent;
    } else {
      print('Request failed with status: ${response.body}.');
      return dataEvent;
    }
  }
}