// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PickedResource extends Equatable {
  const PickedResource({
    required this.path,
    required this.title,
    required this.author,
    this.authorManuallySet = false,
    this.description = '',
  });

  PickedResource copyWith({
    String? path,
    String? title,
    String? author,
    String? description,
    bool? authorManuallySet,
  }) {
    return PickedResource(
      path: path ?? this.path,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      authorManuallySet: authorManuallySet ?? this.authorManuallySet,
    );
  }

  final String path;
  final String title;
  final String author;
  final String description;
  final bool authorManuallySet;

  @override
  List<Object?> get props => [path];
}
