import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahe_chat/app/router/router.dart';
import 'package:mahe_chat/core/constants/assets.dart';
import 'package:mahe_chat/features/auth/domain/provider/auth_notifier.dart';
import 'package:mahe_chat/features/auth/presentation/pages/auth.dart';
import 'package:mahe_chat/features/chat/data/remote/chat_api.dart';
import 'package:mahe_chat/features/chat/domain/models/conversation.dart';
import 'package:mahe_chat/features/chat/presentation/components/search_bar.dart';
import 'package:mahe_chat/features/settings/presentation/pages/setting.dart';

import 'chat_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Call the function to get the stream
    final conversationStream = ChatApi().getUserConversationsStream();

    // Check if the stream is empty (user not logged in case)
    if (conversationStream == Stream.empty()) {
      // Return a widget indicating the user needs to log in or similar
      return Scaffold(
        appBar: AppBar(title: Text('My Chats')),
        body: Center(
          child: Text('Please log in to see your conversations.'),
        ),
      );
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF121212),
        drawer: _buildDrawer(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          backgroundColor: Colors.blue.shade700,
          elevation: 5,
          child: const Icon(Icons.chat, color: Colors.white),
        ).animate().scale(delay: 300.ms),
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade900.withOpacity(0.8),
                    const Color(0xFF121212),
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSearchBar(hint: "hint", title: "MaheChat"),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: conversationStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // Handle error state
                          print(
                              'Error listening to conversations: ${snapshot.error}');
                          return Center(
                              child: Text(
                                  'Something went wrong: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Handle loading state while waiting for the first data
                          return Center(child: CircularProgressIndicator());
                        }

                        // --- Data is available! ---

                        // Check if there are no conversations yet
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Text(
                                  'No conversations found. Start a new one!'));
                        }

                        // We have data, build the list of conversations
                        final conversationDocs = snapshot.data!.docs;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: conversationDocs.length,
                            itemBuilder: (context, index) {
                              final conversationDoc = conversationDocs[index];
                              // Get the data from the document
                              final conversationData = conversationDoc.data()
                                  as Map<String, dynamic>; // Cast to Map

                              // Extract data fields (handle potential nulls or type errors)
                              final conversationId = conversationDoc.id;
                              final name =
                                  conversationData['name'] as String? ??
                                      'Unnamed Chat'; // Provide a default
                              final members = (conversationData['members']
                                          as List<dynamic>?)
                                      ?.cast<String>() ??
                                  [];
                              final chat = Conversation(
                                  name: name,
                                  id: conversationId,
                                  isGroup: true,
                                  participants: []);

                              return _buildChatItem(chat);
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildChatItem(Conversation chat) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          MyRouter.myPush(
              context,
              ChatPage(
                conversation: chat,
              ));
        },
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(Assets.image.profile),
            ),
            // if ( false)
            //   Positioned(
            //     right: 0,
            //     bottom: 0,
            //     child: Container(
            //       width: 12,
            //       height: 12,
            //       decoration: BoxDecoration(
            //         color: Colors.green,
            //         shape: BoxShape.circle,
            //         border:
            //             Border.all(color: const Color(0xFF1E1E1E), width: 2),
            //       ),
            //     ),
            //   ),
          ],
        ),
        title: Text(
          chat.name ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          chat.id.toString(),
          style: TextStyle(
            color: Colors.grey.shade400,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "chat.time",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
            // if (chat.unreadCount > 0)
            //   Container(
            //     padding: const EdgeInsets.all(6),
            //     decoration: const BoxDecoration(
            //       color: Colors.blue,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Text(
            //       chat.unreadCount.toString(),
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 12,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1);
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: Consumer(builder: (context, ref, widget) {
        final user = ref.read(authProvider).myUser;
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with profile
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade900.withOpacity(0.8),
                    const Color(0xFF1E1E1E),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: const AssetImage('assets/images/mine.jpg'),
                    backgroundColor: Colors.blue.shade100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.username ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.bio ?? "",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Drawer items
            _buildDrawerItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit profile
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
                MyRouter.myPush(context, SettingsPage());
              },
            ),
            _buildDrawerItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
            const Divider(color: Colors.grey),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () async {
                await ref.read(authProvider).signOut();
                MyRouter.myPushReplacmentAll(context, AuthScreen());
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade400),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
