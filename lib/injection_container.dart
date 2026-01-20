import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_tracker/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/features/auth/domain/usecases/get_current_user.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_out.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/expense/data/datasources/expense_local_data_source.dart';
import 'package:expense_tracker/features/expense/data/datasources/expense_local_data_source_impl.dart';
import 'package:expense_tracker/features/expense/data/datasources/expense_remote_data_source.dart';
import 'package:expense_tracker/features/expense/data/datasources/expense_remote_data_source_impl.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository_impl.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
  () => ExpenseRemoteDataSourceImpl(sl(),sl()),
);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(() => ExpenseBloc(sl()));
}
