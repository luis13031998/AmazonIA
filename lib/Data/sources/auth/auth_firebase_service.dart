import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either<String, String>> signup(CreateUserReq createUserReq);
  Future<Either<String, String>> signin(SigninUserReq signinUserReq);
  Future<Either<String, String>> sendPasswordReset(String email);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // 🔐 INICIAR SESIÓN (verificación de correo antes de entrar)
  // ============================================================
  @override
  Future<Either<String, String>> signin(SigninUserReq signinUserReq) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );

      final user = userCredential.user;
      if (user == null) return const Left('Error al obtener usuario.');

      // ❌ Bloquear si no verificó su correo
      if (!user.emailVerified) {
        await _auth.signOut();
        return const Left(
          'Debes verificar tu correo antes de iniciar sesión. Revisa tu bandeja de entrada.',
        );
      }

      return const Right('Inicio de sesión exitoso');

    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Correo electrónico no válido.';
          break;
        case 'user-not-found':
          message = 'No existe una cuenta con ese correo.';
          break;
        case 'wrong-password':
          message = 'Ingresar credenciales para iniciar sesión ‼️.';
          break;
        default:
          message = 'Error: ${e.message}';
      }
      return Left(message);
    } catch (e) {
      return Left('Error inesperado: $e');
    }
  }

  // ============================================================
  // 🆕 REGISTRO + GUARDAR NOMBRE + VERIFICACIÓN DE CORREO
  // ============================================================
  @override
  Future<Either<String, String>> signup(CreateUserReq createUserReq) async {
    try {
      final userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      final user = userCredential.user;
      if (user == null) return const Left('No se pudo crear el usuario.');

      // 🔥 Guardar información REAL en Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'fullName': createUserReq.fullName,
        'email': createUserReq.email,
        'provider': 'email',
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
        
      });

      // 📧 Enviar verificación
      await user.sendEmailVerification();

      // 🔐 Cerrar sesión hasta verificar correo
      await _auth.signOut();

      return const Right(
        'Cuenta creada exitosamente. Se envió un correo de verificación.',
      );

    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'La contraseña es demasiado débil.';
          break;
        case 'email-already-in-use':
          message = 'Ya existe una cuenta con ese correo.';
          break;
        default:
          message = 'Error al registrarse: ${e.message}';
      }
      return Left(message);

    } catch (e) {
      return Left('Error inesperado: $e');
    }
  }

  // ============================================================
  // 🔁 RECUPERACIÓN DE CONTRASEÑA
  // ============================================================
  @override
  Future<Either<String, String>> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right('Se ha enviado un correo de recuperación.');
    } on FirebaseAuthException catch (e) {
      return Left('Error al enviar el correo: ${e.message}');
    } catch (e) {
      return Left('Error inesperado: $e');
    }
  }

  // (Extra — alias repetido)
  Future<Either<String, String>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right('Se ha enviado un correo de recuperación.');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Error al enviar el correo.');
    } catch (e) {
      return Left('Error inesperado: $e');
    }
  }
}
