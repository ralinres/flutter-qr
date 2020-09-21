import 'package:flutter/material.dart';


class DespliegueMapa extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           
           appBar: AppBar(
               title: Text('Coordenas QR'),
               actions: <Widget>[
                   
                   IconButton(
                     icon: Icon(Icons.my_location),
                     onPressed: () {
                       
                     },
                     )

               ],
           ),
          body: Center(
              child: Text('Coordenas'),
          ), 

    );
  }
}