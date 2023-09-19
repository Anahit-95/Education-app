import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/question_choice.dart';

class QuestionChoiceModel extends QuestionChoice {
  const QuestionChoiceModel({
    required super.questionId,
    required super.identifier,
    required super.choiceAnswer,
  });

  const QuestionChoiceModel.empty()
      : this(
          questionId: 'Test String',
          identifier: 'Test String',
          choiceAnswer: 'Test String',
        );

  QuestionChoiceModel.fromMap(DataMap map)
      : super(
          questionId: map['questionId'] as String,
          identifier: map['identifier'] as String,
          choiceAnswer: map['choiceAnswer'] as String,
        );

  QuestionChoiceModel.fromUploadMap(DataMap map)
      : super(
          questionId: 'Test String',
          identifier: map['identifier'] as String,
          choiceAnswer: map['choiceAnswer'] as String,
        );

  QuestionChoice copyWith({
    String? questionId,
    String? identifier,
    String? choiceAnswer,
  }) {
    return QuestionChoiceModel(
      questionId: questionId ?? this.questionId,
      identifier: identifier ?? this.identifier,
      choiceAnswer: choiceAnswer ?? this.choiceAnswer,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'identifier': identifier,
      'choiceAnswer': choiceAnswer,
    };
  }
}
