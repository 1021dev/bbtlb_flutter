import 'package:event_bus/event_bus.dart';
import 'package:big_bank_take_little_bank/provider/global.dart' as global;

import 'my_app.dart';

EventBus eventBus = EventBus();

void main() async {
  //init dev Global
  global.Global(environment: global.Env.dev());
  await myMain();
}
