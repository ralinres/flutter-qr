

import 'package:flutter/cupertino.dart';
import 'package:qrreaderapp/src/modelos/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(ScanModel model,BuildContext context ) async {
    
    if(model.tipo == 'http'){

        final url = model.valor;    

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

    }
    else{
      
      Navigator.pushNamed(context, 'mapa_despliegue');

    }

}