import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {

  LoginScreenBloc(LoginScreenState initialState) : super(initialState);
  final GoogleSignIn googleSignIn = GoogleSignIn();
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
    } else if (event is SignInWithGoogleEvent) {
      yield* signInWithGoogle();
    } else if (event is SignInWithFacebookEvent) {
      yield* signInWithFacebook();
    } else if (event is SignInWithTwitterEvent) {
      yield* signInWithTwitter();
    } else if (event is SignInWithAppleEvent) {
      yield* signInWithApple();
    } else if (event is RegisterUserProfileEvent) {
      yield* updateUserProfile(event.credential);
    }
  }

  Stream<LoginScreenState> initLogin() async* {
    SharedPrefService prefService = SharedPrefService.internal();
    String email = await prefService.getUserEmail();
    String password = await prefService.getUserEmail();

    yield state.copyWith(email: email, password: password, socialRequest: 0);
  }

  Stream<LoginScreenState> loginUser(String email, String password) async* {
    try {
      yield state.copyWith(isLoading: true);
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (result.user == null) {
        yield LoginScreenFailure(error: '$result');
      } else {
        if (!result.user.emailVerified) {
          await result.user.sendEmailVerification();
          yield LoginScreenFailure(error: 'Email verification link sent, please check your inbox');
        } else {
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

  Stream<LoginScreenState> signInWithGoogle() async* {
    try {
      yield state.copyWith(socialRequest: 3);
      final GoogleSignInAccount googleSignInAccount = await googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      if (credential == null) {
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: 'canceled');
        return;
      }
      final UserCredential authResult = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = FirebaseAuth.instance.currentUser;
        assert(user.uid == currentUser.uid);

        add(RegisterUserProfileEvent(credential: authResult));
        print('signInWithGoogle succeeded: $user');
      } else {
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: 'user doesn\'t exist');
      }
    } on FirebaseAuthException catch (e) {
      yield state.copyWith(isLoading: false);
      print(e);
      yield LoginScreenFailure(error: e.message);
    } catch (e) {
      yield state.copyWith(isLoading: false);
      yield LoginScreenFailure(error: e.message);
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  Stream<LoginScreenState> signInWithFacebook() async* {
    try {
      yield state.copyWith(isLoading: true, socialRequest: 1);
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.accessToken == null) {
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: 'canceled');
      } else {
        final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);

        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        final User user = authResult.user;

        if (user != null) {
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);

          final User currentUser = FirebaseAuth.instance.currentUser;
          assert(user.uid == currentUser.uid);

          add(RegisterUserProfileEvent(credential: authResult));

        } else {
          yield state.copyWith(isLoading: false);
          yield LoginScreenFailure(error: 'user doesn\'t exist');
        }
      }

    } catch (e) {
      yield state.copyWith(isLoading: false);
      yield LoginScreenFailure(error: e.message);
    }
  }

  Stream<LoginScreenState> signInWithTwitter() async* {
    try {
      yield state.copyWith(socialRequest: 2);
      final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: 'oH0K0ZElYB1OrL0e0ivAR1OsL',
        consumerSecret: 'gn0qfMfRTCewHVKKcvACPC1tvWdS7zzkNpBKVKvmG0RBQqGxcM',
      );

      // Trigger the sign-in flow
      final TwitterLoginResult loginResult = await twitterLogin.authorize();

      if (loginResult.status == TwitterLoginStatus.loggedIn) {
        // Get the Logged In session
        final TwitterSession twitterSession = loginResult.session;

        if (twitterSession != null) {
          // Create a credential from the access token
          final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(accessToken: twitterSession.token, secret: twitterSession.secret);

          final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
          final User user = authResult.user;

          if (user != null) {
            yield state.copyWith(isLoading: false);
            assert(!user.isAnonymous);
            assert(await user.getIdToken() != null);

            final User currentUser = FirebaseAuth.instance.currentUser;
            assert(user.uid == currentUser.uid);

            add(RegisterUserProfileEvent(credential: authResult));


          } else {
            yield state.copyWith(isLoading: false);
            yield LoginScreenFailure(error: 'user doesn\'t exist');
          }
        } else {
          yield state.copyWith(isLoading: false);
          yield LoginScreenFailure(error: 'user doesn\'t exist');
        }
      } else if (loginResult.status == TwitterLoginStatus.cancelledByUser) {
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: 'canceled');
      } else {
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: loginResult.errorMessage);
      }
    } catch (e) {
      yield state.copyWith(isLoading: false);
      yield LoginScreenFailure(error: e.message);
    }
  }

  Stream<LoginScreenState> signInWithApple() async* {
    try {
      yield state.copyWith(socialRequest: 4);
      final result = await AppleSignIn.performRequests(
          [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);
      // 2. check the result
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
            String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
          add(RegisterUserProfileEvent(credential: authResult));
          return;
        case AuthorizationStatus.error:
          print(result.error.toString());
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
      }

    } catch (e) {
      yield state.copyWith(isLoading: false);
      yield LoginScreenFailure(error: e.message);
    }
  }

  Stream<LoginScreenState> updateUserProfile(UserCredential result) async* {
    yield state.copyWith(isLoading: true);
    UserModel u = await service.getUserWithId(result.user.uid);
    if (u == null) {
      UserModel userModel = UserModel();
      userModel.id = result.user.uid;
      userModel.name = result.user.displayName;
      userModel.email = result.user.email;
      userModel.image = result.user.photoURL ?? '';
      await service.createUser(userModel);
      Global.instance.userId = result.user.uid;

      if (!result.user.emailVerified) {
        await result.user.sendEmailVerification();
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: 'Email verification link sent, please check your inbox');
      } else {
        yield state.copyWith(isLoading: false);
        yield LoginScreenSuccess();
      }
    } else {
      if (!result.user.emailVerified) {
        await result.user.sendEmailVerification();
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: 'Email verification link sent, please check your inbox');
      } else {
        yield state.copyWith(isLoading: false);
        yield LoginScreenSuccess();
      }
    }

  }

  Stream<LoginScreenState> forgetPassword(String email) async* {
    yield state.copyWith(isLoading: true);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    yield state.copyWith(isLoading: false);
    yield LoginScreenPasswordResetSent();
  }
}