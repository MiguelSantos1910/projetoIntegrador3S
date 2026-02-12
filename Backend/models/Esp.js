const mongoose = require('mongoose');
const EspSchema = new mongoose.Schema(
  {
    temperatura: {type: String},
    umidade: {type: String}, 
    data: {type: Date},
    hora: {type: Date}
  }
);
module.exports = mongoose.model("esp", EspSchema);
