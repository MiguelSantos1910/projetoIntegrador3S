const express = require('express');
const router = express.Router();
const Usuario = require('../models/Usuario');

router.get('/usuarios-cadastrados', async (req, res) =>{
    try{
        const usuario = await Usuario.find();
        res.status(200).json(usuario);
    }catch(err){
        console.error("usuarios-cadastrados error:", err.message);
        res.status(500).json({ error: err.message });
    }
});

router.post('/cadastrar-usuario', async (req, res) =>{
    try{
        const {nome, email, senha} = req.body;
        if (!nome | !email | !senha){
            return res.status(400).json({error: "Campos obrigatórios ausentes."})
        }
        const novoUsuario = await Usuario.create({nome, email, senha});
        res.status(201).json({message: "Usuário criado com sucesso!", novoUsuario});
    }catch(err){
        console.error("Não foi possível cadastrar o usuário.", err.message);
        res.status(500).json({ error: err.message });
    }
})

router.put('/atualizar-cadastro/:id', async (req, res) =>{
    try{
        const usuarioLogado = req.usuario;
        const { nome, email, usuario } = req.body;
        const dadosAtualizado = {};

        if(nome) dadosAtualizado.nome = nome;
        if(email) dadosAtualizado.email = email;
        if(senha) dadosAtualizado.senha = senha;

        const usuarioAtualizado = await Usuario.findByIdAndUpdate(
            req.params.id,
            dadosAtualizado,
            { new: true}
        )
        if(!usuarioAtualizado){
            return res.status(404).json({ message: "Usuário não encontrado."})
        }

        res.status(200).json({
            id: usuarioAtualizado,
            nome: usuarioAtualizado.nome,
            email: usuarioAtualizado.email,
            senha: usuarioAtualizado.senha
        });
    }catch(err){
        console.error("Não foi possível atualizar o usuário.", err.message);
        res.status(400).json({ error: err.message });
    }
})

router.delete("/deletar-usuario/:id", async (req, res) => {
    try {
        const usuarioDeletado = await Usuario.findByIdAndDelete(req.params.id);
        if (!usuarioDeletado) {
            return res.status(404).json({ message: "Usuário não encontrado!" });
        }
        res.status(200).json({ message: "Usuário deletado com sucesso!" });
    } catch (err) {
        console.error("Erro ao deletar o usuário", err.message);
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;