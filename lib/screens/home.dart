import 'package:flutter/material.dart';
import 'dart:io';
import '../services/services.dart';

class HomeScreen extends StatefulWidget {

  @override

  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  List<File> notes = []; //lista de archivos de notas
  String search = "";
  Services serv = Services();
  
  @override 
    void initState() {
      super.initState();
      loadNotes();
    }
    Future<void> loadNotes() async {
      final files = await serv.getNotesFiles();
      notes = files;
    }
    
  Widget build(BuildContext context) {
    return Scaffold (

    );
  }
}