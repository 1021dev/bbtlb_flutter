import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreenBloc extends Bloc<NotificationScreenEvent, NotificationScreenState> {

  NotificationScreenBloc(NotificationScreenState initialState) : super(initialState);

  StreamSubscription _notificationsSubscription;

  FirestoreService service = FirestoreService();

  NotificationScreenState get initialState {
    return NotificationScreenState(isLoading: true);
  }

  @override
  Stream<NotificationScreenState> mapEventToState(NotificationScreenEvent event,) async* {
    if (event is NotificationInitEvent) {
      yield* init();
    } else if (event is NotificationsLoadedEvent) {
      List<NotificationModel> unreadNotifications = event.notificationsList.where((element) => element.isRead == false).toList();
      yield state.copyWith(notifications: event.notificationsList, unreadNotifications: unreadNotifications);
    } else if (event is ReadNotificationEvent) {
      yield* readNotification(event.notificationModel);
    } else if (event is DeleteNotificationEvent) {
      yield* deleteNotification(event.notificationModel);
    }
  }

  Stream<NotificationScreenState> init() async* {
    User user = FirebaseAuth.instance.currentUser;
    await _notificationsSubscription?.cancel();
    _notificationsSubscription = service.streamNotifications(user.uid).listen((event) {
        List<NotificationModel> notifications = [];
        event.docs.forEach((element) {
          notifications.add(NotificationModel.fromJson(element.data()));
        });
        add(NotificationsLoadedEvent(notificationsList: notifications));
      // } else {
      //   add(NotificationsLoadedEvent(notificationsList: []));
      // }
    });
  }

  Stream<NotificationScreenState> readNotification(NotificationModel model) async* {
    yield state.copyWith(isLoading: true);

    await service.readNotification(Global.instance.userId, model.id);

    yield state.copyWith(isLoading: false);
  }

  Stream<NotificationScreenState> deleteNotification(NotificationModel model) async* {
    yield state.copyWith(isLoading: true);

    await service.deleteNotification(Global.instance.userId, model.id);

    yield state.copyWith(isLoading: false);
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
