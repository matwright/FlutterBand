import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final DateTime time;
  final String message;
  final String lang;
  final int channel;
  final String uid;
  static const DEFAULT_CHANNEL=10;
  Message({this.time, this.message,this.lang,this.channel,this.uid});

  static Message fromEntity(Map message) {

    DateTime time= message['time']!=null?DateTime.now():DateTime.parse(message['time']);
    return Message(
      uid: message['uid'],
        time: time,
        lang: message['lang'],
        message: message['message'],
        channel: message['channel']
    );
  }

  Map<String, Object>  toEntity() {
    return {
      'time':time !=null?time.millisecondsSinceEpoch:new DateTime.now().millisecondsSinceEpoch,
      'message':message,
      'lang':lang,
      'channel':channel??DEFAULT_CHANNEL
    };
  }
}
