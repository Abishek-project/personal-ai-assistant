// ignore_for_file: deprecated_member_use

import 'package:ai_assistant_app/listening.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const AIAssistantApp());
}

class AIAssistantApp extends StatelessWidget {
  const AIAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant',
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _speakWelcomeMessage();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  final FlutterTts flutterTts = FlutterTts();
  final List<String> suggestions = [
    'What are the best practices for managing state in Flutter apps?',
    'How can I optimize the performance of a React web application?',
    'What are the pros and cons of using microservices architecture?',
  ];

  Future<void> _speakWelcomeMessage() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.6); // slower for clarity
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);

    await flutterTts.speak(
      "Hello Abishek! I’m your personal AI assistant. How can I help you today?",
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning,";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
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
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildSuggestionsView()),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            // ignore: deprecated_member_use
            backgroundColor: Colors.white.withOpacity(0.3),
            child: const Icon(Icons.person, size: 35, color: Colors.white70),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const Text(
                'Abishek',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsView() {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Try asking...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...suggestions.map((s) => _buildSuggestionCard(s)),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSuggestionCard(String text) {
    return GestureDetector(
      onTap: () => _navigateToListeningPage(prefilledText: text),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  void _navigateToListeningPage({String? prefilledText}) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ListeningPage()));
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () => _navigateToListeningPage(),
            child: ClipOval(
              child: Image.asset(
                'assets/siri.gif',
                fit: BoxFit.cover, // Fills the circle
                width: 120,
                height: 120,
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
