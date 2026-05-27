import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': "Olá! Como posso ajudar sua plantação hoje?", 'isMe': false},
  ];

  // 1. Variável de estado para controlar o carregamento
  bool _isLoading = false;

  void _sendMessage() async {
    final apiKey = dotenv.env['Langflow_api'];
    final userMessage = _controller.text.trim();

    String url =
        "http://localhost:7860/api/v1/run/a09491dd-5749-40ec-8074-8142cb7ad904?stream=false";

    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'text': userMessage, 'isMe': true});
      _controller.clear();
      _isLoading = true; // 2. Ativa o "pensando" assim que envia
    });

    if (apiKey == null) {
      setState(() {
        _messages.add({
          'text': 'Erro interno: API Key não configurada no arquivo .env',
          'isMe': false,
        });
        _isLoading = false; // Desativa o carregamento em caso de erro
      });
      return;
    }

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json", "x-api-key": apiKey},
            body: jsonEncode({
              "input_value": userMessage,
              "output_type": "chat",
              "input_type": "chat",
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final botReply =
            decoded["outputs"]?[0]?["outputs"]?[0]?["results"]?["message"]?["text"] ??
            "Não consegui extrair o texto da resposta.";

        setState(() {
          _messages.add({'text': botReply, 'isMe': false});
        });
      } else {
        setState(() {
          _messages.add({
            'text':
                'O servidor do Langflow respondeu com erro (Status: ${response.statusCode})',
            'isMe': false,
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'Não foi possível conectar ao Langflow. Erro: $e',
          'isMe': false,
        });
      });
    } finally {
      // 3. O bloco 'finally' roda SEMPRE (dando certo ou errado), desligando o indicador
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos o total de itens na lista. Se estiver carregando, adicionamos +1 para o balão de loading
    int itemCount = _messages.length + (_isLoading ? 1 : 0);

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Column(
        children: [
          // 1. Header Verde Arredondado
          Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF7DCC5C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const SafeArea(
              child: Center(
                child: Text(
                  'ChatBot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // 2. Área de Mensagens
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset('images/logo.png', width: 250),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // 4. Se for o último item da lista e _isLoading for true, mostra o balão de digitando
                    if (index == _messages.length) {
                      return _buildThinkingBubble();
                    }

                    final msg = _messages[index];
                    return _buildChatBubble(msg['text'], msg['isMe']);
                  },
                ),
              ],
            ),
          ),

          // 3. Campo de Entrada de Texto
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled:
                          !_isLoading, // Desativa o campo enquanto o bot "pensa"
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Escreva uma mensagem',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading
                        ? null
                        : _sendMessage, // Desativa o botão se estiver carregando
                    icon: Icon(
                      Icons.send_rounded,
                      color: _isLoading ? Colors.grey : Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget normal para as mensagens
  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // 5. Novo Widget: Balão estilizado indicando que o Bot está digitando/pensando
  Widget _buildThinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFF7DCC5C),
            ), // Verde da sua identidade
          ),
        ),
      ),
    );
  }
}
