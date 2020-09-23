import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/modelos/scan_model.dart';

import 'package:qrreaderapp/src/utils/utils.dart' as utils;


class MapasPage extends StatelessWidget {
   
   final scanBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    
    //llamamo a esta instruccion para llenar el stream cada vez que se pinta la pagina
    scanBloc.obtenerScans();

    return StreamBuilder <List <ScanModel>>(//para manejar el stream necesito el stream builder
      stream:  scanBloc.scansStream, //este el metodo que retorna el strema ( StreamBuilder necesita un stream para consumir )
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
           
           if( !snapshot.hasData ){
                 
                 return Center(child: CircularProgressIndicator());

           }else{
            
               final data = snapshot.data;

               if(data.length == 0){
                  
                  return Center(child: Text('No hay data'));

               }

               return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                              return Dismissible( //este widget permite deslizar sus elementos izquerda o derecha
                                  key: UniqueKey(), //como la k es unica flutter tiene este metodo que las genera
                                  background: Container(color: Colors.red,),
                                  onDismissed: (direction) {//captura el dismis del Dismissible
                                    scanBloc.borrarScan(data[index].id);//utilizo el borrar de mi scan
                                  },
                                  child: ListTile(
                                          title:Text(data[index].valor),
                                          subtitle:Text('ID : ${data[index].id}') ,
                                          leading: Icon(Icons.cloud_done,color: Theme.of(context).primaryColor),//icono a inicio
                                          trailing: Icon(Icons.keyboard_arrow_right,color: Colors.grey),//icono al final
                                          onTap: () {
                                             
                                           utils.launchURL(data[index],context);


                                          },
                                      ),
                              );
                        },
                     );
           }

      },
    );
  }
}