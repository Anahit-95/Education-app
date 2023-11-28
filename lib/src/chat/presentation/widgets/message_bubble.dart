import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/res/colours.dart';
import 'package:educational_app/core/utils/constants.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/chat/domain/entities/message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
    this.message, {
    required this.user,
    required this.showSenderInfo,
    required this.isCurrentUser,
    super.key,
  });

  final Message message;
  final LocalUser user;
  final bool showSenderInfo;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: context.width - 45),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showSenderInfo && !isCurrentUser)
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    (user.profilePic == null)
                        ? kDefaultAvatar
                        : user.profilePic!,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  // ignore: unnecessary_null_comparison
                  user == null ? 'Unknown User' : user.fullName,
                ),
              ],
            ),
          Container(
            margin: EdgeInsets.only(top: 4, left: isCurrentUser ? 0 : 20),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isCurrentUser
                  ? Colours.currentUserChatBubbleColour
                  : Colours.otherUserChatBubbleColour,
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
