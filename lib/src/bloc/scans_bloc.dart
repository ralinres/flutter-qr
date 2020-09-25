
import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/modelos/scan_model.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';



//en esta clase voy a implementar otra forma de patron singlenton
//el with se llama mixim en dart agrega las propiedades de una clase externa
class ScansBloc with Validators{
   
  // esto seria una forma de declarar el constructor privado 
 //con la idea de que mi instancia de miclase sea solo una
static final ScansBloc _singlenton = new ScansBloc._internal();
 
 //me garantiza que la instancia que retirne sea unica y no una nueva
 factory ScansBloc(){
   
    return _singlenton;

 }

 
  //Declaracion del constructor
  ScansBloc._internal(){  
  //obtener scans de la base dato
  //este es mi metodo que obtiene y agreaga al stream se va a ejecutar cada vez que instancie mi clase ScanBloc
   obtenerScans();

  }

 //declaracion del controlador del stream
 final _scanStreamController = new StreamController<List<ScanModel>>.broadcast();
 
   //cada vez que creo un stremaController necesito un dispose
  dispose(){
      // el ?. garantiza si existe la instancia lo cierra
     _scanStreamController?.close();
  }  

 
 //GET para obtener el stream que fluye de tipo geo ( nota que agrege el streamTransformer de la clase validator mia )
  Stream<List<ScanModel>> get scansStream => _scanStreamController.stream.transform(validaGeo);
 
 //GET para obtener el stream que fluye de tipo http ( nota que agrege el streamTransformer de la clase validator mia )
  Stream<List<ScanModel>> get scansStreamHttp => _scanStreamController.stream.transform(validaHttp);
  
 obtenerScans() async{

      //obtengo los scans de mi bd y las agrego al stream     
    _scanStreamController.sink.add( await DBProvider.db.getTodosScans());

 }

 agregarScans(ScanModel model) async{
    
    //mando a agregar el scan ,con el await garantico que no salte hasta que se ejecute  
    await DBProvider.db.nuevoScan(model);
      
    //actualizo mi stream de nuevo
    obtenerScans();
 }

 borrarScan(int id) async{
   
      //mando a borrar el scan ,con el await garantico que no salte hasta que se ejecute   
     await DBProvider.db.deleteScan(id);
      
      //actualizo mi stream de nuevo
     obtenerScans();

 }

 borrarScanTodos(String tipo) async{
   
      //mando a borrar tdos ,con el await garantico que no salte hasta que se ejecute   
     await DBProvider.db.deleteByTipe(tipo);
      
      //actualizo mi stream de nuevo
     obtenerScans();

 }

  


}