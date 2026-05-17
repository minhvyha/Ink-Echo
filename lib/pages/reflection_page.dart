import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../widgets/app_header.dart';
import '../widgets/common_buttons.dart';
import '../services/book_service.dart';
import '../utils/image_base64_encoder.dart';
import '../utils/media_permissions.dart';
import '../theme/ink_echo_palette.dart';
import '../theme/ink_echo_theme.dart';

class ReflectionPage extends StatefulWidget {
  final VoidCallback? onBookSaved;

  const ReflectionPage({super.key, this.onBookSaved});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _echo = TextEditingController();
  final _imagePicker = ImagePicker();
  final _speech = SpeechToText();

  String? _mood;
  bool _saving = false;
  bool _speechAvailable = false;
  bool _isListening = false;
  String? _coverImageBase64;
  String? _transcription;
  String _liveTranscript = '';

  static const _moods = [
    'Inspiring',
    'Deeply Moving',
    'Challenging',
    'Nostalgic',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (error) => debugPrint('Speech error: $error'),
      );
    } catch (e) {
      debugPrint('Speech init failed: $e');
      _speechAvailable = false;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _speech.stop();
    _title.dispose();
    _author.dispose();
    _echo.dispose();
    super.dispose();
  }

  Uint8List? get _coverPreviewBytes {
    final b64 = _coverImageBase64;
    if (b64 == null || b64.isEmpty) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final allowed = source == ImageSource.camera
        ? await ensureCameraPermission()
        : await ensurePhotosPermission();
    if (!allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera or photo permission is required.')),
      );
      return;
    }

    try {
      final file = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        imageQuality: 90,
      );
      if (file == null || !mounted) return;

      final bytes = await file.readAsBytes();
      final encoded = await encodeCoverImageForFirestore(bytes);
      if (!mounted) return;

      if (encoded == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Image is too large even after compression. Try a smaller photo.',
            ),
          ),
        );
        return;
      }

      setState(() => _coverImageBase64 = encoded);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not pick image: $e')),
      );
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (!mounted) return;
      final text = _liveTranscript.trim();
      setState(() {
        _isListening = false;
        if (text.isNotEmpty) _transcription = text;
        _liveTranscript = '';
      });
      return;
    }

    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition is not available on this device.'),
        ),
      );
      return;
    }

    final allowed = await ensureMicrophonePermission();
    if (!allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }

    try {
      setState(() {
        _isListening = true;
        _liveTranscript = '';
      });
      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          setState(() {
            _liveTranscript = result.recognizedWords;
            if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
              _transcription = result.recognizedWords.trim();
            }
          });
        },
        listenFor: const Duration(minutes: 2),
        pauseFor: const Duration(seconds: 4),
        localeId: 'en_US',
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isListening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not start listening: $e')),
      );
    }
  }

  void _clearForm() {
    _title.clear();
    _author.clear();
    _echo.clear();
    _speech.stop();
    setState(() {
      _mood = null;
      _coverImageBase64 = null;
      _transcription = null;
      _liveTranscript = '';
      _isListening = false;
    });
  }

  Future<void> _saveBook() async {
    if (_saving) return;
    if (_isListening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stop listening before saving.')),
      );
      return;
    }

    final title = _title.text.trim();
    final author = _author.text.trim();
    if (title.isEmpty || author.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title and author before saving.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await BookService.instance.saveBook(
        title: title,
        author: author,
        echo: _echo.text.trim(),
        mood: _mood,
        coverImageBase64: _coverImageBase64,
        transcription: _transcription,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book saved to your shelf.')),
      );
      _clearForm();
      widget.onBookSaved?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String get _photoSubtitle {
    if (_coverImageBase64 != null) return 'Cover ready (compressed)';
    return 'Tap to add cover';
  }

  String get _voiceSubtitle {
    if (_isListening) {
      return _liveTranscript.isEmpty ? 'Listening… tap to stop' : _liveTranscript;
    }
    if (_transcription != null) return 'Transcription ready';
    return 'Tap to dictate';
  }

  @override
  Widget build(BuildContext context) {
    final coverBytes = _coverPreviewBytes;
    final palette = context.inkPalette;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeader(
                showClose: true,
                onClose: () => Navigator.of(context).maybePop(),
              ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                Text(
                  'Add a book',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: context.inkPrimaryText,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Save a volume to your shelf — it will appear in the Vault.',
                  style: TextStyle(
                    fontSize: 15,
                    color: context.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    label: 'SNAP A PHOTO',
                    subtitle: _photoSubtitle,
                    icon: Icons.camera_alt_outlined,
                    background: palette.actionGreenBg,
                    borderColor: palette.actionGreenBorder,
                    iconBackground: palette.actionGreenBorder,
                    textColor: palette.actionGreenIcon,
                    active: _coverImageBase64 != null,
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ActionCard(
                    label: 'RECORD A THOUGHT',
                    subtitle: _voiceSubtitle,
                    icon: _isListening ? Icons.stop_rounded : Icons.mic_none,
                    background: palette.actionPeachBg,
                    borderColor: palette.actionPeachBorder,
                    iconBackground: palette.actionPeachBorder,
                    textColor: palette.actionPeachIcon,
                    active: _isListening || _transcription != null,
                    onTap: _toggleListening,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const _FieldLabel('THE VOLUME'),
          _BookTextField(
            controller: _title,
            hint: 'Book title',
            icon: Icons.menu_book_outlined,
          ),
          const SizedBox(height: 18),
          const _FieldLabel('THE VOICE'),
          _BookTextField(
            controller: _author,
            hint: "Author's name",
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 18),
          const _FieldLabel('THE ECHO'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextField(
              controller: _echo,
              minLines: 4,
              maxLines: 8,
              style: TextStyle(
                color: context.inkPrimaryText,
                fontSize: 16,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: 'Words that stayed with you…',
                hintStyle: TextStyle(
                  color: context.inkMuted,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
                filled: true,
                fillColor: palette.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: palette.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: palette.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: context.inkAccent, width: 1.4),
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('THE MOOD'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final m in _moods)
                  _MoodChip(
                    text: m,
                    selected: _mood == m,
                    onTap: () => setState(() {
                      _mood = _mood == m ? null : m;
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: GestureDetector(
              onTap: _showPhotoOptions,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: palette.coverPlaceholder,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: palette.coverBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(31),
                  child: coverBytes == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: context.inkMuted,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Upload Cover Art',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: context.inkMuted,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stored as compressed base64 in Firestore',
                                style: TextStyle(
                                  color: context.inkMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(coverBytes, fit: BoxFit.cover),
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Material(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(20),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => setState(
                                    () => _coverImageBase64 = null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          if (_transcription != null && _transcription!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Material(
                color: palette.transcriptionCard,
                borderRadius: BorderRadius.circular(20),
                child: ListTile(
                  leading:
                      Icon(Icons.text_fields, color: palette.actionPeachIcon),
                  title: const Text(
                    'Voice transcription',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    _transcription!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() => _transcription = null),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: GradientButton(
              text: _saving ? 'Saving…' : 'Save book',
              icon: Icons.arrow_forward,
              gradient: const LinearGradient(
                colors: [Color(0xFF1B9C7A), Color(0xFF7FECBA)],
              ),
              onPressed: _saving ? null : _saveBook,
            ),
          ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _BookTextField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.inkPalette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
          fontSize: 15,
          color: context.inkPrimaryText,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 15,
            color: context.inkMuted,
          ),
          filled: true,
          fillColor: palette.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: context.inkAccent, width: 1.2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          suffixIcon: Icon(icon, color: context.inkMuted, size: 22),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
          color: context.inkMuted,
        ),
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _MoodChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? context.inkAccent.withValues(alpha: 0.35)
                : context.inkSurface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? context.inkAccent : context.inkPalette.border,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? context.inkPrimary : context.inkPrimaryText,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color background;
  final Color borderColor;
  final Color iconBackground;
  final Color textColor;
  final bool active;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.background,
    required this.borderColor,
    required this.iconBackground,
    required this.textColor,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: active ? textColor : borderColor,
              width: active ? 2 : 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: textColor, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
