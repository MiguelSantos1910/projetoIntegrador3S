const mongoose = require("mongoose");
const ClpSchema = new mongoose.Schema({
  timestamp: { type: Date, default: Date.now },
  db: String,
  tag: String,
  value: mongoose.Schema.Types.Mixed
});
module.exports = mongoose.model("ClpData", ClpSchema);