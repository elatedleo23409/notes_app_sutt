import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesapp_sutt/DatabaseServices.dart';

class AddNote extends StatelessWidget {
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('notes');

  Databaseservices db = Databaseservices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () async {
                final notesqlite = Notemodel(
                  title: title.text,
                  content: note.text,
                );
                await db.insertNote(notesqlite);

                print(await db.notetable());

                ref.add({'title': title.text, 'note': note.text}).whenComplete(
                    () => Navigator.pop(context));
              },
              child: Text('Save')),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: title,
                decoration: InputDecoration(hintText: 'Title'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                  controller: note,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(hintText: 'Note'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
