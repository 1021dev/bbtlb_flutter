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
      yield* updateUserProfile(event.credential, event.id);
    } else if (event is LinkAccountEvent) {
      yield* linkAccount(event);
    }
  }

  Stream<LoginScreenState> initLogin() async* {
    SharedPrefService prefService = SharedPrefService.internal();
    String email = await prefService.getUserEmail();
    String password = await prefService.getUserEmail();
    await signOut();
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
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          yield LoginScreenFailure(error: 'Email already used. Go to login page');
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          yield LoginScreenFailure(error: 'Wrong email/password combination');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No user found with this email');
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          yield LoginScreenFailure(error: 'User disabled');
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Too many requests to log into this account');
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Server error, please try again later');
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          yield LoginScreenFailure(error: 'Email address is invalid');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No account found with this email');
          break;
        default:
          yield LoginScreenFailure(error: 'Login failed. Please try again.');
          break;
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
        print('signInWithGoogle succeeded: $user');
        add(RegisterUserProfileEvent(credential: authResult, id: googleSignInAuthentication.idToken));
      } else {
        yield state.copyWith(isLoading: false);
        yield LoginScreenFailure(error: 'user doesn\'t exist');
      }
    } on FirebaseAuthException catch (e) {
      yield state.copyWith(isLoading: false);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          String existingEmail = e.email;
          AuthCredential pendingCred = e.credential;
          List<String> providers = await FirebaseAuth.instance.fetchSignInMethodsForEmail(existingEmail);
          if (providers.contains(EmailAuthProvider.PROVIDER_ID)) {
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: GoogleAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: EmailAuthProvider.PROVIDER_ID
            );
          } else if (providers.contains(FacebookAuthProvider.PROVIDER_ID)) {
            FacebookAuthProvider provider = new FacebookAuthProvider();
            provider.setCustomParameters({'login_hint': existingEmail});
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: GoogleAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: provider.providerId
            );
          } else if (providers.contains(TwitterAuthProvider.PROVIDER_ID)) {
            TwitterAuthProvider provider = new TwitterAuthProvider();
            provider.setCustomParameters({'login_hint': existingEmail});
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: GoogleAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: provider.providerId
            );
          } else {
            yield LoginScreenFailure(error: 'Email already used. User other email');
          }
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          yield LoginScreenFailure(error: 'Wrong email/password combination');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No user found with this email');
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          yield LoginScreenFailure(error: 'User disabled');
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Too many requests to log into this account');
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Server error, please try again later');
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          yield LoginScreenFailure(error: 'Email address is invalid');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No account found with this email');
          break;
        default:
          yield LoginScreenFailure(error: 'Login failed. Please try again.');
          break;
      }
    } catch (e) {
      yield state.copyWith(isLoading: false);
      yield LoginScreenFailure(error: e.message);
    }
  }

  Future<void> signOut() async {
    bool isLoggedInGoogle = await googleSignIn.isSignedIn();
    if (isLoggedInGoogle) {
      await googleSignIn.signOut();
    }
    AccessToken token = await FacebookAuth.instance.isLogged;
    if (token != null) {
      FacebookAuth.instance.logOut();
    }
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: 'oH0K0ZElYB1OrL0e0ivAR1OsL',
      consumerSecret: 'gn0qfMfRTCewHVKKcvACPC1tvWdS7zzkNpBKVKvmG0RBQqGxcM',
    );
    twitterLogin.logOut();
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

          add(RegisterUserProfileEvent(credential: authResult, id: facebookAuthCredential.idToken));

        } else {
          yield state.copyWith(isLoading: false);
          yield LoginScreenFailure(error: 'user doesn\'t exist');
        }
      }
    } on FirebaseAuthException catch (e) {
      yield state.copyWith(isLoading: false);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          String existingEmail = e.email;
          AuthCredential pendingCred = e.credential;
          List<String> providers = await FirebaseAuth.instance.fetchSignInMethodsForEmail(existingEmail);
          if (providers.contains(EmailAuthProvider.PROVIDER_ID)) {
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: FacebookAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: EmailAuthProvider.PROVIDER_ID
            );
          } else if (providers.contains(GoogleAuthProvider.PROVIDER_ID)) {
            GoogleAuthProvider provider = new GoogleAuthProvider();
            provider.setCustomParameters({'login_hint': existingEmail});
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: FacebookAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: provider.providerId
            );
          } else if (providers.contains(TwitterAuthProvider.PROVIDER_ID)) {
            TwitterAuthProvider provider = new TwitterAuthProvider();
            provider.setCustomParameters({'login_hint': existingEmail});
            yield EmailAlreadyExistingState(
              error: 'Email already used. Are you want to link to existing account',
              provider: FacebookAuthProvider.PROVIDER_ID,
              credential: pendingCred,
              email: existingEmail,
              linkProvider: provider.providerId
            );
          } else {
            yield LoginScreenFailure(error: 'Email already used. User other email');
          }
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          yield LoginScreenFailure(error: 'Wrong email/password combination');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No user found with this email');
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          yield LoginScreenFailure(error: 'User disabled');
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Too many requests to log into this account');
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Server error, please try again later');
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          yield LoginScreenFailure(error: 'Email address is invalid');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No account found with this email');
          break;
        default:
          yield LoginScreenFailure(error: 'Login failed. Please try again.');
          break;
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

            add(RegisterUserProfileEvent(credential: authResult, id: loginResult.session.userId));

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
    } on FirebaseAuthException catch (e) {
      yield state.copyWith(isLoading: false);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          String existingEmail = e.email;
          AuthCredential pendingCred = e.credential;
          List<String> providers = await FirebaseAuth.instance.fetchSignInMethodsForEmail(existingEmail);
          if (providers.contains(EmailAuthProvider.PROVIDER_ID)) {
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: TwitterAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: EmailAuthProvider.PROVIDER_ID
            );
          } else if (providers.contains(FacebookAuthProvider.PROVIDER_ID)) {
            FacebookAuthProvider provider = new FacebookAuthProvider();
            provider.setCustomParameters({'login_hint': existingEmail});
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: TwitterAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: provider.providerId
            );
          } else if (providers.contains(GoogleAuthProvider.PROVIDER_ID)) {
            GoogleAuthProvider provider = new GoogleAuthProvider();
            provider.setCustomParameters({'login_hint': existingEmail});
            yield EmailAlreadyExistingState(
                error: 'Email already used. Are you want to link to existing account',
                provider: TwitterAuthProvider.PROVIDER_ID,
                credential: pendingCred,
                email: existingEmail,
                linkProvider: provider.providerId
            );
          } else {
            yield LoginScreenFailure(error: 'Email already used. User other email');
          }
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          yield LoginScreenFailure(error: 'Wrong email/password combination');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No user found with this email');
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          yield LoginScreenFailure(error: 'User disabled');
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Too many requests to log into this account');
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Server error, please try again later');
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          yield LoginScreenFailure(error: 'Email address is invalid');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No account found with this email');
          break;
        default:
          yield LoginScreenFailure(error: 'Login failed. Please try again.');
          break;
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
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
            String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
          add(RegisterUserProfileEvent(credential: authResult, id: String.fromCharCodes(appleIdCredential.identityToken)));
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
    } on FirebaseAuthException catch (e) {
      yield state.copyWith(isLoading: false);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          yield LoginScreenFailure(error: 'Email already used. Go to login page');
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          yield LoginScreenFailure(error: 'Wrong email/password combination');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No user found with this email');
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          yield LoginScreenFailure(error: 'User disabled');
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Too many requests to log into this account');
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          yield LoginScreenFailure(error: 'Server error, please try again later');
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          yield LoginScreenFailure(error: 'Email address is invalid');
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          yield LoginScreenFailure(error: 'No account found with this email');
          break;
        default:
          yield LoginScreenFailure(error: 'Login failed. Please try again.');
          break;
      }
    } catch (e) {
      yield state.copyWith(isLoading: false);
      yield LoginScreenFailure(error: e.message);
    }
  }

  Stream<LoginScreenState> updateUserProfile(UserCredential result, String id) async* {
    yield state.copyWith(isLoading: true);
    UserInfo user = FirebaseAuth.instance.currentUser.providerData.first;
    UserModel u = await service.getUserWithId(FirebaseAuth.instance.currentUser.uid);
    if (u == null) {

        yield state.copyWith(isLoading: false);
        UserModel userModel = UserModel();
        userModel.id = FirebaseAuth.instance.currentUser.uid;
        userModel.name = user.displayName;
        userModel.email = user.email;
        userModel.image = user.photoURL ?? '';
        userModel.provider = user.providerId;
        if (user.providerId.contains('facebook')) {
          userModel.facebookId = id;
        } else if (user.providerId.contains('google')) {
          userModel.googleId = id;
        } else if (user.providerId.contains('twitter')) {
          userModel.twitterId = id;
        } else if (user.providerId.contains('apple')) {
          userModel.appleId = id;
        }
        await service.createUser(userModel);
        Global.instance.userId = FirebaseAuth.instance.currentUser.uid;
        yield LoginScreenSuccess();
    } else {
        Global.instance.userId = FirebaseAuth.instance.currentUser.uid;
        yield state.copyWith(isLoading: false);
        yield LoginScreenSuccess();
    }

  }

  Stream<LoginScreenState> forgetPassword(String email) async* {
    yield state.copyWith(isLoading: true);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    yield state.copyWith(isLoading: false);
    yield LoginScreenPasswordResetSent();
  }

  Stream<LoginScreenState> linkAccount(LinkAccountEvent event) async* {
    yield state.copyWith(isLoading: true);
    try {
      if (event.linkProvider == EmailAuthProvider.PROVIDER_ID) {
        UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password);
        UserCredential linkedCredential = await credential.user.linkWithCredential(event.credential);
        UserModel u = await service.getUserWithId(linkedCredential.user.uid);
        User user = linkedCredential.user;
        if (u != null) {
          u.provider = event.provider;
          if (event.provider == FacebookAuthProvider.PROVIDER_ID) {
            u.facebookId = linkedCredential.credential.providerId;
          }
          await service.updateUser(credential.user.uid, u.toJson());
          Global.instance.userId = FirebaseAuth.instance.currentUser.uid;
          yield LoginScreenSuccess();
        } else {
          yield LoginScreenFailure(error: 'Account doesn\'t exist.');
        }
      } else if (event.linkProvider == GoogleAuthProvider.PROVIDER_ID) {
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
        UserCredential linkedCredential = await authResult.user.linkWithCredential(event.credential);
        UserModel u = await service.getUserWithId(linkedCredential.user.uid);
        User user = linkedCredential.user;
        if (u != null) {
          u.provider = event.provider;
          if (event.provider == FacebookAuthProvider.PROVIDER_ID) {
            u.facebookId = linkedCredential.credential.providerId;
          }
          await service.updateUser(authResult.user.uid, u.toJson());
          Global.instance.userId = FirebaseAuth.instance.currentUser.uid;
          yield LoginScreenSuccess();
        } else {
          yield LoginScreenFailure(error: 'Account doesn\'t exist.');
        }
      } else if (event.linkProvider == FacebookAuthProvider.PROVIDER_ID) {
        final LoginResult result = await FacebookAuth.instance.login();

        if (result.accessToken == null) {
          yield state.copyWith(isLoading: false);
          yield LoginScreenFailure(error: 'canceled');
        } else {
          final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);

          final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
          final User user = authResult.user;

          if (user != null) {
            UserCredential linkedCredential = await authResult.user.linkWithCredential(event.credential);
            UserModel u = await service.getUserWithId(linkedCredential.user.uid);
            User user = linkedCredential.user;
            if (u != null) {
              u.provider = event.provider;
              if (event.provider == FacebookAuthProvider.PROVIDER_ID) {
                u.facebookId = linkedCredential.credential.providerId;
              }
              await service.updateUser(authResult.user.uid, u.toJson());
              Global.instance.userId = FirebaseAuth.instance.currentUser.uid;
              yield LoginScreenSuccess();
            } else {
              yield LoginScreenFailure(error: 'Account doesn\'t exist.');
            }

          } else {
            yield state.copyWith(isLoading: false);
            yield LoginScreenFailure(error: 'user doesn\'t exist');
          }
        }
      } else if (event.linkProvider == TwitterAuthProvider.PROVIDER_ID) {
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
            UserCredential linkedCredential = await authResult.user.linkWithCredential(event.credential);
            UserModel u = await service.getUserWithId(linkedCredential.user.uid);
            User user = linkedCredential.user;
            if (u != null) {
              u.provider = event.provider;
              if (event.provider == FacebookAuthProvider.PROVIDER_ID) {
                u.facebookId = linkedCredential.credential.providerId;
              }
              await service.updateUser(authResult.user.uid, u.toJson());
              Global.instance.userId = FirebaseAuth.instance.currentUser.uid;
              yield LoginScreenSuccess();
            } else {
              yield LoginScreenFailure(error: 'Account doesn\'t exist.');
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
      }
    } catch (e) {
      yield state.copyWith(isLoading: false);
      yield LoginScreenFailure(error: e.message);
    }
  }
}