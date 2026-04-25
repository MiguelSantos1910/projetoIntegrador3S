const express = require("express");
const banco = require("./models/db");
const cors = require("cors");

const espRoutes = require("./router/esp");
const usuarioRoutes = require("./router/usuario");

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// Rota teste
app.get("/teste", (req, res) => {
    res.send("API ativa 🚀");
});

// Testar conexão com banco
banco.query("SELECT NOW()")
.then(() => {
    console.log("Conectado ao Supabase PostgreSQL ✅");
})
.catch(err => {
    console.error("Erro ao conectar:", err);
});

// Rotas
app.use("/api/esp", espRoutes);
app.use("/api/usuarios", usuarioRoutes);

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});