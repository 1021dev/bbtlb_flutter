import 'package:big_bank_take_little_bank/models/chat_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MessageState extends Equatable {
  final bool isLoading;
  final List<MessageModel> messageList;
  final List<MessageModel> unreadMessages;
  final ChatModel chatModel;
  final UserModel userModel;
  final List<String> forumUsers;

  MessageState({
    this.isLoading = false,
    this.messageList = const [],
    this.unreadMessages = const [],
    this.chatModel,
    this.userModel,
    this.forumUsers = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    messageList,
    unreadMessages,
    chatModel,
    userModel,
    forumUsers,
  ];

  MessageState copyWith({
    bool isLoading,
    List<MessageModel> messageList,
    List<MessageModel> unreadMessages,
    ChatModel chatModel,
    UserModel userModel,
    List<String> forumUsers,
  }) {
    return MessageState(
      isLoading: isLoading ?? this.isLoading,
      messageList: messageList ?? this.messageList,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      chatModel: chatModel ?? this.chatModel,
      userModel: userModel ?? this.userModel,
      forumUsers: forumUsers ?? this.forumUsers,
    );
  }
}

class MessageFailure extends MessageState {
  final String error;

  MessageFailure({@required this.error}) : super();

  @override
  String toString() => 'MessageFailure { error: $error }';
}

class MessageSuccess extends MessageState {}
