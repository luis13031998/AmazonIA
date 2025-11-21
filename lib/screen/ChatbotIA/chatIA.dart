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

  // 🔥 Modo oscuro / modo claro
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadChatHistory();
    _scrollController.addListener(_onScroll);
  }

  /// Cargar preferencia de tema guardada
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool("isDarkMode") ?? false;
    });
  }

  /// Guardar tema actual
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
        {"role": "system", "content": "Eres un asistente útil y siempre respondes en español de forma clara y natural."},
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
        "temperature": 0.5,
        "num_predict": 200,
        "num_ctx": 1508,
      }
    };

    try {
      final request = http.Request(
          'POST',
          Uri.parse("https://unresolute-subcontinental-kristy.ngrok-free.dev"))
        ..headers["Content-Type"] = "application/json"
        ..body = json.encode(data);

      final response = await request.send();

      if (response.statusCode == 200) {
        String accumulated = "";

        setState(() {
          chatMessages.add({"role": "assistant", "content": ""});
        });

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
        });
      }
    } catch (e) {
      print("Request error: $e");
    } finally {
      _controller.clear();
      setState(() => isLoading = false);
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
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        appBar: AppBar(
          title: const Text("IE ROSA DE SANTA MARIA - IA"),
          actions: [
            // 🔥 SWITCH MODO CLARO / OSCURO
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
                    content:
                        const Text("Esta acción eliminará todo el historial."),
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
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
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
                            bottomLeft: isUser
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                            bottomRight: isUser
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          msg["content"] ?? '',
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
                              : const Color.fromARGB(255, 166, 163, 163),
                        ),
                        onSubmitted: (value) => query(value),
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
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
