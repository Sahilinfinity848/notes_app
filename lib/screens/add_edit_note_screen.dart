// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/storage_service.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final StorageService _storageService = StorageService();

  bool _isSaving = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _bodyController.text = widget.note!.body;
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final notes = await _storageService.getNotes();
      final now = DateTime.now();

      if (_isEditing) {
        final index = notes.indexWhere((item) => item.id == widget.note!.id);

        if (index == -1) {
          throw StateError('The note no longer exists.');
        }

        notes[index].title = _titleController.text.trim();
        notes[index].body = _bodyController.text;
        notes[index].updatedAt = now;
      } else {
        final existingIds = notes.map((note) => note.id).toSet();
        var id = now.microsecondsSinceEpoch.toString();
        while (existingIds.contains(id)) {
          id = (int.parse(id) + 1).toString();
        }

        final newNote = Note(
          id: id,
          title: _titleController.text.trim(),
          body: _bodyController.text,
          createdAt: now,
          updatedAt: now,
        );

        notes.add(newNote);
      }

      await _storageService.saveNotes(notes);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Note updated successfully!'
                : 'Note added successfully!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save note: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Note' : 'Add Note')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a note title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bodyController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Write your note here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveNote,
                  icon: const Icon(Icons.save),
                  label: Text(
                    _isSaving ? 'Saving...' : 'Save Note',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
