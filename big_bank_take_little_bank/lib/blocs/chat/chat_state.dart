import 'package:big_bank_take_little_bank/models/chat_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatScreenState extends Equatable {
  final bool isLoading;
  final List<ChatModel> chatList;

  ChatScreenState({
    this.isLoading = false,
    this.chatList = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    chatList,
  ];

  ChatScreenState copyWith({
    bool isLoading,
    List<ChatModel> chatList,
  }) {
    return ChatScreenState(
      isLoading: isLoading ?? this.isLoading,
      chatList: chatList ?? this.chatList,
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
