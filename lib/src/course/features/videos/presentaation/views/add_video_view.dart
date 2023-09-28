import 'package:educational_app/core/extensions/string_extensions.dart';
import 'package:educational_app/src/course/domain/entities/course.dart';
import 'package:flutter/material.dart';

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  static const routeName = '/add-video';

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  final urlController = TextEditingController();
  final authorController = TextEditingController(text: 'dbestech');
  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  final formKey = GlobalKey<FormState>();

  final authorFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final urlFocusNode = FocusNode();

  bool getMoreDetails = false;

  bool get isYoutube => urlController.text.trim().isYoutubeVideo;

  bool thumbNailsFile = false;

  void reset() {
    setState(() {
      urlController.clear();
      authorController.text = 'dbestech';
      titleController.clear();
      getMoreDetails = false;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.addListener(() {
      if (urlController.text.trim().isEmpty) reset();
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    authorController.dispose();
    titleController.dispose();
    courseController.dispose();
    courseNotifier.dispose();
    urlFocusNode.dispose();
    titleFocusNode.dispose();
    authorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Video'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [],
      ),
    );
  }
}
