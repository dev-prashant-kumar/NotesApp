import 'package:isar/isar.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase {
  static late Isar isar;

  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  final List<Note> currentNotes = [];

  Future<void>addNote(String textfromUser) async{
    final newNote = Note()..text = textfromUser;

    await isar.writeTxn(()=> isar.notes.put(newNote));
  }

  Future<void>fetchNotes() async{
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
  }
  

}