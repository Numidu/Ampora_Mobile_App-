import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/service/chatbot_service.dart';
import 'package:flutter/material.dart';

class ChatbotBody extends StatefulWidget {
  String? startCity;
  String? endCity;
  final int socLevel;
  final List<Map<String, dynamic>> stations;

  ChatbotBody({
    super.key,
    this.startCity,
    this.endCity,
    required this.socLevel,
    required this.stations,
  });

  @override
  State<ChatbotBody> createState() => _ChatbotBodyState();
}

class _ChatbotBodyState extends State<ChatbotBody> {
  final ChatbotService chatbotService = ChatbotService();
  final TextEditingController controller = TextEditingController();

  final List<Map<String, String>> messages = [];
  bool isTyping = false;

  final String conversationId = "trip-${DateTime.now().millisecondsSinceEpoch}";

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
      controller.clear();
      isTyping = true;
    });

    final res = await chatbotService.sendMessage({
      "conversation_id": conversationId,
      "start_city": widget.startCity,
      "end_city": widget.endCity,
      "soc_level": widget.socLevel,
      "user_text": text,
      "stations": widget.stations,
    });

    setState(() {
      messages.add({"role": "ai", "text": res["assistant_text"] ?? "No reply"});
      isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CHAT LIST
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (var m in messages)
                Align(
                  alignment: m["role"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: m["role"] == "user"
                          ? AppTheme.primaryGreen
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      m["text"]!,
                      style: TextStyle(
                        color:
                            m["role"] == "user" ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              if (isTyping)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Assistant is thinking...",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // INPUT
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => send(),
                  decoration: const InputDecoration(
                    hintText: "Ask something...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: AppTheme.primaryGreen),
                onPressed: send,
              )
            ],
          ),
        ),
      ],
    );
  }
}
