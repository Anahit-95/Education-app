import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/res/colours.dart';
import 'package:educational_app/core/utils/constants.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/chat/domain/entities/message.dart';
import 'package:educational_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble(
    this.message, {
    required this.user,
    required this.showSenderInfo,
    required this.isCurrentUser,
    super.key,
  });

  final Message message;
  final LocalUser? user;
  final bool showSenderInfo;
  final bool isCurrentUser;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  LocalUser? notGroupMember;

  @override
  void initState() {
    if (widget.user == null) {
      context.read<ChatCubit>().getUser(widget.message.senderId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is UserFound) {
          setState(() {
            notGroupMember = state.user;
          });
        }
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: context.width - 45),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: widget.isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (widget.showSenderInfo && !widget.isCurrentUser)
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      (widget.user == null || widget.user!.profilePic == null)
                          ? (notGroupMember == null ||
                                  notGroupMember!.profilePic == null)
                              ? kDefaultAvatar
                              : notGroupMember!.profilePic!
                          : widget.user!.profilePic!,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.user == null
                        ? notGroupMember == null
                            ? 'Unknown User'
                            : notGroupMember!.fullName
                        : widget.user!.fullName,
                  ),
                ],
              ),
            Container(
              margin:
                  EdgeInsets.only(top: 4, left: widget.isCurrentUser ? 0 : 20),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.isCurrentUser
                    ? Colours.currentUserChatBubbleColour
                    : Colours.otherUserChatBubbleColour,
              ),
              child: Text(
                widget.message.message,
                style: TextStyle(
                  color: widget.isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
