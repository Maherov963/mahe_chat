import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

class ChatApi {
  Future<String?> createNewConversation(
      {required String conversationName,
      required List<String> initialMemberUids}) async {
    try {
      log("creating conv");
      final currentUserUid = getCurrentUserUid();
      if (currentUserUid == null) {
        log("User must be signed in to create a conversation");
        // Maybe navigate to sign-in or show an error
        return null;
      }
      final newConversationRef =
          await FirebaseFirestore.instance.collection('conversations').add({
        'name': conversationName,
        'members': initialMemberUids..add(currentUserUid), // List of UIDs
        'createdAt': FieldValue.serverTimestamp(), // Use server timestamp!
        'createdBy': currentUserUid,
        // Add other initial fields if needed
      });

      log("New conversation created with ID: ${newConversationRef.id}");
      return newConversationRef.id; // Return the ID of the new conversation
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addMessageToConversation({
    required String conversationId,
    required String messageText,
  }) async {
    try {
      final currentUserUid = getCurrentUserUid();
      if (currentUserUid == null) {
        throw Exception('User must be signed in to send messages');
      }

      // Reference to the messages subcollection
      final messagesRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages');

      // Add the new message
      await messagesRef.add({
        'senderUid': currentUserUid,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Optionally update the conversation's lastMessage timestamp
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .update({
        'lastMessage': FieldValue.serverTimestamp(),
        'lastMessageText': messageText,
      });
    } catch (e) {
      log('Error sending message: $e');
      rethrow;
    }
  }

  Stream<List<Message>> getMessagesStream(String conversationId) {
    return FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        log(doc.data().toString());
        return TextMessage(
            author: Profile(
              id: doc["senderUid"],
              username: doc["senderUid"],
            ),
            id: doc.id,
            text: doc["text"],
            createdAt:
                (doc["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now());
        // return Message.fromJson(doc.data());
      }).toList();
    });
  }

  String? getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns the UID or null if no user is signed in
  }

  Stream<QuerySnapshot> getUserConversationsStream() {
    final currentUserUid = getCurrentUserUid();

    if (currentUserUid == null) {
      // If the user is not logged in, return an empty stream or throw an error
      // Depending on your app's flow, you might handle this by navigating
      // the user to the login screen instead.
      print("Cannot listen to conversations: User not logged in.");
      return Stream.empty(); // Return an empty stream
    }

    // Reference the 'conversations' collection
    final conversationsCollection =
        FirebaseFirestore.instance.collection('conversations');

    // Build the query: Find documents where the 'members' array contains the current user's UID
    final userConversationsQuery = conversationsCollection
        .where('members', arrayContains: currentUserUid)
        // Optional: Add ordering, e.g., by last message timestamp
        // .orderBy('lastMessageTimestamp', descending: true);
        .orderBy('createdAt',
            descending: true); // Example: order by creation date

    // Return the stream of snapshots from this query
    return userConversationsQuery.snapshots();
  }
}
