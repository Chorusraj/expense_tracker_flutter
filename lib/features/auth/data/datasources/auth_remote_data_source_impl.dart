import 'package:expense_tracker/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_tracker/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> signIn(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;
    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;
    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

@override
  UserModel? getCurrentUser(){
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserModel> googleSignIn() async {
  final googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    throw Exception('Google sign-in aborted');
  }

  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential =
      await firebaseAuth.signInWithCredential(credential);

  final user = userCredential.user!;

  return UserModel(
    id: user.uid,
    email: user.email ?? '',
  );
}


}
