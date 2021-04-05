import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  DocumentSnapshot docToEdit;
  EditNote({this.docToEdit});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  void initState() {
    title = TextEditingController(text: widget.docToEdit.data()['title']);
    note = TextEditingController(text: widget.docToEdit.data()['note']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                widget.docToEdit.reference.update({
                  'title': title.text,
                  'note': note.text
                }).whenComplete(() => Navigator.pop(context));
              },
              child: Text('Save')),
          ElevatedButton(
              onPressed: () {
                widget.docToEdit.reference
                    .delete()
                    .whenComplete(() => Navigator.pop(context));
              },
              child: Text('Delete')),
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
