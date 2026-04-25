const express = require('express');
const router = express.Router();
const Usuario = require('../models/db');

router.get('/usuarios-cadastrados', async (req, res) =>{
    try{

        const usuario = await Usuario.query(
            `SELECT *
             FROM usuario_dados
             ORDER BY id DESC
             LIMIT 100`
        );

        res.status(200).json(usuario.rows);

    }catch(err){

        console.error(
            "usuarios-cadastrados error:",
            err.message
        );

        res.status(500).json({
            error: err.message
        });
    }
});

router.post('/cadastrar-usuario', async (req, res) =>{
    try{

        const {nome, email, senha} = req.body;

        if (!nome || !email || !senha){

            return res.status(400).json({
                error: "Campos obrigatórios ausentes."
            });
        }

        const novoUsuario =
            await Usuario.query(

            `INSERT INTO usuario_dados
             (nome, email, senha)
             VALUES ($1, $2, $3)
             RETURNING *`,

            [nome, email, senha]

        );

        res.status(201).json({
            message: "Usuário criado com sucesso!",
            usuario: novoUsuario.rows[0]
        });

    }catch(err){

        console.error(
            "Não foi possível cadastrar o usuário.",
            err.message
        );

        res.status(500).json({
            error: err.message
        });
    }
});


router.put('/atualizar-cadastro/:id', async (req, res) =>{
    try{

        const { id } = req.params;
        const { nome, email, senha } = req.body;

        const usuarioAtualizado =
            await Usuario.query(

            `UPDATE usuario_dados
             SET nome = $1,
                 email = $2,
                 senha = $3
             WHERE id = $4
             RETURNING *`,

            [nome, email, senha, id]

        );

        if (usuarioAtualizado.rows.length === 0){

            return res.status(404).json({
                message: "Usuário não encontrado."
            });
        }

        res.status(200).json(
            usuarioAtualizado.rows[0]
        );

    }catch(err){

        console.error(
            "Não foi possível atualizar o usuário.",
            err.message
        );

        res.status(400).json({
            error: err.message
        });
    }
});

router.delete("/deletar-usuario/:id",
async (req, res) => {

    try{

        const { id } = req.params;

        const usuarioDeletado =
            await Usuario.query(

            `DELETE FROM usuario_dados
             WHERE id = $1
             RETURNING *`,

            [id]

        );

        if (usuarioDeletado.rows.length === 0){

            return res.status(404).json({
                message: "Usuário não encontrado!"
            });
        }

        res.status(200).json({
            message:
            "Usuário deletado com sucesso!"
        });

    }catch (err){

        console.error(
            "Erro ao deletar o usuário",
            err.message
        );

        res.status(500).json({
            error: err.message
        });
    }

});

module.exports = router;
