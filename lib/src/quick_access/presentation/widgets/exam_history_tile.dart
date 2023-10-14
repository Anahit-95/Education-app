import 'package:educational_app/core/res/colours.dart';
import 'package:educational_app/core/res/media_res.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:educational_app/src/quick_access/presentation/views/exam_history_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ExamHistoryTile extends StatelessWidget {
  const ExamHistoryTile(
    this.exam, {
    this.navigateToDetails = true,
    super.key,
  });

  final UserExam exam;
  final bool navigateToDetails;

  @override
  Widget build(BuildContext context) {
    final answeredQuestionsPersentage =
        exam.answers.length / exam.totalQuestions;
    return GestureDetector(
      onTap: navigateToDetails
          ? () => Navigator.of(context).pushNamed(
                ExamHistoryDetailsScreen.routeName,
                arguments: exam,
              )
          : null,
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: Colours.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: exam.examImageUrl == null
                ? Image.asset(MediaRes.test)
                : Image.network(exam.examImageUrl!),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.examTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'You have completed',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '${exam.answers.length}/${exam.totalQuestions} ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: answeredQuestionsPersentage < .5
                          ? Colours.redColour
                          : Colours.greenColour,
                    ),
                    children: const [
                      TextSpan(
                        text: 'questions',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularStepProgressIndicator(
            totalSteps: exam.totalQuestions,
            currentStep: exam.answers.length,
            selectedColor: answeredQuestionsPersentage < .5
                ? Colours.redColour
                : Colours.greenColour,
            padding: 0,
            width: 60,
            height: 60,
            child: Center(
              child: Text(
                '${(answeredQuestionsPersentage * 100).toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: answeredQuestionsPersentage < .5
                      ? Colours.redColour
                      : Colours.greenColour,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
