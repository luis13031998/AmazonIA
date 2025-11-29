import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifymusic_app/IAllamaService.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> chatMessages = [
    {"role": "system", "content": "Eres un asistente útil y siempre respondes en español."},
  ];

  bool isLoading = false;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadChatHistory();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool("isDarkMode") ?? false;
    });
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", value);
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('chat_history');
    if (stored != null) {
      final List decoded = json.decode(stored);
      setState(() {
        chatMessages = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', json.encode(chatMessages));
  }

  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() {
      chatMessages = [
        {"role": "system", "content": "Eres un asistente útil y siempre respondes en español."}
      ];
    });
  }

  Future<void> query(String prompt) async {
    if (prompt.trim().isEmpty) return;

    setState(() {
      chatMessages.add({"role": "user", "content": prompt});
      isLoading = true;
    });

    await _saveChatHistory();

    try {
      final reply = await LlamaService().generateText(prompt);

      setState(() {
        chatMessages.add({"role": "assistant", "content": reply});
      });
      await _saveChatHistory();
    } catch (e) {
      setState(() {
        chatMessages.add({
          "role": "assistant",
          "content": "Error al conectar con la IA: $e"
        });
      });
    } finally {
      _controller.clear();
      setState(() => isLoading = false);

      Future.delayed(const Duration(milliseconds: 150), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  Color _bubbleColor(bool isUser) {
    if (isUser) {
      return isDarkMode ? Colors.blueAccent.shade700 : Colors.blue.shade200;
    } else {
      return isDarkMode ? Colors.green.shade700 : Colors.green.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("IE ROSA DE SANTA MARIA - IA"),
          actions: [
            Row(
              children: [
                Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                Switch(
                  value: isDarkMode,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() => isDarkMode = value);
                    _saveTheme(value);
                  },
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever_rounded),
              color: Colors.redAccent,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("¿Borrar todo el chat?"),
                    content: const Text("Esta acción eliminará todo el historial."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Borrar",
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) _clearChatHistory();
              },
            ),
          ],
        ),

        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    if (index == 0) return const SizedBox.shrink();

                    final msg = chatMessages[index];
                    final isUser = msg["role"] == "user";

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 320),
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _bubbleColor(isUser),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft:
                                isUser ? const Radius.circular(12) : const Radius.circular(0),
                            bottomRight:
                                isUser ? const Radius.circular(0) : const Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          msg["content"] ?? "",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 1),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: "¡Pregúntame lo que quieras!",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey.shade900
                              : Colors.grey.shade300,
                        ),
                        onSubmitted: (v) => query(v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    isLoading
                        ? const SizedBox(
                            height: 26,
                            width: 26,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send_rounded),
                            color: Colors.orange,
                            iconSize: 30,
                            onPressed: () => query(_controller.text),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
