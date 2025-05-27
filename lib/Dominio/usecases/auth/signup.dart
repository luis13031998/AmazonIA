// SignupUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Dominio/repository/auth/auth.dart';
import 'package:spotifymusic_app/core/usecase/usecase.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {
  final AuthRepository authRepository;

  SignupUseCase(this.authRepository);

  @override
  Future<Either> call({CreateUserReq? params}) async {
    return authRepository.signup(params!);
  }
}
