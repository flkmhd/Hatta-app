import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Inbox Page placeholder - matching React's InboxPage.tsx
class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Mock conversations
    final conversations = [
      _Conversation(
        id: '1',
        name: 'Amina',
        avatar:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
        lastMessage: 'Bonjour, est-ce que l\'article est toujours disponible ?',
        time: 'Il y a 2h',
        unread: true,
      ),
      _Conversation(
        id: '2',
        name: 'Sara',
        avatar:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
        lastMessage: 'Merci pour la réponse rapide !',
        time: 'Hier',
        unread: false,
      ),
      _Conversation(
        id: '3',
        name: 'Yacine',
        avatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
        lastMessage: 'Je peux venir chercher demain ?',
        time: '2 jours',
        unread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n?.translate('inbox.title') ?? 'Messages'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: conversations.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, indent: 72, color: AppColors.border),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return _ConversationTile(conversation: conversation);
        },
      ),
    );
  }
}

class _Conversation {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final bool unread;

  const _Conversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    required this.unread,
  });
}

class _ConversationTile extends StatelessWidget {
  final _Conversation conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // TODO: Navigate to chat
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(conversation.avatar),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.name,
              style: TextStyle(
                fontWeight: conversation.unread
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
          Text(
            conversation.time,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation.unread
                    ? AppColors.foreground
                    : AppColors.mutedForeground,
                fontWeight: conversation.unread
                    ? FontWeight.w500
                    : FontWeight.w400,
              ),
            ),
          ),
          if (conversation.unread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
