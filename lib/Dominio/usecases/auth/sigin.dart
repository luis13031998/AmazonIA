// SigninUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Data/models/auth/signin_user_req.dart';
import 'package:spotifymusic_app/Dominio/repository/auth/auth.dart';
import 'package:spotifymusic_app/core/usecase/usecase.dart';

class SigninUseCase implements UseCase<Either, SigninUserReq> {
  final AuthRepository authRepository;

  SigninUseCase(this.authRepository);

  @override
  Future<Either> call({SigninUserReq? params}) async {
    return authRepository.signin(params!);
  }
}
