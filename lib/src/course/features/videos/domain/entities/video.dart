// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({
    required this.id,
    required this.videoUrl,
    required this.courseId,
    required this.uploadDate,
    this.thumbnail,
    this.thumbnailIsFile = false,
    this.title,
    this.tutor,
  });

  Video.empty()
      : this(
          id: '_empty.id',
          videoUrl: '_empty.videoUrl',
          uploadDate: DateTime.now(),
          courseId: '_empty.courseId',
          thumbnailIsFile: false,
        );

  final String id;
  final String? thumbnail;
  final String videoUrl;
  final String? title;
  final String? tutor;
  final String courseId;
  final DateTime uploadDate;
  final bool thumbnailIsFile;

  @override
  List<Object?> get props => [id];
}
