import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MessageState extends Equatable {
  final bool isLoading;
  final List<MessageModel> messageList;
  final List<MessageModel> unreadMessages;

  MessageState({
    this.isLoading = false,
    this.messageList = const [],
    this.unreadMessages = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    messageList,
    unreadMessages,
  ];

  MessageState copyWith({
    bool isLoading,
    List<MessageModel> messageList,
    List<MessageModel> unreadMessages,
  }) {
    return MessageState(
      isLoading: isLoading ?? this.isLoading,
      messageList: messageList ?? this.messageList,
      unreadMessages: unreadMessages ?? this.unreadMessages,
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
