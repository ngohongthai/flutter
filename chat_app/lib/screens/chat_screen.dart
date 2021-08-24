import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance
        .collection('chats/Vt6VkPPteKYWQ0Exou33/messages')
        .snapshots();
    final CollectionReference _chats = FirebaseFirestore.instance
        .collection('chats/Vt6VkPPteKYWQ0Exou33/messages');

    Future<void> _addMessage() async {
      return _chats
          .add({'text': 'New message from Add message function'})
          .then((value) => print('Added new message'))
          .catchError((err) => print("error: $err"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _messagesStream,
        builder: (cxt, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (ctx, index) => Container(
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(snapshot.data?.docs[index]['text']),
                      subtitle: Text('..'),
                    ),
                  ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addMessage,
      ),
    );
  }
}
