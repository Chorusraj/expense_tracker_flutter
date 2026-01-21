import 'package:expense_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<UserEntity> call() {
    return repository.signInWithGoogle();
  }
}
