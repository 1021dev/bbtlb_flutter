import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatScreenState extends Equatable {
  final bool isLoading;
  final List<MessageModel> messageList;
  final List<MessageModel> unreadMessages;

  ChatScreenState({
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

  ChatScreenState copyWith({
    bool isLoading,
    List<MessageModel> messageList,
    List<MessageModel> unreadMessages,
  }) {
    return ChatScreenState(
      isLoading: isLoading ?? this.isLoading,
      messageList: messageList ?? this.messageList,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }
}

class ChatScreenFailure extends ChatScreenState {
  final String error;

  ChatScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'ChatScreenFailure { error: $error }';
}

class ChatScreenSuccess extends ChatScreenState {}
