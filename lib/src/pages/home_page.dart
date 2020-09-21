import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/modelos/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   
   final scanBloc = ScansBloc();
   int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
             title: Center(child: Text('QR Scanner')),
             actions: <Widget>[
               IconButton(
                 icon: Icon(Icons.delete_forever),
                 onPressed: () {
                    scanBloc.borrarScanTodos();
                 },
                 )
             ],
           ),
           body: _llamarPagina(_currentPage),           
           bottomNavigationBar: _crearBottonNavigationBar(),//mi metodo para crear la barra de abajo,

           floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //posicion del botton

           floatingActionButton: FloatingActionButton(
                child: Icon(Icons.filter_center_focus),
                backgroundColor: Theme.of(context).primaryColor, //esto es el color primario del tema de mi app ( esta config en e main )
                onPressed:   _escanearQR(context), //este es mi metodo
                ),
    );
  }

  _escanearQR(BuildContext context) async{
       
       //https://www.udemy.com
       // geo:40.70653777163278,-73.99495497187503
 
       try{
             
         var value = await BarcodeScanner.scan(); 
         String result = value.rawContent;
         print(' Este es el resultado: ${value.rawContent}');//bar code contentn

         if( result != null){
            
            final nuevo = ScanModel(valor: result);
            scanBloc.agregarScans(nuevo);
              
              //es funcion me permite saber Sistema Operati en este caso ( ios )
              //es que el lunch responde muy rapido en ios por lo que necesito retrasarlo un poco
              if( Platform.isIOS ){
                   Future.delayed(Duration(milliseconds: 700),(){
                         
                      utils.launchURL(nuevo,context);

                   });
              }else{
                
                 utils.launchURL(nuevo,context);

              }

         }

       }catch( e ){
          
          print( e.toString());

       }  
    }
  

  Widget _llamarPagina( int paginaActual){
       
       switch (paginaActual) {
         case 0: return MapasPage();
         case 1: return DireccionesPage();
         
         default:
            return MapasPage();
       }



  }

  Widget  _crearBottonNavigationBar(){
          
          return BottomNavigationBar(//crea la barra
            items: [
                 BottomNavigationBarItem(//item 0
                      icon: Icon(Icons.map),
                      title: Text('Mapas')
                 ),
                  BottomNavigationBarItem(//item 1
                      icon:Icon(Icons.brightness_5),
                      title: Text('Direcciones'),                    
                 )

            ],
            currentIndex: _currentPage,//elemento activo
            onTap: (index) {
               
               setState(() {
                 
                _currentPage = index;

               });

            },

            );
     
  }
}