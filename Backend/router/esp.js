const express = require('express');
const router = express.Router();
const Banco = require('../models/db');

router.get('/ler-dados', async (req, res) =>{
    try{
        const esp = await Banco.query(
        `SELECT *
        FROM esp_dados
        ORDER BY data_registro DESC
        LIMIT 50`
        );
        res.status(200).json(esp.rows);
    }catch(err){
        console.error("Não foi possível obter os dados da ESP.", err);
        res.status(500).json({error: err.message});
    }
})

router.post('/upload-dados', async(req, res) =>{
    try{
        const { temperatura, umidade, luminosidade } = req.body;
        if(!temperatura | !umidade){
            return res.status(400).json({ error: "Campos obrigatórios ausentes!" })
        }
        const dados = await Banco.query(
        `INSERT INTO esp_dados
        (temperatura, umidade, luminosidade)
        VALUES ($1, $2, $3)
        RETURNING *`,
        [temperatura, umidade, luminosidade]
        );
        res.status(201).json({
            message: "Dados salvos com sucesso!",
            dados: dados.rows[0]
        });
    }catch(err){
        console.error("Não foi possível fazer o upload dos dados da ESP.", err);
        res.status(500).json({error: err.message});
    }
});
module.exports = router;