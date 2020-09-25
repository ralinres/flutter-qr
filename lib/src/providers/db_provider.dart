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
   
   //crear registros (una variante) no se va a usar pero para saber que existe
   nuevoScanRaw(ScanModel nuevo) async{

      final db = await database;
       
       //atento con el espacio al final de la primera linea
      final res = db.rawInsert(
           
           "INSERT INTO Scans (id,tipo,valor) "
           "VALUES ( ${nuevo.id}, '${nuevo.tipo}', '${nuevo.valor}')"

      );

      return res;

   }
   
   //otra forma mas simple ( es la que se va a usar)
   nuevoScan(ScanModel nuevo) async{
      
      final db  = await database; //await por que retona un future
      final res = await db.insert('Scans', nuevo.toJson());

      return res;

   }

   //select -Obtener Informacion

   Future<ScanModel> getScanId(int id) async{
        
       final db = await database;
       
       //el ? significa que el id es pasado por parametro y en el whereArgs paso una lista con el respectivo valor 
       final res = await db.query('Scans',where: 'id = ?',whereArgs: [id]);
        
        //el res retorna un un map por lo que necesiro el primer elemento y con el constructor
        //ScanModel.fromJson retorno un ScanModel ,caso conttrario retorno null
       return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;


   }

   Future <List<ScanModel>> getTodosScans() async{
     
       final db = await database;
       final res = await db.query('Scans' );
       
       //recorro la lista y los convirto a ScanModel
       List<ScanModel> list = res.isNotEmpty ? res.map((element) => ScanModel.fromJson(element)).toList() : [];
       
       return list;
   }

     Future <List<ScanModel>> getScansPorTipo( String tipo ) async{
     
       final db = await database;
       final res = await db.query('Scans',where: 'tipo = ?',whereArgs: [tipo]);
       
       //recorro la lista y los convirto a ScanModel
       List<ScanModel> list = res.isNotEmpty ? res.map((element) => ScanModel.fromJson(element)).toList() : [];
       
       return list;
   }

   //actualizar registros retorna registos afectados
   Future<int> updateScan( ScanModel nuevoScan ) async{
      
      final db  = await database; //await por que retona un future
      final res = await db.update('Scans', nuevoScan.toJson(),where: 'id = ?',whereArgs: [nuevoScan.id]);
       
      return res; 
   }

      //eliminar scan
   Future<int> deleteScan( int id ) async{
      
      final db  = await database; //await por que retona un future
      
      //ojo si aqui no paso el where y dejo la tabla borra la tabla de la base dato
      final res = await db.delete('Scans',where: 'id = ?',whereArgs: [id]);
       
      return res; 
   }

         //eliminar scan
   Future<int> deleteByTipe( String tipe ) async{
      
      final db  = await database; //await por que retona un future
      
      //ojo si aqui no paso el where 
      final res = await db.delete('Scans',where: 'tipo = ?',whereArgs: [tipe]);
       
      return res; 
   }
    
      
      //eliminar todos los argumentos de la tabla
      Future<int> deleteAll( ) async{
      
      final db  = await database; //await por que retona un future
      
      //rawDelete de esta forma recibe el delete en sql
      final res = await db.rawDelete('DELETE from Scans');
       
      return res; 
   }



}