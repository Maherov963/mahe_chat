import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahe_chat/data/errors/failures.dart';
import 'package:mahe_chat/features/auth/data/remote/auth_api.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCashedUser();
}

class AuthRepImpl implements AuthRepo {
  final AuthApi _authApi = AuthApi();
  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final res = await _authApi.signInWithEmail(username, password);
      return Right(res);
    } catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final res = await _authApi.signInWithGoogle();
      return Right(res);
    } catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCashedUser() async {
    try {
      final res = await _authApi.getCashedUser();
      return Right(res);
    } catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final res = await _authApi.signOut();
      return Right(res);
    } catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }
}
