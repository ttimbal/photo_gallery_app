import 'package:shared_preferences/shared_preferences.dart';

class SharedData{
  storeData(String name,dynamic data) async{
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, data);
  }

  Future<String> getData(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data= prefs.getString(name);
    return data ?? '';
  }

  deleteData(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(name);
  }


}