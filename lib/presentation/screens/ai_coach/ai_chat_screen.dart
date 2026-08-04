import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../providers/ai_provider.dart';
import 'widgets/chat_bubble.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref.read(aiChatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);

    // Auto-scroll when new messages arrive
    ref.listen(aiChatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy_outlined,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Coach',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('Always here for you',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref.read(aiChatProvider.notifier).clearChat(),
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty
                ? _EmptyState(onSuggestionTap: (text) {
                    ref.read(aiChatProvider.notifier).sendMessage(text);
                  })
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length +
                        (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length) {
                        return const ChatBubble(
                          message: '...',
                          isUser: false,
                          isTyping: true,
                        );
                      }
                      final msg = chatState.messages[index];
                      return ChatBubble(
                        message: msg.content,
                        isUser: msg.isUser,
                        timestamp: msg.timestamp,
                      );
                    },
                  ),
          ),
          if (chatState.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(chatState.error!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ),
          _InputBar(
            controller: _controller,
            onSend: _sendMessage,
            isLoading: chatState.isLoading,
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final void Function(String) onSuggestionTap;

  const _EmptyState({required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Create a 4-day workout plan for me',
      'What should I eat before a workout?',
      'How can I improve my bench press?',
      'Give me a HIIT routine for beginners',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.smart_toy_outlined,
                color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text("Hi! I'm your AI Coach",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about workouts, nutrition, or fitness goals.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: suggestions
                .map((s) => GestureDetector(
                      onTap: () => onSuggestionTap(s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Text(s,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            )),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(top: BorderSide(color: AppColors.cardDark)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              maxLines: null,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: AppStrings.askAiCoach,
                filled: true,
                fillColor: AppColors.cardDark,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isLoading ? null : onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: isLoading ? null : AppColors.primaryGradient,
                color: isLoading ? AppColors.textMuted : null,
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
