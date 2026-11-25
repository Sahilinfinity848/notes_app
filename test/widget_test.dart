import 'dart:convert';

// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:notes_app/main.dart';
import 'package:notes_app/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows an empty notes state', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('No notes yet.'), findsOneWidget);
  });

  testWidgets('adds, edits, searches, and deletes a note', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'First note');
    await tester.enterText(find.byType(TextFormField).at(1), 'First body');
    await tester.tap(find.text('Save Note'));
    await tester.pumpAndSettle();

    expect(find.text('First note'), findsOneWidget);
    expect(find.text('First body'), findsOneWidget);

    final originalNote = (await StorageService().getNotes()).single;

    await tester.enterText(find.byType(TextField), 'first');
    await tester.pumpAndSettle();
    expect(find.text('First note'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pumpAndSettle();
    expect(find.text('No matching notes found.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    await tester.tap(find.text('First note'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Updated note');
    await tester.enterText(find.byType(TextFormField).at(1), 'Updated body');
    await tester.tap(find.text('Save Note'));
    await tester.pumpAndSettle();

    expect(find.text('Updated note'), findsOneWidget);
    expect(find.text('First note'), findsNothing);

    final updatedNote = (await StorageService().getNotes()).single;
    expect(updatedNote.createdAt, originalNote.createdAt);
    expect(updatedNote.updatedAt.isAfter(originalNote.updatedAt), isTrue);

    await tester.tap(find.byTooltip('Delete note'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.textContaining('No notes yet.'), findsOneWidget);
  });

  test('loads notes saved by the previous description-based format', () async {
    SharedPreferences.setMockInitialValues({
      'saved_notes': jsonEncode([
        {'title': 'Legacy note', 'description': 'Kept from the previous app'},
      ]),
    });

    final notes = await StorageService().getNotes();

    expect(notes, hasLength(1));
    expect(notes.single.title, 'Legacy note');
    expect(notes.single.body, 'Kept from the previous app');
    expect(notes.single.id, isNotEmpty);
    expect(notes.single.createdAt, notes.single.updatedAt);
  });
}
