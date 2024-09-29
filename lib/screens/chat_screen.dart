import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/message_card.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.email,
    required this.uid,
    required this.isAdmin,
  });

  final String email;
  final String uid;
  final bool isAdmin;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final DbCloud cloud = DbCloud();
  final FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 1000), () => scrollDown());
      }
    });
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void send() {
    if (messageController.text.isNotEmpty) {
      cloud.sendMessage(messageController.text, widget.uid, widget.email);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollDown();
    });
    messageController.clear();
    if (!widget.isAdmin) {
      cloud.addNotification(widget.email, true, false);
    } else {
      print("admin send");
      cloud.addNotification(widget.email, false, true);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: cloud.getMessages(widget.email),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                final doc = data!.docs;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    final message = doc[index].data();

                    return MessageCard(
                        message: message["message"],
                        sender: widget.isAdmin
                            ? !message["sender"]
                            : message["sender"]);
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: MyInputField(
                  controller: messageController,
                  focusNode: focusNode,
                  obscureText: false,
                  hintText: "Message",
                  label: const Text("Message"),
                ),
              ),
              GestureDetector(
                onTap: send,
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
