import 'package:educational_app/core/common/app/provider/course_of_the_day_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({
    required this.isFirst,
    super.key,
    this.colour,
  });

  final bool isFirst;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: isFirst ? const EdgeInsets.only(top: 65) : null,
        color: isFirst ? Colors.red : null,
        child: Center(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: 137,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  gradient: isFirst
                      ? const LinearGradient(
                          colors: [Color(0xFF8E96FF), Color(0xFFA06AF9)])
                      : null,
                  color: colour,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      offset: const Offset(0, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: isFirst
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${context.read<CourseOfTheDayNotifier>().courseOfTheDay?.title ?? 'Chemistry'} final\nexams',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
