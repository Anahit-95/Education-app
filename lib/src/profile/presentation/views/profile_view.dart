import 'package:educational_app/core/common/widgets/gradient_background.dart';
import 'package:educational_app/core/enums/notification_enum.dart';
import 'package:educational_app/core/res/media_res.dart';
import 'package:educational_app/core/services/injection_container.dart';
import 'package:educational_app/src/notifications/data/models/notification_model.dart';
import 'package:educational_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:educational_app/src/profile/presentation/refactors/profile_body.dart';
import 'package:educational_app/src/profile/presentation/refactors/profile_header.dart';
import 'package:educational_app/src/profile/presentation/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const ProfileAppBar(),
      body: GradientBackground(
        image: MediaRes.profileGradientBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [
            ProfileHeader(),
            ProfileBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sl<NotificationCubit>().sendNotification(
            NotificationModel.empty().copyWith(
              title: 'Test Notification',
              body: 'Body',
              category: NotificationCategory.TEST,
            ),
          );
        },
        child: const Icon(IconlyLight.notification),
      ),
    );
  }
}
