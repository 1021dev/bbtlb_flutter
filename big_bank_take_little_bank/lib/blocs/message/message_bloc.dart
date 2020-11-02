import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/blocs/message/message.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/chat_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {

  MessageBloc(MessageState initialState) : super(initialState);

  StreamSubscription _messageSubscription;
  StreamSubscription _forumMessageSubscription;
  StreamSubscription _forumUsersSubscription;
  StreamSubscription _forumReplayMessageSubscription;

  FirestoreService service = FirestoreService();

  MessageState get initialState {
    return MessageState(isLoading: true);
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event,) async* {
    if (event is MessageInitEvent) {
      yield* init(event.userModel, event.chatModel);
    } else if (event is ForumInitEvent) {
      yield* forumInit();
    } else if (event is MessageLoadEvent) {
      // List<MessageModel> unreadMessages = event.messageList.where((element) => element.isRead == false).toList();
      yield state.copyWith(messageList: event.messageList);
    } else if (event is ReadMessageEvent) {
      yield* readMessage(event.messageModel);
    } else if (event is DeleteMessageEvent) {
      yield* deleteMessage(event.messageModel);
    } else if (event is SendMessageEvent) {
      yield* sendMessage(event.messageModel);
    } else if (event is ForumUsersLoadEvent) {
      yield state.copyWith(forumUsers: event.users);
    } else if (event is SendForumMessageEvent) {
      yield* sendForumMessage(event.messageModel);
    } else if (event is ForumReplyInitEvent) {
      yield* replayMessages(event.model);
    } else if (event is MessageRepliesLoadEvent) {
      yield state.copyWith(replyMessageList: event.messageList);
    }
  }

  Stream<MessageState> init(UserModel userModel, ChatModel chatModel) async* {
    if (userModel == null) {
      String userId = chatModel.members[0] == Global.instance.userId ? chatModel.members[1]: chatModel.members[0];
      UserModel userModel = await service.getUserWithId(userId);
      yield state.copyWith(userModel: userModel);
    } else {
      yield state.copyWith(userModel: userModel);
    }
    await _messageSubscription?.cancel();
    _messageSubscription = service.streamChat(state.userModel.id).listen((event) {
      List<MessageModel> messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      add(MessageLoadEvent(messageList: messages));
    });
  }

  Stream<MessageState> forumInit() async* {
    await _forumMessageSubscription?.cancel();
    _forumMessageSubscription = service.streamForum().listen((event) {
      List<MessageModel> messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      messages = messages.reversed.toList();
      add(MessageLoadEvent(messageList: messages));
    });
    await _forumUsersSubscription?.cancel();
    _forumUsersSubscription = service.streamForumUsers().listen((event) {
      List<String> users = [];
      if (event != null) {
        if (event.data() != null) {
          dynamic list = event.data()['users'];
          if (list is List) {
            list.forEach((element) {
              String uid = element as String ?? '';
              if (uid != Global.instance.userId) {
                users.add(uid);
              }
            });
          }
        }
      }
      add(ForumUsersLoadEvent(users: users));
    });
  }

  Stream<MessageState> replayMessages(MessageModel model) async* {
    await _forumReplayMessageSubscription?.cancel();
    _forumReplayMessageSubscription = service.streamForumReply(model.id).listen((event) {
      print(event.docs);
      List<MessageModel> messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      add(MessageRepliesLoadEvent(messageList : messages));
    });
  }

  Stream<MessageState> readMessage(MessageModel model) async* {
    yield state.copyWith(isLoading: true);

    // await service.readMessage(Global.instance.userId, model.id);

    yield state.copyWith(isLoading: false);
  }

  Stream<MessageState> deleteMessage(MessageModel model) async* {
    yield state.copyWith(isLoading: true);

    // await service.deleteMessage(Global.instance.userId, model.id);

    yield state.copyWith(isLoading: false);
  }

  Stream<MessageState> sendMessage(MessageModel model) async* {
    yield state.copyWith(isLoading: true);

    await service.sendMessage(
      roomId: service.generateChatId(Global.instance.userId, state.userModel.id,),
      userId: state.userModel.id,
      model: model,
    );

    yield state.copyWith(isLoading: false);
  }

  Stream<MessageState> sendForumMessage(MessageModel model) async* {
    yield state.copyWith(isLoading: true);

    await service.sendForumMessage(
      model: model,
    );
    List<String> users = [];
    if (!state.forumUsers.contains(model.user.userId)) {
      state.forumUsers.forEach((element) {
        users.add(element);
      });
      users.add(model.user.userId);
      await service.updateForum(users: users);
    }
    if (model.replyId != null) {
      print(model.replyId);
      await service.updateMessage(id: model.replyId);
    }
    yield state.copyWith(isLoading: false);
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _forumMessageSubscription?.cancel();
    _forumUsersSubscription?.cancel();
    _forumReplayMessageSubscription.cancel();
    return super.close();
  }
}
