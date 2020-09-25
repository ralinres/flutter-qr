
import 'dart:async';

import 'package:qrreaderapp/src/modelos/scan_model.dart';

class Validators{

   //el stream transformer  puede modficar la info que fluye en el stream
   //en este caso voy a filtrar que sean de tipo geo solo 
   //los paramtros (recibe)List<ScanModel>,(sale)List<ScanModel> especifican lo que entra y lo que debe salir
  final validaGeo = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
     
     //aqui (data) es el contenido de mi stream y ( sink ) ele enemto que me permite agregar  
     //la data modificada al flujo de nuevo
   handleData: (data, sink) {
        
        //filtro mediante el where de ka lista
       final tipogeo = data.where((element) => element.tipo == 'geo').toList();
      
       //agrego la data filtrada al stream
       sink.add(tipogeo);
   },

  );

  final validaHttp = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
     
     //aqui (data) es el contenido de mi stream y ( sink ) ele enemto que me permite agregar  
     //la data modificada al flujo de nuevo
   handleData: (data, sink) {
        
        //filtro mediante el where de ka lista
       final tipohttp = data.where((element) => element.tipo == 'http').toList();
      
       //agrego la data filtrada al stream
       sink.add(tipohttp);
   },

  );


}