import 'package:chatty/api/chat_room.dart';
import 'package:chatty/api/user_details.dart';
import 'package:chatty/common/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/chat-screen';
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late DocumentReference chatRoomDocRef;
  late String otherUser;
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;
  late String userPhoto;
  @override
  void initState() {
    super.initState();
    ref
        .watch(userDetailsProvider.notifier)
        .getDisplayPhoto(context, otherUser)
        .then((value) => userPhoto = value!);
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
        if (_isKeyboardVisible) {
          _focusNode.requestFocus();
        } else {
          _focusNode.unfocus();
        }
      });
    });
  }

  void addMessage() async {
    chatRoomDocRef = await ref
        .read(chatRoomProvider.notifier)
        .createOneToOneChatRoom(
            context: context,
            thisUser: ref.read(currentUserProvider)!.email!,
            otherUser: otherUser);
    ref.read(chatRoomProvider.notifier).addMessage(
          senderId: ref.read(currentUserProvider)!.uid,
          documentReference: chatRoomDocRef,
          message: '',
          context: context,
        );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>?;
    if (arguments != null && arguments.isNotEmpty) {
      otherUser = arguments[0];
    }
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(),
              ),
            ),
            TextField(
              focusNode: _focusNode,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Enter text',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
