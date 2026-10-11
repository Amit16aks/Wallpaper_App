import 'dart:async';
import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// Animated search placeholder where "Search for " remains static
/// and deity/temple names appear letter-by-letter with a typewriter effect,
/// pause, vanish, and type the next deity name.
class TypewriterSearchHint extends StatefulWidget {
  final String? prefix;
  final List<String> deityNames;
  final Duration typingSpeed;
  final Duration displayPause;
  final Duration vanishDuration;

  const TypewriterSearchHint({
    super.key,
    this.prefix,
    this.deityNames = const [
      'Mahadev 🔱',
      'Shree Ram 🏹',
      'Krishna 🦚',
      'Hanuman Ji 🚩',
      'Ganesh Ji',
      'Maa Durga 🌸',
      'Kedarnath Dham 🛕',
      'Ayodhya Mandir 🚩',
      'Prem Mandir 🦚',
    ],
    this.typingSpeed = const Duration(milliseconds: 90),
    this.displayPause = const Duration(milliseconds: 1700),
    this.vanishDuration = const Duration(milliseconds: 250),
  });

  @override
  State<TypewriterSearchHint> createState() => _TypewriterSearchHintState();
}

class _TypewriterSearchHintState extends State<TypewriterSearchHint> {
  int _nameIndex = 0;
  int _charIndex = 0;
  String _displayedText = '';
  bool _isVanishing = false;
  bool _showCursor = true;
  Timer? _typeTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
    _startTyping();
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  void _startTyping() {
    if (widget.deityNames.isEmpty) return;
    final currentTarget = widget.deityNames[_nameIndex];
    final characters = currentTarget.characters.toList();

    _charIndex = 0;
    _displayedText = '';
    _isVanishing = false;

    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(widget.typingSpeed, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_charIndex < characters.length) {
        _charIndex++;
        setState(() {
          _displayedText = characters.sublist(0, _charIndex).join();
        });
      } else {
        // Finished typing full name
        timer.cancel();
        // Pause so the user can read the deity name
        _typeTimer = Timer(widget.displayPause, () {
          if (!mounted) return;
          // Vanish
          setState(() {
            _isVanishing = true;
          });
          _typeTimer = Timer(widget.vanishDuration, () {
            if (!mounted) return;
            setState(() {
              _displayedText = '';
              _isVanishing = false;
              _nameIndex = (_nameIndex + 1) % widget.deityNames.length;
            });
            // Small pause before typing next name
            _typeTimer = Timer(const Duration(milliseconds: 150), () {
              if (mounted) _startTyping();
            });
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.prefix ?? AppLanguage.tr('search_prefix'),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          AnimatedOpacity(
            opacity: _isVanishing ? 0.0 : 1.0,
            duration: widget.vanishDuration,
            curve: Curves.easeInOut,
            child: Text(
              _displayedText,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showCursor ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: Text(
              '|',
              style: TextStyle(
                color: Colors.deepOrange.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
