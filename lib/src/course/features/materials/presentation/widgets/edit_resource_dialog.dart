import 'package:educational_app/src/course/features/materials/domain/entities/picked_resource.dart';
import 'package:flutter/material.dart';

class EditResourceDialog extends StatefulWidget {
  const EditResourceDialog(this.resource, {super.key});

  final PickedResource resource;

  @override
  State<EditResourceDialog> createState() => _EditResourceDialogState();
}

class _EditResourceDialogState extends State<EditResourceDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Placeholder(),
    );
  }
}
