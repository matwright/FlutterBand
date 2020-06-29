import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Uid{
String _uid;

Future<String> value() async {
  SharedPreferences prefs= await SharedPreferences.getInstance();
  if(_uid==null){
    if(prefs.containsKey('uid')){
      _uid=prefs.getString('uid');
    }else{
      _uid = Uuid().v1();
      await prefs.setString('uid',_uid);
    }
  }
  return _uid;
}
}