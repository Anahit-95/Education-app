import 'package:educational_app/src/chat/domain/entities/group.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.group, super.key});

  final Group group;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
