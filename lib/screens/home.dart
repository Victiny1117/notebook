import 'dart:io';
import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import '../themes/themes.dart';
import 'package:image_picker/image_picker.dart';

class NoteDetailScreen extends StatefulWidget { //editor de notas
  File note;
  final Function refreshNotesCallback;

  NoteDetailScreen({required this.note, required this.refreshNotesCallback});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _contentController;
  late TextEditingController _renameController;
  File? attachedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _renameController = TextEditingController(text: widget.note.path.split('/').last.split('.').first);

    loadNoteContent();
    loadAttachedImage();
  }

  Future<void> loadNoteContent() async {
    try {
      final content = await widget.note.readAsString();
      setState(() {
        _contentController.text = content;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar la nota: ${error.toString()}')),
      );
    }
  }

  Future<void> loadAttachedImage() async {
    final directory = widget.note.parent;
    final imageFile = File('${directory.path}/${_renameController.text}_image.jpg');
    if (await imageFile.exists()) {
      setState(() {
        attachedImage = imageFile;
      });
    }
  }

  Future<void> saveNote() async {
    try {
      await widget.note.writeAsString(_contentController.text);
      widget.refreshNotesCallback();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nota guardada correctamente')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la nota: ${error.toString()}')),
      );
    }
  }

  Future<void> renameNote() async {
    final newName = _renameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El nombre de la nota no puede estar vacío.')),
      );
      return;
    }

    final directory = widget.note.parent;
    final newFilePath = '${directory.path}/$newName.txt';
    final newFile = File(newFilePath);

    if (await newFile.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya existe una nota con este nombre.')),
      );
      return;
    }

    try {
      await widget.note.rename(newFilePath);
      setState(() {
        widget.note = newFile;
      });
      widget.refreshNotesCallback();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nota renombrada a $newName.txt')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al renombrar la nota: ${error.toString()}')),
      );
    }
  }

  Future<void> attachImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final directory = widget.note.parent;
        final imageFile = File('${directory.path}/${_renameController.text}_image.jpg');

        await File(pickedFile.path).copy(imageFile.path);
        setState(() {
          attachedImage = imageFile;
        });

        widget.refreshNotesCallback();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagen adjuntada a la nota.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al adjuntar la imagen: ${error.toString()}')),
      );
    }
  }

  Future<void> deleteNote() async {
    try {
      if (await widget.note.exists()) {
        await widget.note.delete();
      }

      final directory = widget.note.parent;
      final imageFile = File('${directory.path}/${_renameController.text}_image.jpg');
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      
      widget.refreshNotesCallback();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nota y la imagen asociada eliminadas.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la nota: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Nota'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveNote, // Guardar cambios
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteNote, // Eliminar nota
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _renameController,
                decoration: InputDecoration(labelText: 'Cambiar Nombre'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: renameNote,
                icon: Icon(Icons.edit),
                label: Text('Renombrar Nota'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Contenido de la Nota',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: attachImage,
                icon: Icon(Icons.image),
                label: Text('Adjuntar Imagen'),
              ),
              if (attachedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.file(attachedImage!),
                ),
            ],
          ),
        ),
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
  Color iconColor = Colors.black;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final files = await serv.getNotesFiles();
    setState(() {
      notes = files.where((file) => !file.path.endsWith('.jpg')).toList();
    });
  }

  Future<void> _createNote() async {
    final noteName = 'Nueva Nota_${DateTime.now().millisecondsSinceEpoch}';
    await serv.createNote("Nueva nota creada desde la app.", noteName);
    loadNotes();
  }

  Widget build(BuildContext context) {
    //para armar el ui
    final filteredNotes =
        notes.where((note) {
          final title = note.path.split('/').last; //nombre del archivo
          return title.toLowerCase().contains(
            search.toLowerCase(),
          ); //filtrar por búsqueda
        }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text("NoteBook")),
            SizedBox(width: 10),
            IconButton(
        icon: Icon(Icons.light, color: iconColor),
        onPressed: () {
          Provider.of<ThemeNotifier>(
                  context,
                  listen: false,
                ).toggleTheme();
                setState(() {
                  iconColor = (iconColor == Colors.black) ? Colors.white : Colors.black;
                });
        },
      ),
            Expanded(
              flex: 3,
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
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
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
            subtitle: Text(""),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(note: note, refreshNotesCallback: loadNotes,),
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
                _createNote();
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
