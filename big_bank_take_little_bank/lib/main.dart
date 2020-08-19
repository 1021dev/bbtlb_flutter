import 'package:big_bank_take_little_bank/blocs/AppBlocDelegate.dart';
import 'package:event_bus/event_bus.dart';
import 'package:big_bank_take_little_bank/provider/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_app.dart';

EventBus eventBus = EventBus();

void main() async {
  Bloc.observer = AppBlocObserver();
  global.Global(environment: global.Env.dev());
  await myMain();
}
