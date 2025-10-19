import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Dominio/repository/auth/auth.dart';
import 'package:spotifymusic_app/core/usecase/usecase.dart';

/// Caso de uso para registrar un nuevo usuario.
///
/// Retorna un [Either] donde:
/// - [Left] contiene un mensaje de error.
/// - [Right] contiene un mensaje de éxito.
class SignupUseCase implements UseCase<Either<String, String>, CreateUserReq> {
  final AuthRepository authRepository;

  SignupUseCase(this.authRepository);

  @override
  Future<Either<String, String>> call({CreateUserReq? params}) async {
    try {
      final result = await authRepository.signup(params!);
      return result.fold(
        (error) => Left(error),
        (_) => const Right('✅ Usuario creado correctamente'),
      );
    } catch (e) {
      return Left('Ocurrió un error durante el registro: $e');
    }
  }
}
