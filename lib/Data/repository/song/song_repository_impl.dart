import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Data/sources/songs/song_firebase_service.dart';
import 'package:spotifymusic_app/Dominio/repository/song/song.dart';
import 'package:spotifymusic_app/service_locator.dart';

class SongRepositoryImpl extends SongsRepository {
  final SongFirebaseService songFirebaseService;

  SongRepositoryImpl(this.songFirebaseService);

  @override
  Future<Either> getNewsSongs() async {
      return await sl<SongFirebaseService>().getNewsSongs();
  }
  
  @override
  Future<Either> getPlayList() async {
   
    return await sl<SongFirebaseService>().getPlayList();
  }
}
