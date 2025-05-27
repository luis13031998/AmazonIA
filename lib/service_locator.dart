import 'package:get_it/get_it.dart';
import 'package:spotifymusic_app/Data/repository/auth/auth_repository_impl.dart' show AuthRepositoryImpl;
import 'package:spotifymusic_app/Data/sources/auth/auth_firebase_service.dart';
import 'package:spotifymusic_app/Data/sources/songs/song_firebase_service.dart';
import 'package:spotifymusic_app/Dominio/repository/auth/auth.dart';
import 'package:spotifymusic_app/Dominio/repository/song/song.dart';
import 'package:spotifymusic_app/Dominio/usecases/auth/sigin.dart';
import 'package:spotifymusic_app/Dominio/usecases/auth/signup.dart';
import 'package:spotifymusic_app/Dominio/usecases/song/get_news_songs.dart';
import 'package:spotifymusic_app/Dominio/usecases/song/get_play_list.dart';
import 'package:spotifymusic_app/data/repository/song/song_repository_impl.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Registro de servicios Firebase
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl()
    );
    
  sl.registerSingleton<SongFirebaseService>(
    SongFirebaseServiceImpl()
    );

  // Registro de repositorios
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(sl<AuthFirebaseService>())
    ); // Correcto: sl<AuthFirebaseService>() con paréntesis
  sl.registerSingleton<SongsRepository>(
    SongRepositoryImpl(sl<SongFirebaseService>())
    ); // Correcto: sl<SongFirebaseService>() con paréntesis

  // Registro de casos de uso
  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(sl<AuthRepository>())
    );
  sl.registerSingleton<SigninUseCase>(
    SigninUseCase(sl<AuthRepository>())
    );
  sl.registerSingleton<GetNewsSongsUseCase>(
    GetNewsSongsUseCase(sl<SongsRepository>())
    );
    sl.registerSingleton<GetPlayListUseCase>(
      GetPlayListUseCase()
    );
}