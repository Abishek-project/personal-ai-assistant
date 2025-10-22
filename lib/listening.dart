// ignore_for_file: deprecated_member_use

import 'package:ai_assistant_app/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' show SpeechToText;

class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  final FlutterTts flutterTts = FlutterTts();
  bool isListening = false;
  String displayText = '';
  SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  bool isThinking = false; // AI is generating response
  String aiResponse = '';

  // Store API response
  @override
  void initState() {
    super.initState();
    _initSpeech();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      greetUser();
    });
  }

  Future<void> greetUser() async {
    const greeting = "Hey, what’s up? Feel free to ask me anything!";

    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(greeting);
  }

  void _initSpeech() async {
    setState(() {});
  }

  void _startListening() async {
    _lastWords = "";
    aiResponse = "";
    await flutterTts.stop();
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    await flutterTts.stop(); // Stop AI speaking
    _lastWords = "";
    aiResponse = "";
    setState(() {});
  }

  Future<void> speakAIResponse(String text) async {
    if (text.isEmpty) return;

    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5); // Adjust speed
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(text);
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (result.finalResult && _lastWords.isNotEmpty) {
      setState(() => isThinking = true);

      String response = await geminiTextAPI(_lastWords);

      setState(() {
        aiResponse = response;
        isThinking = false;
      });

      // Speak the AI response
      speakAIResponse(response);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _speechToText.stop();
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9D4EDD),
              Color(0xFF7B2CBF),
              Color(0xFF5A189A),
              Color(0xFF240046),
              Color(0xFF10002B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildMainContent()),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(height: 50),
            Text(
              _speechToText.isListening
                  ? _lastWords // Show live speech
                  : (isThinking
                        ? 'AI is thinking...' // Show while API is processing
                        : (aiResponse.isNotEmpty
                              ? aiResponse
                              : 'Tap the microphone to start listening...')),
              textAlign: TextAlign.center,
              style: TextStyle(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(
                  (_lastWords.isNotEmpty || aiResponse.isNotEmpty || isThinking)
                      ? 1
                      : 0.7,
                ),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 80),
            _buildVoiceAnimation(),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceAnimation() {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (isListening)
              for (int i = 0; i < 3; i++)
                _buildRipple(delay: i * 0.5, size: 200.0),
            _buildCoreOrb(),
          ],
        );
      },
    );
  }

  Widget _buildRipple({required double delay, required double size}) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Interval(delay, 1.0, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: size * animation.value,
          height: size * animation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              // ignore: deprecated_member_use
              color: Colors.cyan.withOpacity(0.3 * (1 - animation.value)),
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoreOrb() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.3);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.cyan.withOpacity(0.8),
                  Colors.blue.withOpacity(0.6),
                  Colors.purple.withOpacity(0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () {
              _speechToText.stop();
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            onTap: _speechToText.isNotListening
                ? _startListening
                : _stopListening,

            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.cyan, Colors.blue],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.stop,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
