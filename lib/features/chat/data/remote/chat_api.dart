import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

=======
<<<<<<< HEAD
import 'package:mahe_chat/features/chat/domain/models/conversation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// class ChatApi {
//   Future<List<Conversation>> getUserConversations(String userId,
//       Function(Conversation) onAdd, Function(Conversation) onUpdate) async {
//     QueryBuilder<ParseObject> query =
//         QueryBuilder<ParseObject>(ParseObject('conversation'));
//     // Include participants data
//     query.includeObject(['participants']);
//     LiveQuery liveQuery = LiveQuery();
//     // // Only get conversations where current user is a participant
//     // query.whereEqualTo('participants', ParseObject('_User')..objectId = userId);

//     final ParseResponse response = await query.query();
//     if (response.success && response.results != null) {
// // Listen for any changes in the conversations
//       Subscription subscription = await liveQuery.client.subscribe(query);
//       subscription.on(LiveQueryEvent.update, (ParseObject conversation) {
//         onUpdate.call(Conversation.fromJson(conversation.toJson()));
//         print('Conversation updated: $conversation');
//       });

//       subscription.on(LiveQueryEvent.create, (ParseObject conversation) {
//         // Handle new conversation
//         onAdd.call(Conversation.fromJson(conversation.toJson()));

//         print('New conversation: $conversation');
//       });

//       subscription.on(LiveQueryEvent.delete, (ParseObject conversation) {
//         // Handle conversation deletion
//         print('Conversation deleted: $conversation');
//       });

//       final list = response.results as List<ParseObject>;
//       return list
//           .map(
//             (e) => Conversation.fromJson(e.toJson()),
//           )
//           .toList();
//     } else {
//       log("error");

//       return [];
//     }
//   }

//   Future<void> createConversation(String userId) async {
//     // Ensure Parse is setup and running
//     var conversation = ParseObject('conversation');

//     // Create pointers for each userId
//     List<ParseObject> userPointers = [
//       ParseObject('_User')..set('objectId', userId)
//     ];

//     // Set the participants field
//     conversation.set<List<ParseObject>>('participants', userPointers);

//     // Set the participants field
//     conversation.set<String>('name', "maherov");

//     // Optionally set the createdBy field
//     conversation.set<ParseObject>(
//         'createdBy', ParseObject('_User')..set('objectId', userId));

//     // Save the conversation object
//     final ParseResponse response = await conversation.save();

//     // Handle the response
//     if (response.success) {
//       print('Conversation created successfully');
//     } else {
//       print('Error creating conversation: ${response.error?.message}');
//     }
//   }
// }
=======
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
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
<<<<<<< HEAD
        'members': initialMemberUids..add(currentUserUid), // List of UIDs
=======
<<<<<<< HEAD
        'members': initialMemberUids, // List of UIDs
=======
        'members': initialMemberUids..add(currentUserUid), // List of UIDs
>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
        'createdAt': FieldValue.serverTimestamp(), // Use server timestamp!
        'createdBy': currentUserUid,
        // Add other initial fields if needed
      });

      log("New conversation created with ID: ${newConversationRef.id}");
      return newConversationRef.id; // Return the ID of the new conversation
    } catch (e) {
      log(e.toString());
<<<<<<< HEAD
      rethrow;
    }
  }

=======
<<<<<<< HEAD
    }
  }

=======
      rethrow;
    }
  }

>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
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
<<<<<<< HEAD
            createdAt:
                (doc["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now());
=======
            createdAt: (doc["timestamp"] as Timestamp?)?.toDate()??DateTime.now());
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
        // return Message.fromJson(doc.data());
      }).toList();
    });
  }

<<<<<<< HEAD
=======
>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
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
