import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Dominio/repository/song/song.dart';
import 'package:spotifymusic_app/core/usecase/usecase.dart';
import 'package:spotifymusic_app/service_locator.dart';

class GetPlayListUseCase implements UseCase<Either, dynamic> {

  @override
  Future<Either> call({params}) async {
    return await sl<SongsRepository>().getPlayList();
  }
}
