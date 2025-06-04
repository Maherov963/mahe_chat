// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mahe_chat/domain/models/messages/message.dart';

// class MessageService {
//   final FirebaseFirestore _firestore;

//   MessageService(this._firestore);

//   Future<void> sendMessage({
//     required String conversationId,
//     required String senderId,
//     required String text,
//     required List<String> participantIds,
//   }) async {
//     final batch = _firestore.batch();
    
//     // Create message reference
//     final messagesRef = _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .doc();
    
//     // Create message data
//     final messageData = {
//       'senderId': senderId,
//       'text': text,
//       'timestamp': FieldValue.serverTimestamp(),
//       'isRead': false,
//     };
    
//     batch.set(messagesRef, messageData);
    
//     // Update conversation metadata
//     final conversationRef = _firestore
//         .collection('conversations')
//         .doc(conversationId);
    
//     final updates = {
//       'lastMessage': text,
//       'lastUpdated': FieldValue.serverTimestamp(),
//     };
    
//     // Update unread counts for all participants except sender
//     for (final participantId in participantIds) {
//       if (participantId != senderId) {
//         updates['unreadCounts.$participantId'] = FieldValue.increment(1);
//       }
//     }
    
//     batch.update(conversationRef, updates);
    
//     await batch.commit();
//   }

//   Stream<List<Message>> getMessagesStream(String conversationId) {
//     return _firestore
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => Message.fromMap(doc.data(), doc.id))
//             .toList());
//   }
// }