import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either<String, String>> signup(CreateUserReq createUserReq); // Especificar los tipos de Either
  Future<Either<String, String>> signin(SigninUserReq signinUserReq); // Especificar los tipos de Either
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either<String, String>> signin(SigninUserReq signinUserReq) async { // Especificar los tipos de Either
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );

      return const Right('Signin was Succesfull');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provived for that user';
      }

      return Left(message);
    }
  }

  @override
  Future<Either<String, String>> signup(CreateUserReq createUserReq) async { // Especificar los tipos de Either
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      FirebaseFirestore.instance.collection('Usuarios').add({
        'name': createUserReq.fullName,
        'email': data.user?.email,
      });

      return const Right('Signup was Succesfull');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provived is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email,';
      }

      return Left(message);
    }
  }
}