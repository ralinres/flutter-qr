import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QA Reader',
      initialRoute: 'home',
      routes: {
         
         '/' : (BuildContext context) => HomePage()

      } ,
    );
  }
}