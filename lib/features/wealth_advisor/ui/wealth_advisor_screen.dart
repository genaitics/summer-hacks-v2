import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:student_fin_os/core/widgets/gemini_key_setup_widget.dart';
import 'package:student_fin_os/features/assistant/ui/voice_assistant_sheet.dart';
import 'package:student_fin_os/features/wealth_advisor/ui/avatar_widget.dart';
import 'package:student_fin_os/models/assistant_models.dart';
import 'package:student_fin_os/models/avatar_mood.dart';
import 'package:student_fin_os/providers/assistant_providers.dart';
import 'package:student_fin_os/providers/aws_providers.dart';
import 'package:student_fin_os/providers/wealth_advisor_providers.dart';

class WealthAdvisorScreen extends ConsumerStatefulWidget {
  const WealthAdvisorScreen({super.key});

  @override
  ConsumerState<WealthAdvisorScreen> createState() => _WealthAdvisorScreenState();
}

class _WealthAdvisorScreenState extends ConsumerState<WealthAdvisorScreen> {
  final TextEditingController _queryController = TextEditingController();
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _tts.setStartHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
      }
    });

    _tts.setCompletionHandler(() {
      ref.read(avatarMoodOverrideProvider.notifier).state = null;
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });

    _tts.setErrorHandler((msg) {
      ref.read(avatarMoodOverrideProvider.notifier).state = null;
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _tts.stop();
    super.dispose();
  }

  void _submitQuery(String text) {
    if (text.trim().isEmpty) return;
    _queryController.clear();
    FocusScope.of(context).unfocus();
    ref.read(chatAssistantControllerProvider.notifier).sendMessage(text);
  }

  Future<void> _speakText(String text) async {
    try {
      await _tts.stop();
      await _tts.setLanguage('en-IN');
      await _tts.setSpeechRate(0.55);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);

      ref.read(avatarMoodOverrideProvider.notifier).state = AvatarMood.speaking;
      setState(() {
        _isSpeaking = true;
      });

      await _tts.speak(text);
    } catch (e) {
      debugPrint('[WealthAdvisorScreen] TTS speak error: $e');
      ref.read(avatarMoodOverrideProvider.notifier).state = null;
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  Future<void> _openVoiceAssistant() async {
    if (_isSpeaking) {
      await _tts.stop();
      ref.read(avatarMoodOverrideProvider.notifier).state = null;
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.92,
          child: VoiceAssistantSheet(),
        );
      },
    );
  }

  Widget _buildSpeechBubble(BuildContext context, ChatAssistantState chatState) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget child;
    if (chatState.isTyping) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Analyzing your wealth...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    } else {
      final assistantMessages = chatState.messages
          .where((m) => m.role == AssistantRole.assistant)
          .toList();

      if (assistantMessages.isEmpty) {
        child = Text(
          'Namaste! I am FinMate, your personal AI Wealth Advisor. Ask me anything about your budget, savings goals, or transactions, or tap the microphone to start talking!',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.4,
          ),
        );
      } else {
        final lastMessage = assistantMessages.last;
        child = Text(
          lastMessage.content,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: lastMessage.isError ? colorScheme.error : colorScheme.onSurface,
            height: 1.4,
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasKey = ref.watch(hasGeminiKeyProvider);
    if (!hasKey) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surface,
                colorScheme.surfaceContainerLowest,
              ],
            ),
          ),
          child: const SafeArea(
            child: GeminiKeySetupWidget(),
          ),
        ),
      );
    }

    final chatState = ref.watch(chatAssistantControllerProvider);

    // Sync TTS reading: speak new assistant responses automatically
    ref.listen<ChatAssistantState>(chatAssistantControllerProvider, (previous, next) {
      if (next.messages.isNotEmpty && next.messages.last.role == AssistantRole.assistant) {
        final lastMsg = next.messages.last;
        if (previous == null || previous.messages.isEmpty || previous.messages.last.content != lastMsg.content) {
          if (!lastMsg.isError) {
            _speakText(lastMsg.content);
          }
        }
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Simple Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FinMate AI Advisor',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Clear conversation',
                          icon: Icon(Icons.delete_outline, color: colorScheme.onSurfaceVariant),
                          onPressed: () {
                            ref.read(chatAssistantControllerProvider.notifier).clearConversation();
                            _tts.stop();
                            ref.read(avatarMoodOverrideProvider.notifier).state = null;
                            setState(() {
                              _isSpeaking = false;
                            });
                          },
                        ),
                        if (_isSpeaking)
                          IconButton(
                            tooltip: 'Stop speaking',
                            icon: Icon(Icons.volume_off, color: colorScheme.error),
                            onPressed: () {
                              _tts.stop();
                              ref.read(avatarMoodOverrideProvider.notifier).state = null;
                              setState(() {
                                _isSpeaking = false;
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Centered Big Avatar and Speech Bubble
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Large Centered Avatar
                      GestureDetector(
                        onTap: () {
                          if (_isSpeaking) {
                            _tts.stop();
                            ref.read(avatarMoodOverrideProvider.notifier).state = null;
                            setState(() {
                              _isSpeaking = false;
                            });
                          } else {
                            _openVoiceAssistant();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.surfaceContainer.withValues(alpha: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(alpha: 0.03),
                                blurRadius: 40,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: const AvatarWidget(
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Speech Bubble
                      _buildSpeechBubble(context, chatState),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              
              // Sticky Bottom Chat Input Bar
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.mic, color: colorScheme.primary),
                              onPressed: _openVoiceAssistant,
                              tooltip: 'Talk with Voice',
                            ),
                            Expanded(
                              child: TextField(
                                controller: _queryController,
                                onSubmitted: (text) => _submitQuery(text),
                                style: TextStyle(color: colorScheme.onSurface),
                                decoration: InputDecoration(
                                  hintText: 'Ask your Wealth Advisor...',
                                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.primary,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: () => _submitQuery(_queryController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
