
import "package:latlong/latlong.dart";


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

   LatLng getLatLng(){
       
      // geo:40.70653777163278,-73.99495497187503

       final lalo = valor.substring(4).split(',');

        final lat =  double.parse(lalo[0]);
        final lng =  double.parse(lalo[1]);

        return LatLng(lat,lng);



    }
}