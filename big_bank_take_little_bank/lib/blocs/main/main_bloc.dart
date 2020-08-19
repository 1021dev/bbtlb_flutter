import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/utils/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  MainScreenBloc(MainScreenState initialState) : super(initialState);

  MainScreenState get initialState {
    return MainScreenState(isLoading: false);
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event,) async* {
    if (event is MainScreenInitEvent) {
      yield* init();
    }
  }

  Stream<MainScreenState> init() async* {
    SharedPrefService prefService = SharedPrefService.internal();

  }

}