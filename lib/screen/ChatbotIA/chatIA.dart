import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> chatMessages = [
    {"role": "system", "content": "You are a helpful assistant."},
  ];

  bool isLoading = false;
  StreamSubscription<String>? _streamSub;
  bool _shouldAutoScroll = true;
  static const double _autoScrollThreshold = 120.0;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _scrollController.addListener(_onScroll);
  }

  /// 🔹 Cargar historial guardado
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

  /// 🔹 Guardar historial
  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', json.encode(chatMessages));
  }

  /// 🗑️ Borrar historial del chat
  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() {
      chatMessages = [
        {"role": "system", "content": "You are a helpful assistant."},
      ];
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      _shouldAutoScroll = true;
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    _shouldAutoScroll = (maxScroll - current) <= _autoScrollThreshold;
  }

  Future<void> query(String prompt) async {
    if (prompt.trim().isEmpty) return;

    final userMessage = {"role": "user", "content": prompt};
    setState(() {
      chatMessages.add(userMessage);
      isLoading = true;
    });
    await _saveChatHistory();

    final data = {
      "model": "llama3.2",
      "messages": chatMessages,
      "stream": true,
      "options": {
        "temperature": 0.7,
        "num_predict": 500,
        "num_ctx": 2048,
      }
    };

    try {
      final request =
          http.Request('POST', Uri.parse("https://unresolute-subcontinental-kristy.ngrok-free.dev/api/chat"))
            ..headers["Content-Type"] = "application/json"
            ..body = json.encode(data);

      final response = await request.send();

      if (response.statusCode == 200) {
        String accumulated = "";

        setState(() {
          chatMessages.add({"role": "assistant", "content": ""});
        });
        await _saveChatHistory();

        _streamSub = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen((line) async {
          if (line.trim().isEmpty) return;
          final event = json.decode(line);

          if (event["message"]?["content"] != null) {
            accumulated += event["message"]["content"];

            setState(() {
              chatMessages.last["content"] = accumulated;
            });

            if (_shouldAutoScroll) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (!_scrollController.hasClients) return;
                _scrollController.jumpTo(
                    _scrollController.position.maxScrollExtent);
              });
            }

            await _saveChatHistory();
          }
        }, onDone: _saveChatHistory, onError: (err) {
          print("Stream error: $err");
        });
      } else {
        print("Error HTTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud: $e");
    } finally {
      _controller.clear();
      setState(() {
        isLoading = false;
      });
      await _saveChatHistory();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _streamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text(
          "IE ROSA DE SANTA MARIA - IA",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF49433D),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
            tooltip: "Borrar chat",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1A1A),
                  title: const Text("¿Borrar todo el chat?",
                      style: TextStyle(color: Colors.white)),
                  content: const Text(
                    "Esta acción eliminará todo el historial de conversación guardado.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text("Borrar", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _clearChatHistory();
              }
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
                  final message = chatMessages[index];
                  final isUser = message["role"] == "user";

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color(0xFF4D1DEB)
                            : const Color(0xFF185801),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isUser
                              ? const Radius.circular(12)
                              : const Radius.circular(0),
                          bottomRight: isUser
                              ? const Radius.circular(0)
                              : const Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        message["content"] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.3,
                        ),
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
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "¡Pregúntame lo que quieras!",
                        labelStyle: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                      ),
                      onSubmitted: (value) => query(value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 26,
                            width: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Color(0xFF185801),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Color(0xFFEC6A06),
                            size: 30,
                          ),
                          onPressed: () => query(_controller.text),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
