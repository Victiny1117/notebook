import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Services {
  Future<Directory> getNotesFolder() async {
    //obtener carpeta
    final directory = await getApplicationDocumentsDirectory();
    final notesFolder = Directory('${directory.path}/notes');

    if (!await notesFolder.exists()) {
      await notesFolder.create();
    }
    return notesFolder;
  }

  Future<void> createNote(String content, String name) async {
    //crear notas
    final folder = await getNotesFolder();
    final noteFile = File('${folder.path}/$name.txt');
    await noteFile.writeAsString(content);
  }

  Future<List<File>> getNotesFiles() async {
    //obtener archivos
    final folder = await getNotesFolder();
    return folder.listSync().whereType<File>().toList();
  }

  Future<void> updateNote(File note, String newContent) async {
    //editar notas
    await note.writeAsString(newContent);
  }
}
