import 'package:educational_app/core/utils/core_utils.dart';
import 'package:educational_app/src/course/features/videos/data/models/video_model.dart';
import 'package:educational_app/src/course/features/videos/domain/entities/video.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_metadata/youtube.dart';

class VideoUtils {
  const VideoUtils._();

  static Future<Video?> getVideoFromYT(
    BuildContext context, {
    required String url,
  }) async {
    void showSnack(String message) => CoreUtils.showSnackBar(context, message);
    try {
      final metadata = await YoutubeMetaData.getData(url);
      if (metadata.thumbnailUrl == null ||
          metadata.title == null ||
          metadata.authorName == null) {
        final missingData = <String>[];
        if (metadata.thumbnailUrl == null) missingData.add('Thumbnail');
        if (metadata.title == null) missingData.add('Title');
        if (metadata.authorName == null) missingData.add('AuthorName');
        var missingDataText = missingData
            .fold(
              '',
              (previousValue, element) => '$previousValue$element, ',
            )
            .trim();
        missingDataText = missingDataText.substring(
          0,
          missingDataText.length - 1,
        );
        final message = 'Could not get video data. Please try again.\n'
            'The following data is missing: $missingDataText';
        showSnack(message);
        return null;
      }
      return VideoModel.empty().copyWith(
        thumbnail: metadata.thumbnailUrl,
        videoUrl: url,
        title: metadata.title,
        tutor: metadata.authorName,
      );
    } catch (e) {
      showSnack('PLEASE TRY AGAIN\n$e');
    }
    return null;
  }

  static Future<void> playVideo(BuildContext context, String videoUrl) async {
    if (!await launchUrl(
      Uri.parse(videoUrl),
      mode: LaunchMode.externalApplication,
    )) {
      CoreUtils.showSnackBar(context, 'Could not launch $videoUrl');
    } else {
      // context.push(VideoPlayerView())
    }
  }
}
