const TagsClp = {
  "status": {
    "modo" : {"ns" : 3, "type" : "Array[Int16]"},
    "umidade" : {"ns" : 3, "type" : "Real"},
    "temperatura" : {"ns" : 3, "type" : "Real"},
    "totalVazao" : {"ns" : 3, "type" : "Int16"},
    "totalEnergia" : {"ns" : 3, "type" : "Int16"},
    "alarmes" : {"ns" : 3, "type" : "Boolean"}
  },
  "cmd": {
    "auto": {"ns": 3, "type": "Boolean"},
    "manual": {"ns": 3, "type": "Boolean"},
    "abortar": {"ns": 3, "type": "Boolean"},
    "reset": {"ns": 3, "type": "Boolean"}
  }
}
module.exports = TagsClp;