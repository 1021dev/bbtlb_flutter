import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/blocs/chat/chat.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {

  ChatScreenBloc(ChatScreenState initialState) : super(initialState);

  StreamSubscription _messageSubscription;

  FirestoreService service = FirestoreService();

  ChatScreenState get initialState {
    return ChatScreenState(isLoading: true);
  }

  @override
  Stream<ChatScreenState> mapEventToState(ChatScreenEvent event,) async* {
    if (event is ChatInitEvent) {
      yield* init();
    } else if (event is ChatScreenLoadEvent) {
      yield state.copyWith(chatList: event.chatList);
    } else if (event is DeleteChatEvent) {
      yield* deleteMessage(event.chatModel);
    }
  }

  Stream<ChatScreenState> init() async* {
    User user = FirebaseAuth.instance.currentUser;
    await _messageSubscription?.cancel();
    _messageSubscription = service.streamChatList(user.uid).listen((event) {
      List<ChatModel> chats = [];
      event.docs.forEach((element) {
        ChatModel model = ChatModel.fromJson(element.data());
        chats.add(model);
      });
      add(ChatScreenLoadEvent(chatList: chats));
      // } else {
      //   add(NotificationsLoadedEvent(notificationsList: []));
      // }
    });
  }

  Stream<ChatScreenState> deleteMessage(ChatModel model) async* {
    yield state.copyWith(isLoading: true);

    // await service.deleteChat(Global.instance.userId, model.id);

    yield state.copyWith(isLoading: false);
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
