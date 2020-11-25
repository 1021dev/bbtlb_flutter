
import 'package:big_bank_take_little_bank/models/chat_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
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
  final UserModel userModel;
  final ChatModel chatModel;
  MessageInitEvent({this.userModel, this.chatModel});
}

@immutable
class ForumInitEvent extends MessageEvent {}

@immutable
class ForumReplyInitEvent extends MessageEvent {
  final MessageModel model;

  ForumReplyInitEvent({this.model});
}

@immutable
class SendMessageEvent extends MessageEvent {
  final MessageModel messageModel;
  SendMessageEvent({this.messageModel});
}

@immutable
class SendForumMessageEvent extends MessageEvent {
  final MessageModel messageModel;
  SendForumMessageEvent({this.messageModel});
}

@immutable
class MessageLoadEvent extends MessageEvent {
  final List<MessageModel> messageList;

  MessageLoadEvent({this.messageList,});
}

@immutable
class MessageRepliesLoadEvent extends MessageEvent {
  final List<MessageModel> messageList;

  MessageRepliesLoadEvent({this.messageList,});
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

class ForumUsersLoadEvent extends MessageEvent {
  final List<String> users;
  ForumUsersLoadEvent({this.users});
}
