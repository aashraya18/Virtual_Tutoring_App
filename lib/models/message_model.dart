import 'package:flutter/material.dart';

class Message {
  final String message;
  final String sender;
  final String time;

  const Message({
    @required this.message,
    @required this.sender,
    @required this.time,
  });
}
