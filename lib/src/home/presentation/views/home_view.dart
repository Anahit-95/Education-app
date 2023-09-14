import 'package:educational_app/core/common/widgets/gradient_background.dart';
import 'package:educational_app/core/res/media_res.dart';
import 'package:educational_app/src/home/presentation/refactors/home_body.dart';
import 'package:educational_app/src/home/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: HomeBody(),
      ),
    );
  }
}
