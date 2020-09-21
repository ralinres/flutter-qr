import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/despliegue_mapa.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QA Reader',
      initialRoute: 'home',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent
      ),
      routes: {
         
        '/'                : (BuildContext context) => HomePage(),
        'direcciones'      : (BuildContext context) =>DireccionesPage(),
        'mapas'            : (BuildContext context) =>MapasPage(),
         'mapa_despliegue' : (BuildContext context) =>DespliegueMapa()

      } ,
    );
  }
}