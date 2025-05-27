import 'package:dartz/dartz.dart';
import 'package:spotifymusic_app/Dominio/repository/song/song.dart';
import 'package:spotifymusic_app/core/usecase/usecase.dart';

class GetNewsSongsUseCase implements UseCase<Either, dynamic> {
  final SongsRepository songRepository;  // Asegúrate de que este sea el nombre correcto

  GetNewsSongsUseCase(this.songRepository);

  @override
  Future<Either> call({params}) async {
    return songRepository.getNewsSongs();
  }
}
