const express = require("express");
const mongoose = require("mongoose");
const espRoutes = require("./Backend/router/esp");
const usuarioRoutes = require("./Backend/router/usuario");
const app = express();
const port = 1000;
app.use(express.json());
mongoose.conect("mongodb://localhost:27017/projetoIntegrador3").then(() => console.log("Conectado ao MongoDB")).catch(err => console.error("Erro so conectar:", err));
app.use("/api/esp", espRoutes),
app.use("/api/usuarios", usuarioRoutes);
app.listen(port, () =>{
    console.log(`Servidor rodando em http://localhost:${port}`);
});
