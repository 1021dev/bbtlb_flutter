import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/blocs/message/message.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {

  MessageBloc(MessageState initialState) : super(initialState);

  StreamSubscription _messageSubscription;

  FirestoreService service = FirestoreService();

  MessageState get initialState {
    return MessageState(isLoading: true);
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event,) async* {
    if (event is MessageInitEvent) {
      yield* init();
    } else if (event is MessageLoadEvent) {
      List<MessageModel> unreadMessages = event.messageList.where((element) => element.isRead == false).toList();
      yield state.copyWith(messageList: event.messageList, unreadMessages: unreadMessages);
    } else if (event is ReadMessageEvent) {
      yield* readMessage(event.messageModel);
    } else if (event is DeleteMessageEvent) {
      yield* deleteMessage(event.messageModel);
    }
  }

  Stream<MessageState> init() async* {
    User user = FirebaseAuth.instance.currentUser;
    await _messageSubscription?.cancel();
    _messageSubscription = service.streamNotifications(user.uid).listen((event) {
        List<MessageModel> messages = [];
        event.docs.forEach((element) {
          messages.add(MessageModel.fromJson(element.data()));
        });
        add(MessageLoadEvent(messageList: messages));
      // } else {
      //   add(NotificationsLoadedEvent(notificationsList: []));
      // }
    });
  }

  Stream<MessageState> readMessage(MessageModel model) async* {
    yield state.copyWith(isLoading: true);

    await service.readNotification(Global.instance.userId, model.id);

    yield state.copyWith(isLoading: false);
  }

  Stream<MessageState> deleteMessage(MessageModel model) async* {
    yield state.copyWith(isLoading: true);

    await service.deleteNotification(Global.instance.userId, model.id);

    yield state.copyWith(isLoading: false);
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
