import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:flutterband/blocs/home/bloc.dart';
import 'package:flutterband/uid.dart';
import './bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterband/models/message.dart';

class EarwigBloc extends Bloc<EarwigEvent, EarwigState> {
  StreamSubscription listener;

  Uid uid;
  EarwigBloc(this.uid);
  @override
  EarwigState get initialState => InitialEarwigState();
  int startAtTimestamp = DateTime.now().millisecondsSinceEpoch;
  @override
  Stream<EarwigState> mapEventToState(
    EarwigEvent event,
  ) async* {
    if (event is StartListeningEvent) {

      yield* _mapListeningEventToState(event);
    } else if (event is PushMessageEvent) {
      print("***PushMessageEvent***");
      yield MessageReceivedEarwigState(event.message);
    } else if (event is StopListeningEvent) {
      print("***StopListeningEvent***");
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/turn_on.mp3"),
        showNotification: true,
      );
      listener.cancel();
      yield EardeafState();
    }
  }

  Stream<EarwigState> _mapListeningEventToState(
      StartListeningEvent event) async* {
    print("***CONNECTING TO DB***");
    Firestore _firestore = Firestore.instance;
    String uidValue=await uid.value();
    print("***CHANNEL   "+event.channel.toString()+"   CHANNEL***");
    listener = Firestore.instance
        .collection('message')
        .where('time', isGreaterThan: startAtTimestamp)
        .where('channel', isEqualTo: event.channel)
        .snapshots()
        .listen((data) {
      print("***OVER LISTENER " + startAtTimestamp.toString() + "***");
      data.documents
          .where((element) => element['time'] > startAtTimestamp)
          .forEach((element) {

        print("***OVER " + startAtTimestamp.toString() + "***");
        print(element.data);

        if(element.data['uid'] != uidValue){
          this.add(PushMessageEvent(Message.fromEntity(element.data)));
        }

        print("***OVER***");
      });
      startAtTimestamp = DateTime.now().millisecondsSinceEpoch;
    });
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/turn_on.mp3"),
      showNotification: true,
    );
    yield EarwiggingState();
    //print(message.data);
    //Message newMessage = Message.fromEntity(message.data);
    //yield MessageReceivedEarwigState(newMessage);

    //if switched off
    //listener.cancel();
  }
}
