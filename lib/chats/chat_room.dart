import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoom extends StatefulWidget {
  final String friendID;
  final String friendName;
  final String friendPhoto;

  const ChatRoom({
    super.key,
    required this.friendID,
    required this.friendName,
    required this.friendPhoto,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final messageController = TextEditingController();
  String myID = FirebaseAuth.instance.currentUser!.uid;

  String chatID = "";

  @override
  void initState() {
    super.initState();
    createChatRoom();
  }

  Future<void> createChatRoom() async {
    final chats = FirebaseFirestore.instance.collection('chats');

    final chatDoc = await chats
        .where('members', arrayContains: myID)
        .get();

    // البحث عن غرفة موجودة مسبقًا
    for (var doc in chatDoc.docs) {
      final members = doc['members'] as List;
      if (members.contains(widget.friendID)) {
        chatID = doc.id;
        return;
      }
    }

    // إنشاء غرفة جديدة إذا لم تكن موجودة
    final newChat = await chats.add({
      'members': [myID, widget.friendID],
      'lastMessage': '',
      'updatedAt': DateTime.now(),
    });

    chatID = newChat.id;
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .add({
      'sender': myID,
      'receiver': widget.friendID,
      'text': text,
      'time': DateTime.now(),
    });

    // تحديث آخر رسالة في صفحة المحادثات
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .update({
      'lastMessage': text,
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              backgroundImage: widget.friendPhoto.isNotEmpty
                  ? NetworkImage(widget.friendPhoto)
                  : null,
              child: widget.friendPhoto.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              widget.friendName,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatID)
                  .collection('messages')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['sender'] == myID;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xFFFFD700)
                              : Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['text'],
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // صندوق كتابة الرسالة
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "اكتب رسالة...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFFFD700)),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
