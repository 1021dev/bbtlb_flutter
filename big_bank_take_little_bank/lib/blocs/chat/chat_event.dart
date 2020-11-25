
import 'package:big_bank_take_little_bank/models/chat_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ChatScreenEvent extends Equatable {
  const ChatScreenEvent();

  @override
  List<Object> get props => [];
}

@immutable
class ChatInitEvent extends ChatScreenEvent {
}

@immutable
class ChatScreenLoadEvent extends ChatScreenEvent {
  final List<ChatModel> chatList;

  ChatScreenLoadEvent({this.chatList,});
}

@immutable
class DeleteChatEvent extends ChatScreenEvent {
  final ChatModel chatModel;
  DeleteChatEvent({this.chatModel});
}