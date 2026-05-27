import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService{
    final String url = 'http://localhost:3000/api/usuarios';

    //GET
    Future<List<dynamic>> getUsuarios() async {
        final response = await http.get(Uri.parse('$url/usuarios-cadastrados'));
        if (response.statusCode == 200) {
            final dados = jsonDecode(response.body) as List;
            return dados.map((json) => Usuario.fromJson(json)).toList();
        } else {
            throw Exception('Falha ao carregar os usuários');
        }
    }

    //POST
    Future<Usuario> cadastrarUsuario(Usuario usuario) async {
        final response = await http.post(Uri.parse('$url/cadastrar-usuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toJson()));
        if (response.statusCode == 201) {
            final dados = jsonDecode(response.body);   
            return Usuario.fromJson(dados['usuario']);
        } else {
            throw Exception('Falha ao cadastrar o usuário');
        }
    }

    //PUT
    Future<Usuario> atualizarUsuario(int id, Usuario usuario) async {
        final response = await http.put(Uri.parse('$url/atualizar-cadastro/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toJson()));
        if (response.statusCode == 200) {
            final dados = jsonDecode(response.body);   
            return Usuario.fromJson(dados['usuario']);
        } else {
            throw Exception('Falha ao atualizar o usuário');
        }
    }

    //DELETE
    Future<void> deletarUsuario(int id) async {
        final response = await http.delete(Uri.parse('$url/deletar-usuario/$id'));
        if (response.statusCode != 204) {
            throw Exception('Falha ao deletar o usuário');  
        }
    }

   // LOGIN
    Future<Usuario> login(
        String email,
        String senha,
        ) async {
        final response = await http.post(
            Uri.parse('$url/login'),
            headers: {'Content-Type': 'application/json',
        },
            body: jsonEncode({
            'email': email,
            'senha': senha,
            }),
        );

        if (response.statusCode == 200) {
            final dados = jsonDecode(response.body);
            return Usuario.fromJson(
            dados['usuario'],
            );
        } else {
            throw Exception('Falha ao fazer login');
        }
    }
}