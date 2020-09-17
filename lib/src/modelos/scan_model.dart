
class ScanModel {

    ScanModel({this.id, this.tipo, this.valor,}){
      
      if(this.valor.contains('http')){
           this.tipo = 'http';
      }else{
           this.tipo = 'geo';
      }

    }

    int id;
    String tipo;
    String valor;
     
     //el factory es nuevo es para crear una instacia de la clase
    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id    : json["id"],
        tipo  : json["tipo"],
        valor : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id"   : id,
        "tipo" : tipo,
        "valor": valor,
    };
}