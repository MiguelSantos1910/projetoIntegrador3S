const express = require('express');
const router = express.Router();
const Esp = require('../models/Esp');

router.get('/ler-dados', async (req, res) =>{
    try{
        const esp = await Esp.find();
        res.status(200).json(esp);
    }catch(err){
        console.error("Não foi possível obter os dados da ESP.", error);
        req.status(500).json({error: err.message});
    }
})

router.post('/upload-dados', async(req, res) =>{
    try{
        const {temperatura, umidade, data, hora} = req.body;
        if(!temperatura | !umidade){
            return res.status(400).json({ error: "Campos obrigatórios ausentes!" })
        }
        const dados = await Esp.create({ temperatura, umidade, data, hora });
        res.status(201).json({
            message: "Dados obtidos com sucesso!",
            temperatura: dados.temperatura,
            umidade: dados.umidade,
            data: dados.data,
            hora: dados.hora
        })
    }catch(err){
        console.error("Não foi possível fazer o upload dos dados da ESP.", err);
        req.status(500).json({error: err.message});
    }
});

module.exports = router;