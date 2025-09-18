import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:html' as html; // Web ke liye

class TtsScreen extends StatefulWidget {
  const TtsScreen({super.key});

  @override
  State<TtsScreen> createState() => _TtsScreenState();
}

class _TtsScreenState extends State<TtsScreen> {
  final TextEditingController _controller = TextEditingController();
  String selectedVoice = "alloy"; // default voice
  bool isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // ✅ Supported Voices (Pollinations API ke according)
  final List<String> voices = [
    "alloy",
    "echo",
    "fable",
    "onyx",
    "nova",
    "shimmer",
    "coral",
    "verse",
    "ballad",
    "ash",
    "sage",
    "marin",
    "cedar",
    "amuch",
    "aster",
    "brook",
    "clover",
    "dan",
    "elan",
    "marilyn",
    "meadow",
    "jazz",
    "rio",
    "megan-wetherall",
    "jade-hardy",
  ];

  Future<void> _playTts() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final url =
        "https://text.pollinations.ai/${Uri.encodeComponent(text)}?model=openai-audio&voice=$selectedVoice&format=mp3";

    setState(() => isPlaying = true);

    if (kIsWeb) {
      // ✅ Web playback using HTML AudioElement
      final audio = html.AudioElement(url)
        ..autoplay = true
        ..controls = false;
      html.document.body?.append(audio);

      audio.onEnded.listen((event) {
        setState(() => isPlaying = false);
      });
    } else {
      // ✅ Android/iOS playback using just_audio
      try {
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
        _audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() => isPlaying = false);
          }
        });
      } catch (e) {
        debugPrint("Playback error: $e");
        setState(() => isPlaying = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("AI Text to Speech"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 📝 Text Input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter text to speak",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // 🎤 Voice Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select Voice: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedVoice,
                    items: voices
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedVoice = val!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ▶️ Play Button
            ElevatedButton.icon(
              onPressed: _playTts,
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(
                isPlaying ? "Playing..." : "Speak",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
