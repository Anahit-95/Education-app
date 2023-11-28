import 'package:educational_app/core/common/views/loading_view.dart';
import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/services/injection_container.dart';
import 'package:educational_app/core/utils/core_utils.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/chat/domain/entities/group.dart';
import 'package:educational_app/src/chat/domain/entities/message.dart';
import 'package:educational_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:educational_app/src/chat/presentation/refactors/chat_app_bar.dart';
import 'package:educational_app/src/chat/presentation/widgets/chat_input_field.dart';
import 'package:educational_app/src/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.group, super.key});

  final Group group;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool showingDialog = false;

  List<Message> messages = [];
  List<LocalUser> members = [];
  bool showInputField = false;

  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getGroupMembers(widget.group.id);
    context.read<ChatCubit>().getMessages(widget.group.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(group: widget.group),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (_, state) {
          if (showingDialog) {
            Navigator.of(context).pop();
            showingDialog = false;
          }
          if (state is ChatError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is LeavingGroup) {
            showingDialog = true;
            CoreUtils.showLoadingDialog(context);
          } else if (state is LeftGroup) {
            context.pop();
          } else if (state is GroupMembersFound) {
            setState(() {
              members = state.members;
            });
          } else if (state is MessagesLoaded) {
            setState(() {
              messages = state.messages;
              showInputField = true;
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingMessages ||
              state is GettingGroupMembers ||
              members.isEmpty) {
            return const LoadingView();
          } else if (state is MessagesLoaded ||
              members.isNotEmpty ||
              showInputField ||
              messages.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final message = messages[index];
                      final previousMessage = index < messages.length - 1
                          ? messages[index + 1]
                          : null;
                      final isCurrentUser =
                          message.senderId == context.currentUser!.uid;

                      final showSenderInfo = previousMessage == null ||
                          previousMessage.senderId != message.senderId;
                      final user = members
                          .firstWhere((user) => user.uid == message.senderId);

                      return BlocProvider(
                        create: (_) => sl<ChatCubit>(),
                        child: MessageBubble(
                          message,
                          user: user,
                          showSenderInfo: showSenderInfo,
                          isCurrentUser: isCurrentUser,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                BlocProvider(
                  create: (_) => sl<ChatCubit>(),
                  child: ChatInputField(groupId: widget.group.id),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
