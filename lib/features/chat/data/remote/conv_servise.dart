import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahe_chat/core/utils/extensions.dart';

class ConversationService {
  final FirebaseFirestore _firestore;

  ConversationService(this._firestore);

  Future<String> createDirectConversation(String userId1, String userId2) async {
    // Check if conversation already exists
    final existing = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId1)
        .get()
        .then((snapshot) => snapshot.docs.firstWhereOrNull(
              (doc) {
                final participants = List<String>.from(doc.data()['participants']);
                return participants.contains(userId2) && participants.length == 2;
              },
            ));

    if (existing != null) return existing.id;

    // Create new conversation
    final docRef = await _firestore.collection('conversations').add({
      'participants': [userId1, userId2],
      'lastMessage': '',
      'lastUpdated': FieldValue.serverTimestamp(),
      'unreadCounts': {userId1: 0, userId2: 0},
      'type': 'direct',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Future<String> createGroupConversation(String creatorId, List<String> participantIds, String groupName) async {
    final allParticipants = [...participantIds, creatorId].toSet().toList();
    
    final docRef = await _firestore.collection('conversations').add({
      'participants': allParticipants,
      'lastMessage': '$creatorId created the group',
      'lastUpdated': FieldValue.serverTimestamp(),
      'unreadCounts': allParticipants.fold<Map<String, int>>(
        {},
        (map, id) => {...map, id: id == creatorId ? 0 : 1},
      ),
      'type': 'group',
      'name': groupName,
      'createdBy': creatorId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }
}