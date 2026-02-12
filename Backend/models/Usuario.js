const mongoose = require('mongoose');
const UsuarioSchema = new mongoose.Schema(
  {
    id: {type: Number},
    nome: {type: String, required: true},
    email: {type: String, required: true},
    senha: {type: String, required: true}
  }
);
module.exports = mongoose.model("usuario", UsuarioSchema);