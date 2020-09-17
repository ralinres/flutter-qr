import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/modelos/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DBProvider{


 static Database _database;
 static final DBProvider db = DBProvider._();

 // esto seria una forma de declarar el constructor privado 
 //con la idea de que mi instancia de la bd sea solo una
 DBProvider._();

 Future<Database> get database async{
        //patron singlenton para garantilar que la instancia sea unica
       if(_database != null) return _database;

        //caso contrario inicilizo mi instancia
        _database = await iniciarBD();
        return _database;

 } 
  
  iniciarBD() async{

   //en esta linea garantizo obtener el pth del folder donde se va a crear mi base datos
   //con ayuda de import 'package:path_provider/path_provider.dart'; y el metodo getApplicationDocumentsDirectory
   //obtengo de manera dinamica el path por que en ios y android es diferente el ese path
   Directory documentDirectory = await getApplicationDocumentsDirectory();
    
    //aqui concateno el documentDirectory.path con el 'ScanDB.db'
    //para obtener mi full path
   final path = join(documentDirectory.path,'ScanDB.db');

   return await openDatabase(
     path,//direccion del fichero
     version: 1,//la version de mi base dato ,OJO esto significa que podemos tener mas de una basedato o version de la misma
     onOpen: (db) {}, //este evento es cuando se abre
     onCreate: (Database db,int version ) async {//aqui es donde creo la base de datos
       
       db.execute(
         'CREATE TABLE Scans ('
           ' id INTEGER PRIMARY KEY,'
           ' tipo TEXT,'
           ' valor TEXT'
          ')'
       );

     }
     
     );

  }
   
   //crear registros una variante
   nuevoScanRaw(ScanModel nuevo) async{

      final db = await database;
       
       //atento con el espacio al final de la primera linea
      final res = db.rawInsert(
           
           'INSERT INTO Scans (id,tipo,valor) '
           'VALUES (${nuevo.id},${nuevo.tipo},${nuevo.valor})'

      );

      return res;

   }
   
   //otra forma mas simple
   nuevoScan(ScanModel nuevo) async{
      
      final db = await database;
      final res = db.insert('Scans', nuevo.toJson());

      return res;

   }

}