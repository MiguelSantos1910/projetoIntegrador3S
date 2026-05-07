const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
const porta = 3000;

app.use(cors());
app.use(express.json());

app.get('/dados-app', async (req, res) => {
    try {
        const lat = -22.90;
        const lon = -47.06;

        const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,relative_humidity_2m,uv_index`;

        const response = await axios.get(url, { timeout: 5000 });

        const data = response.data.current;

        res.json({
            temperature: data.temperature_2m ?? 0,
            humidity: data.relative_humidity_2m ?? 0,
            uvIndex: data.uv_index ?? 0
        });

    } catch (err) {
        if (err.code === 'ECONNABORTED') {
            return res.status(408).json({ error: 'Tempo de resposta excedido.' });
        }

        res.status(500).json({ error: 'Erro ao obter dados do clima.' });
    }
});

app.get('/', (req, res) => {
    res.send("API Funcionando!");
});

app.listen(porta, () => {
    console.log(`Servidor rodando em http://localhost:${porta}`);
});
