import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {

  LoginScreenBloc(LoginScreenState initialState) : super(initialState);

  LoginScreenState get initialState {
    return LoginScreenState(isLoading: false);
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event,) async* {
    if (event is LoginScreenInitEvent) {
      yield* initLogin();
    } else if (event is LoginUserEvent) {
      yield* loginUser(event.email, event.password);
    } else if (event is ForgetPasswordEvent) {
      yield* forgetPassword(event.email);
    }
  }

  Stream<LoginScreenState> initLogin() async* {
    SharedPrefService prefService = SharedPrefService.internal();
    String email = await prefService.getUserEmail();
    String password = await prefService.getUserEmail();

    yield state.copyWith(email: email, password: password);
  }

  Stream<LoginScreenState> loginUser(String email, String password) async* {
    try {
      yield state.copyWith(isLoading: true);
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user == null) {
        yield LoginScreenFailure(error: '$result');
      } else {
        if (!result.user.emailVerified) {
          await result.user.sendEmailVerification();
          yield LoginScreenFailure(error: 'Email verification link sent, please check your inbox');
        } else {
          Global.instance.userRef = firestore.collection('users').doc(result.user.uid);
          Global.instance.userId = result.user.uid;
          yield state.copyWith(isLoading: false);
          SharedPrefService prefService = SharedPrefService.internal();
          await prefService.saveUserEmail(email);
          await prefService.saveUserPassword(password);
          yield LoginScreenSuccess();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        yield LoginScreenFailure(error: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        yield LoginScreenFailure(error: 'Wrong password provided for that user');
      }
    } catch (e) {
      print(e.toString());
      yield LoginScreenFailure(error: e.toString());
    }
  }

  Stream<LoginScreenState> forgetPassword(String email) async* {
    yield state.copyWith(isLoading: true);
    await auth.sendPasswordResetEmail(email: email);
    yield state.copyWith(isLoading: false);
    yield LoginScreenPasswordResetSent();
  }
}