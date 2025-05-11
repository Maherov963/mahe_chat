import 'dart:async';
import 'dart:developer';
import 'package:mahe_chat/app/components/chat_input/attache_sheet.dart';
import 'package:mahe_chat/app/components/chat_input/mic_button.dart';
import 'package:mahe_chat/app/components/chat_input/mic_hold_bar.dart';
import 'package:mahe_chat/app/components/messages/reply_message.dart';
import 'package:mahe_chat/app/components/my_snackbar.dart';
import 'package:mahe_chat/app/utils/plugins/recorder_holder.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_text_field.dart';
import 'package:chat_bottom_container/chat_bottom_container.dart';

class ChatInputArea extends ConsumerStatefulWidget {
  const ChatInputArea({
    super.key,
    this.reply,
    this.onSendText,
    this.focusNode,
    this.onAudioAttach,
    this.onCameraPressed,
    this.onMicPressed,
    this.onCloseReply,
    required this.currentUser,
    this.onRecordSendd,
  });
  final Message? reply;
  final FocusNode? focusNode;
  final User currentUser;
  final void Function(String)? onSendText;
  final void Function()? onAudioAttach;
  final void Function()? onCameraPressed;
  final void Function()? onMicPressed;
  final void Function()? onCloseReply;
  final void Function(Duration, num, String)? onRecordSendd;

  @override
  ChatInputAreaMobileState createState() => ChatInputAreaMobileState();
}

class ChatInputAreaMobileState extends ConsumerState<ChatInputArea> {
  final TextEditingController controler = TextEditingController();
  bool _isTextEmpty = true;
  bool _isMicWidget = false;
  String _time = "0:00";
  final RecorderHolder _recorderHolder = RecorderHolder.instance;
  late final Size screenSize = MediaQuery.of(context).size;
  bool _showAttach = false;
  double kHeightSoFar = 297;
  final controller = ChatBottomPanelContainerController<PanelType>();
  PanelType currentPanelType = PanelType.none;
  @override
  void initState() {
    controler.addListener(() {
      if (controler.text.trim().isEmpty && !_isTextEmpty) {
        _isTextEmpty = true;
        setState(() {});
      } else if (_isTextEmpty && controler.text.trim().isNotEmpty) {
        _isTextEmpty = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _recorderHolder.cancel();
    controler.dispose();
    super.dispose();
  }

  void _updatePanelType(PanelType type) {
    final chatType = switch (type) {
      PanelType.none => ChatBottomPanelType.none,
      PanelType.keyboard => ChatBottomPanelType.keyboard,
      PanelType.emoji => ChatBottomPanelType.other,
      PanelType.tool => ChatBottomPanelType.other,
    };
    controller.updatePanelType(
      chatType,
      data: type,
    );
  }

  Future<void> record() async {
    int id = ref.read(chatProvider).nextId;
    await _recorderHolder.record(id, listner: (p0, time) {
      _time = time;
      setState(() {});
    });
  }

  Future<void> _handleSendPressed() async {
    if (_isMicWidget) {
      await _handleSendRecord();
    } else {
      _handleSendText();
    }
  }

  Future<void> _handleSendRecord() async {
    final filemodel = await _recorderHolder.send();
    setState(() {
      _time = "0:00";
      _isMicWidget = false;
    });
    if (filemodel != null) {
      widget.onRecordSendd
          ?.call(filemodel.duration, filemodel.size, filemodel.path);
    } else {
      MySnackBar.showMySnackBar("المقطع صغير جدا");
    }
  }

  void _handleSendText() {
    if (controler.text.trim().isNotEmpty) {
      widget.onSendText!(controler.text);
      controler.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    log(currentPanelType.name);
    final theme = Theme.of(context);
    return PopScope(
      canPop: currentPanelType == PanelType.none,
      onPopInvoked: (canPop) async {
        if (!canPop) {
          _updatePanelType(PanelType.none);
          setState(() {});
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5)
                .copyWith(top: 4, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(25),
                      bottomRight: const Radius.circular(25),
                      topLeft: Radius.circular(widget.reply != null ? 10 : 25),
                      topRight: Radius.circular(widget.reply != null ? 10 : 25),
                    ),
                    child: ColoredBox(
                      color: theme.colorScheme.surfaceContainer,
                      child: Column(
                        children: [
                          // AnimatedSize(
                          //   duration: Durations.short4,
                          //   child: SizedBox(
                          //     height: _showAttach ? null : 0,
                          //     child: MyAttacheSheet(
                          //       handleClose: () {
                          //         setState(() {
                          //           _showAttach = !_showAttach;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),
                          // if (_showAttach) const Divider(),
                          AnimatedSize(
                            duration: Durations.short4,
                            child: SizedBox(
                              height: widget.reply != null ? null : 0,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ReplyMessage(
                                  style: theme.textTheme.bodySmall,
                                  currentUser: widget.currentUser,
                                  replyPreview: widget.reply?.getPreivew(),
                                  withCancel: true,
                                  onCloseReply: widget.onCloseReply,
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      if (currentPanelType == PanelType.emoji) {
                                        _updatePanelType(PanelType.keyboard);
                                        FocusScope.of(context)
                                            .requestFocus(widget.focusNode);
                                      } else {
                                        _updatePanelType(PanelType.emoji);
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }
                                    },
                                    icon: Icon(
                                      currentPanelType == PanelType.emoji
                                          ? Icons.keyboard_alt_outlined
                                          : Icons.emoji_emotions_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: ChatTextField(
                                      focusNode: widget.focusNode,
                                      textEditingController: controler,
                                    ),
                                  ),
                                  IconButton(
                                    // state: _showAttach,
                                    onPressed: () {
                                      if (currentPanelType == PanelType.tool) {
                                        _updatePanelType(PanelType.keyboard);
                                      } else {
                                        _updatePanelType(PanelType.tool);
                                      }
                                      // setState(() {
                                      //   _showAttach = !_showAttach;
                                      // });
                                    },
                                    icon: const Icon(
                                      Icons.attach_file_sharp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // if (_isTextEmpty)
                                  AnimatedSize(
                                    duration: Durations.short3,
                                    child: SizedBox(
                                      width: _isTextEmpty ? null : 0,
                                      child: IconButton(
                                        onPressed: widget.onCameraPressed,
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (ref.watch(micProvicer).isMicPressed ||
                                  _isMicWidget)
                                MicHoldBar(
                                  time: _time,
                                  onDelete: () {
                                    setState(() {
                                      _time = "0:00";
                                      _recorderHolder.cancel();
                                      _isMicWidget = false;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _buildMicButton(),
              ],
            ),
          ),
          _buildPanelContainer(),
        ],
      ),
    );
  }

  Widget _buildEmojiPanel() {
    final theme = Theme.of(context);

    return SizedBox(
      height: kHeightSoFar,
      child: EmojiPicker(
        config: Config(
            // skinToneDialogBgColor: theme.highlightColor,
            // bgColor: theme.dialogBackgroundColor,
            // backspaceColor: theme.colorScheme.inversePrimary,
            // indicatorColor: theme.colorScheme.inversePrimary,
            // iconColorSelected: theme.colorScheme.inversePrimary,
            ),
        textEditingController: controler,
        onBackspacePressed: () {
          controler.text = controler.text.substring(0, controler.text.length);
        },
      ),
    );
  }

  Widget _buildMicButton() {
    return MicButton(
      screenSize: screenSize,
      showSend: _isTextEmpty && !_isMicWidget,
      isMicWidget: _isMicWidget,
      onCancel: () async {
        _time = "0:00";
        await _recorderHolder.cancel();
        _isMicWidget = false;
      },
      onRelese: () async {
        await _handleSendPressed();
      },
      onLock: () {
        _isMicWidget = true;
      },
      onStart: () async {
        await record();
      },
    );
  }

  Widget _buildPanelContainer() {
    return ChatBottomPanelContainer<PanelType>(
      controller: controller,
      inputFocusNode: widget.focusNode!,
      changeKeyboardPanelHeight: (p0) => kHeightSoFar = p0,
      otherPanelWidget: (type) {
        // Return the custom panel view
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case PanelType.emoji:
            return _buildEmojiPanel();
          case PanelType.tool:
            return SizedBox(
              height: kHeightSoFar,
              child: MyAttacheSheet(
                handleAudioFile: widget.onAudioAttach,
                handleClose: () {
                  _updatePanelType(PanelType.keyboard);
                  // setState(() {
                  //   _showAttach = !_showAttach;
                  // });
                },
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: (panelType, data) {
        // Record the current panel type
        switch (panelType) {
          case ChatBottomPanelType.none:
            currentPanelType = PanelType.none;
            break;
          case ChatBottomPanelType.keyboard:
            currentPanelType = PanelType.keyboard;
            break;
          case ChatBottomPanelType.other:
            if (data == null) return;
            switch (data) {
              case PanelType.emoji:
                currentPanelType = PanelType.emoji;
                break;
              case PanelType.tool:
                currentPanelType = PanelType.tool;
                break;
              default:
                currentPanelType = PanelType.none;
                break;
            }
            break;
        }
        setState(() {});
      },
      panelBgColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

/// Custom bottom panel type
enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}
