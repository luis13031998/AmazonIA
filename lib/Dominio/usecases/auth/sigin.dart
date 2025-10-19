import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Data/models/auth/signin_user_req.dart';
import 'package:spotifymusic_app/Dominio/repository/auth/auth.dart';
import 'package:spotifymusic_app/core/usecase/usecase.dart';

class SigninUseCase implements UseCase<Either<String, String>, SigninUserReq> {
  final AuthRepository authRepository;

  SigninUseCase(this.authRepository);

  @override
  Future<Either<String, String>> call({SigninUserReq? params}) async {
    try {
      final result = await authRepository.signin(params!);

      return result.fold(
        (error) => Left(error),
        (_) => const Right('✅ Inicio de sesión exitoso'),
      );
    } catch (e) {
      return Left('Ocurrió un error durante el inicio de sesión: $e');
    }
  }
}
