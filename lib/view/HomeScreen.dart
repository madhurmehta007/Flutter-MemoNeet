
import 'package:flutter/material.dart';
import 'package:flutter_memoneet/model/Note.dart';
import 'package:flutter_memoneet/viewmodel/AuthViewModel.dart';
import 'package:flutter_memoneet/viewmodel/DataViewModel.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle sign out
              Provider.of<AuthViewModel>(context, listen: false).signOut();
              // Navigate back to login screen
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
            Expanded(
              child: NoteList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add note screen
          showDialog(
            context: context,
            builder: (BuildContext context) => AddNoteDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    DataViewModel dataViewModel = Provider.of<DataViewModel>(context, listen: false);
    return StreamBuilder<List<Note>>(
      
      
      
      stream: dataViewModel.dataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          var notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index];
              return ListTile(
                title: Text(note.text),
                 trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Delete note from Firestore
                      dataViewModel.deleteData(note.id);
                    },
                     padding: EdgeInsets.zero, // Set padding to zero
                    visualDensity: VisualDensity.compact, // Reduce padding
                  ),
                onTap: () {
                  // Navigate to edit note screen
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => EditNoteDialog(note: note),
                  );
                },
              );
            },
          );
        }
        return Center(child: Text('No notes found'));
      },
    );
  }
}

class AddNoteDialog extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note'),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(labelText: 'Note Text'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Add note
            Provider.of<DataViewModel>(context, listen: false)
                .addData(_textController.text);
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class EditNoteDialog extends StatelessWidget {
  final Note note;
  final TextEditingController _textController = TextEditingController();

  EditNoteDialog({required this.note}) : super();

  @override
  Widget build(BuildContext context) {
    _textController.text = note.text;

    return AlertDialog(
      title: Text('Edit Note'),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(labelText: 'Note Text'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Update note
            Provider.of<DataViewModel>(context, listen: false)
                .updateData(note.id, _textController.text);
            Navigator.pop(context);
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
