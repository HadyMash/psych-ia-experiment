import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getUser() => _auth.currentUser;
  Future reloadUser() => _auth.currentUser!.reload();

  Stream<User?> get user {
    return _auth.userChanges();
  }

  Future logInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future logIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      return e.toString();
    }
  }

  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  // TODO make a function to delete a user and their data
  Future deleteUserData() async {}

  Future deleteUser() async {
    try {
      await _auth.currentUser!.delete();
    } catch (e) {
      return e;
    }
  }

  final Map _authErrors = {
    '[firebase_auth/invalid-email] The email address is badly formatted.':
        'Invalid Email',
    '[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.':
        'Account temporarily disabled. Reset your passowrd or try again later.',
    '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
        'Incorrect Email or Password',
    '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
        'Incorrect Email or Password',
    'Password should be at least 6 characters':
        'Password should be at least 6 characters',
    '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        'Email address is already in use',
    '[firebase_auth/user-disabled] The user account has been disabled by an administrator.':
        'Account disabled, please contact us for help.',
    '[firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.':
        'Please log out, log in, then try again.',
    '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.':
        'Requests from this device have been temporarliy blocked due to unusual activity. Please try again later.',
    '[firebase_auth/network-request-failed] Network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        'Connection to server failed.',
    '': 'Unkown Error',
    null: 'Unkown Error',
  };
  String getError([String? e]) {
    var error = _authErrors[e];
    print(e);
    return error ?? e;
  }
}
