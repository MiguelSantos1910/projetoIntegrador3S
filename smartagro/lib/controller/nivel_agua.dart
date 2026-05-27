import 'dart:math';
class NivelAguaController{
  final Random random = Random();
  String VerificarNivelAgua() {
  int aguaNivel = random.nextInt(3);
  if(aguaNivel == 0){
    return "Vazio";
  }
  if(aguaNivel == 1){
    return "Metade";
  }
  return "Cheio";
}
}