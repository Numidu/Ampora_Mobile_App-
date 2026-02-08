class ChatMessage {
  final String role; // "user" | "ai"
  final String text;

  ChatMessage({required this.role, required this.text});
}
