import 'dart:io';

import 'package:educational_app/core/enums/notification_enum.dart';
import 'package:educational_app/core/res/colours.dart';
import 'package:educational_app/core/services/injection_container.dart';
import 'package:educational_app/src/notifications/data/models/notification_model.dart';
import 'package:educational_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colours.primaryColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static void sendNotification({
    required String title,
    required String body,
    required NotificationCategory category,
  }) {
    sl<NotificationCubit>().sendNotification(
      NotificationModel.empty().copyWith(
        title: title,
        body: body,
        category: category,
      ),
    );
  }
}
