import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_ai_chat/constants/string_conts.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser =
      ChatUser(id: '1', firstName: 'Gemini', profileImage: geminiProfile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
            onPressed: _sendMediaMessage,
            icon: const Icon(Icons.image_search_rounded))
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    )));
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastmessage = messages.firstOrNull;

        if (lastmessage != null && lastmessage.user == geminiUser) {
          lastmessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "",
                  (previousValue, currentValue) =>
                      "$previousValue ${currentValue.text}") ??
              "";
          lastmessage.text += response;
          setState(() {
            messages = [lastmessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "",
                  (previousValue, currentValue) =>
                      "$previousValue ${currentValue.text}") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {}
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage message = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: 'Describe this photo',
          medias: [
            ChatMedia(url: file.path, fileName: '', type: MediaType.image),
          ]);

      _sendMessage(message);
    }
  }
}
