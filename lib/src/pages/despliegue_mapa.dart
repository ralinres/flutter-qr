import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/modelos/scan_model.dart';



class DespliegueMapa extends StatefulWidget {
    
  @override
  _DespliegueMapaState createState() => _DespliegueMapaState();
}

class _DespliegueMapaState extends State<DespliegueMapa> {
  
   final _mapController = new MapController();

   String tipomapa = 'streets-v11';
   String title = "Hola";
   

  @override
  Widget build(BuildContext context) {
     
     //asi obtengo parametros enviados por la url
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
           
           appBar: AppBar(
                title: Text('Coordenas QR'),
                actions: <Widget>[
                    
                    IconButton(
                      icon: Icon(Icons.my_location),
                      tooltip: title,
                      onPressed: () {
                          
                          _mapController.move(scan.getLatLng(), 15);//de esta forma  muevo la lat y la lng de manera dinamica
                         
                      },
                      )

                ],
              ),
          body: _crearFlutterMap(scan),
          floatingActionButton: _crearBottonFlotante(context,scan), 

    );
  }

    Widget  _crearBottonFlotante( BuildContext context ,ScanModel scan){
             

          return FloatingActionButton(
              child: Icon(Icons.repeat),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                    
                                    
                    if(tipomapa == 'streets-v11'){
                         
                         tipomapa = "light-v10";

                    }else if(tipomapa == 'light-v10'){
                         
                         tipomapa = "satellite-v9"; 

                    }else if(tipomapa == 'satellite-v9'){
                         
                         tipomapa = "outdoors-v11";   

                    }else if(tipomapa == 'outdoors-v11'){
                         
                         tipomapa = "dark-v10"; 

                    }
                    else{
                         
                          tipomapa = "streets-v11";  

                    }

                 setState(() {});

                  //movimiento #1 al maximo de zoom
                  _mapController.move(scan.getLatLng(), 30);
              
                  //Regreso al Zoom Deseado después de unos Milisegundos
                  Future.delayed(Duration(milliseconds: 50),(){
                    _mapController.move(scan.getLatLng(), 15);
                  });
                 

              },
            );


    }

    Widget  _crearFlutterMap(ScanModel scan){
           
             //widget del pakt flutter_map para generar el mapa
             return FlutterMap(
                  mapController: _mapController, //seteo el controllador del map
                  options: MapOptions(
                       center: scan.getLatLng(),
                       zoom: 15
                  ),
                  layers: [
                    
                    _crearMapa(),
                    _crearMarcadores(scan)

                  ],
               );


    }

      _crearMarcadores(ScanModel scan){
            
            return MarkerLayerOptions(

                markers: <Marker>[
                     Marker(
                       height: 120.0,
                       width:  120.0,
                       point: scan.getLatLng(),//coordenadas del marcador
                       builder: (context) => Container(//en la propiedad builder puedo pintar lo que quiero que se vea en ese punto, en este caso un container con un icono
                         child:Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                            size: 60.0,
                           ),                       
                         
                        )   
                    )

                ]

            );

      }

      _crearMapa(){
           //otros tipos de mapas (streets ( el actual) ,dark,ligth,outdoors,satellite  )
               
               return TileLayerOptions(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/' 
                                '{z}/{x}/{y}?access_token={accessToken}', 
                  additionalOptions: {
                       'accessToken':'pk.eyJ1IjoicmFsaW5yZXMiLCJhIjoiY2tmZTQ0NzN5MDE4ODMxanhzOTNmbmtzdSJ9.hUDfhbG4-fmXJ2NP3X0znA',
                       'id': 'mapbox/$tipomapa'   
                       }
                    );

            
               //este es con otro proveedor de mapas 
              // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              // subdomains: ['a', 'b', 'c']
                 
                 //estos son los id actuales
                // mapbox/streets-v11
                // mapbox/outdoors-v11
                // mapbox/light-v10
                // mapbox/dark-v10
                // mapbox/satellite-v9
                // mapbox/satellite-streets-v11
      }
}