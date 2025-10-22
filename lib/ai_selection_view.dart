import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AISelectionPage extends StatefulWidget {
  const AISelectionPage({super.key});

  @override
  State<AISelectionPage> createState() => _AISelectionPageState();
}

class _AISelectionPageState extends State<AISelectionPage> {
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> aiList = [
    {"name": "Jarvis", "asset": "assets/ai1.png", "voice": 1, "male": true},
    {"name": "Siri", "asset": "assets/ai2.png", "voice": 2, "male": false},
    {"name": "Alexa", "asset": "assets/ai3.png", "voice": 3, "male": false},
    {"name": "Cortana", "asset": "assets/ai4.png", "voice": 4, "male": true},
    {"name": "Eve", "asset": "assets/ai5.png", "voice": 5, "male": false},
    {"name": "Neo", "asset": "assets/ai6.png", "voice": 6, "male": true},
  ];

  int? selectedAIIndex;

  Future<void> _speakAI(String text, int voice, bool male) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.setVolume(1.0);

    await flutterTts.setPitch(male ? 0.5 : 1.2);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak("Hi, I am $text AI speaking!");
  }

  @override
  void dispose() {
    flutterTts.stop();
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
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed), Color(0xFF0b7dda)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Select Your AI",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // To balance back icon spacing
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: aiList.length,
                  itemBuilder: (context, index) {
                    final ai = aiList[index];
                    final isSelected = selectedAIIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAIIndex = index;
                        });
                        _speakAI(ai['name'], ai['voice'], ai['male']);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF00f0ff),
                                    Color(0xFF0077ff),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isSelected
                              ? null
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.6),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(ai['asset']),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ai['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: selectedAIIndex != null
                        ? () {
                            final selectedAI = aiList[selectedAIIndex!];
                            _speakAI(
                              selectedAI['name'],
                              selectedAI['voice'],
                              selectedAI['male'],
                            );
                          }
                        : null,
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
