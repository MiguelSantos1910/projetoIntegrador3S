class Bomba{
    final bool ligada;
    final bool desligada;
    final String? message;

    Bomba({
        required this.ligada,
        required this.desligada,
        this.message
    });

    factory Bomba.fromJson(Map<String, dynamic> json){
        return Bomba(
            ligada: json['ligada'],
            desligada: json['desligada'],
            message: json['message']
        );
    }
    Map<String, dynamic> toJson(){
        return {
            'ligada': ligada,
            'desligada': desligada,
            'message': message
        };
    }
}