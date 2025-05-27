import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Data/models/auth/signin_user_req.dart';
import 'package:spotifymusic_app/Data/sources/auth/auth_firebase_service.dart';
import 'package:spotifymusic_app/Dominio/repository/auth/auth.dart';
import 'package:spotifymusic_app/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository{
  AuthRepositoryImpl(AuthFirebaseService authFirebaseService);

  @override
  Future<Either> signin(SigninUserReq signinUserReq) async{
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

   @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }
}