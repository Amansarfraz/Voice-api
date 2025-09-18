import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TtsScreen extends StatefulWidget {
  const TtsScreen({super.key});

  @override
  State<TtsScreen> createState() => _TtsScreenState();
}

class _TtsScreenState extends State<TtsScreen> {
  final TextEditingController _controller = TextEditingController();
  String selectedVoice = "female";
  bool isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playTts() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    final url =
        "https://text.pollinations.ai/${Uri.encodeComponent(prompt)}?model=openai-audio&voice=$selectedVoice";

    setState(() => isPlaying = true);

    await _audioPlayer.play(UrlSource(url));

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => isPlaying = false);
    });
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
            // Text Input
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

            // Voice Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select Voice: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: selectedVoice,
                  items: const [
                    DropdownMenuItem(value: "female", child: Text("Female")),
                    DropdownMenuItem(value: "male", child: Text("Male")),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedVoice = val!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Play Button
            ElevatedButton.icon(
              onPressed: _playTts,
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(
                isPlaying ? "Playing..." : "Generate Speech",
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
