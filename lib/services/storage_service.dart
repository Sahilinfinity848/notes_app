import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class StorageService {
  static const String _notesKey = 'saved_notes';

  Future<List<Note>> getNotes() async {
    final preferences = await SharedPreferences.getInstance();
    final savedData = preferences.getString(_notesKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    final decodedData = jsonDecode(savedData);
    if (decodedData is! List) {
      throw const FormatException('Saved notes must be a list.');
    }

    final notes = <Note>[];
    final ids = <String>{};

    for (var index = 0; index < decodedData.length; index++) {
      final item = decodedData[index];
      if (item is! Map) {
        throw const FormatException('Each saved note must be an object.');
      }

      final note = Note.fromJson(Map<String, dynamic>.from(item));
      var id = note.id;
      var suffix = 0;
      while (!ids.add(id)) {
        suffix++;
        id = '${note.id}-$index-$suffix';
      }

      notes.add(
        id == note.id
            ? note
            : Note(
              id: id,
              title: note.title,
              body: note.body,
              createdAt: note.createdAt,
              updatedAt: note.updatedAt,
            ),
      );
    }

    return notes;
  }

  Future<void> saveNotes(List<Note> notes) async {
    final preferences = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(notes.map((note) => note.toJson()).toList());

    await preferences.setString(_notesKey, encodedData);
  }
}
