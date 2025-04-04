import 'dart:io';
import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import '../themes/themes.dart';

class NoteDetailScreen extends StatelessWidget {
  final File note;

  NoteDetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.path.split('/').last),
      ),
      body: FutureBuilder<String>(
        future: note.readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar la nota'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data ?? ''),
            );
          }
        },
      ),
    );
  }
}

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
    setState(() {
      notes = files;
    });
  }

  Future<void> _createNote() async {
    final noteName = 'Nueva Nota';
    await serv.createNote("Nueva nota creada desde la app.", noteName);
    loadNotes(); // Recargar lista de notas
  }

  Widget build(BuildContext context) {
    //para armar el ui
    final filteredNotes = notes.where((note) {
      final title = note.path.split('/').last; //nombre del archivo
      return title.toLowerCase().contains(search.toLowerCase()); //filtrar por búsqueda
    }).toList();
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
                style: TextStyle(color: Colors.white),
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
      body: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          final title = note.path.split('/').last;

          return ListTile(
            leading: Icon(Icons.text_snippet),
            title: Text(title),
            subtitle: Text('Sin archivar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(note: note),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
        onPressed: () {
          // Agregar nueva nota
          _createNote();
        },
        child: Icon(Icons.add),
            ),
    ),
    Positioned(
      left: 13,
      bottom: 1,
      child: FloatingActionButton(
        onPressed: () {
          Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
        },
        child: Icon(Icons.light),
      ),
      ),
        ]
      ),
    );
  }
}
