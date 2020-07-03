import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterband/blocs/home/bloc.dart';

class ChannelDisplayWidget extends StatelessWidget {
  final int currentChannel;

  ChannelDisplayWidget({@required this.currentChannel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      var channel = state.channel ?? currentChannel;
      return Expanded(
          child: Container(
              alignment: Alignment.center,
              child: Text(channel.toString(),
                  style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 200,
                      // fontWeight: FontWeight.bold,
                      fontFamily: "Digital"))));
    });
  }
}
