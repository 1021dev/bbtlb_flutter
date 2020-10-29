
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

@immutable
class MessageInitEvent extends MessageEvent {
}

@immutable
class MessageLoadEvent extends MessageEvent {
  final List<MessageModel> messageList;

  MessageLoadEvent({this.messageList,});
}

@immutable
class DeleteMessageEvent extends MessageEvent {
  final MessageModel messageModel;
  DeleteMessageEvent({this.messageModel});
}

class ReadMessageEvent extends MessageEvent {
  final MessageModel messageModel;
  ReadMessageEvent({this.messageModel});
}

