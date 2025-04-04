import 'dart:io';
import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import '../themes/themes.dart';

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
    //para armar el ui
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "NoteBook"
      ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fillColor: const Color.fromARGB(255, 207, 207, 207),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
                style: TextStyle(color: Colors.white), // Estilo del texto del buscador
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),
            ),
          ],
    ),
      ),
    );
  }
}
