import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreenBloc extends Bloc<AuthScreenEvent, AuthScreenState> {

  AuthScreenBloc(AuthScreenState initialState) : super(initialState);
  FirestoreService service = FirestoreService();
  AuthScreenState get initialState {
    return AuthScreenState(isLoading: false);
  }

  @override
  Stream<AuthScreenState> mapEventToState(AuthScreenEvent event,) async* {
    if (event is AuthScreenInitEvent) {

    } else if (event is RegisterUserEvent) {
      yield* registerUser(event);
    } else if (event is AddAuthProfileImageEvent) {
      yield state.copyWith(file: event.file);
    }
  }

  Stream<AuthScreenState> registerUser(RegisterUserEvent event) async* {
    try {
      yield state.copyWith(isLoading: true);
      AuthResult result = await auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      UserModel userModel = UserModel();
      userModel.id = result.user.uid;
      userModel.name = event.name;
      userModel.email = event.email;
      userModel.profession = event.profession;
      userModel.location = event.location;
      userModel.age = event.age;
      await service.createUser(userModel);
      Global.instance.userRef = firestore.collection('users').document(result.user.uid);
      Global.instance.uid = result.user.uid;
      if (state.file != null) {
        StorageReference ref = firebaseStorage.ref().child('users').child(result.user.uid);
        StorageUploadTask task = ref.putFile(state.file);
        task.events.listen((event) async* {
          double progress = event.snapshot.bytesTransferred.toDouble();
          print(progress);
        }).onError((error) async* {
          print(error.toString());
          if (!result.user.isEmailVerified) {
            await result.user.sendEmailVerification();
            yield state.copyWith(isLoading: false);
            yield AuthEmailVerification();
          }
        });
        await task.onComplete.then((value) async* {
          value.ref.getDownloadURL().then((url){
            Global.instance.userRef.updateData({
              'image': url.toString(),
            });
          }).then((snap) async* {
            if (!result.user.isEmailVerified) {
              await result.user.sendEmailVerification();
              yield state.copyWith(isLoading: false);
              yield AuthEmailVerification();
            }
          });
        });
      } else {
        if (!result.user.isEmailVerified) {
          await result.user.sendEmailVerification();
          yield state.copyWith(isLoading: false);
          yield AuthEmailVerification();
        } else {
          yield state.copyWith(isLoading: false);
          yield AuthScreenSuccess();
        }
      }
    } on AuthException catch (e) {
      yield state.copyWith(isLoading: false);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        yield AuthScreenFailure(error: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        yield AuthScreenFailure(
            error: 'The account already exists for that email.');
      } else {
        yield AuthScreenFailure(
            error: 'The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
      yield state.copyWith(isLoading: false);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        yield AuthScreenFailure(error: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        yield AuthScreenFailure(error: 'The account already exists for that email.');
      } else {
        yield AuthScreenFailure(error: 'The account already exists for that email.');
      }
    }

  }

}