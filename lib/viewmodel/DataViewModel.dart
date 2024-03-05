import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memoneet/model/Note.dart';

class DataViewModel extends ChangeNotifier {
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('data');

   Stream<List<Note>> get dataStream {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    
    // Return data stream with query for notes by current user
    return _dataCollection
        .where('user', isEqualTo: user?.email) // Filter documents by user ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note(
          id: doc.id,
          text: doc['data'] ?? '',
          user: doc['user'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> addData(String newData) async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Add note with user information
        await _dataCollection.add({
          'data': newData,
          'user': user.email, // Add user ID as the user field
        });
        notifyListeners();
      } else {
        // Handle error when user is null
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateData(String id, String newData) async {
    try {
      await _dataCollection.doc(id).update({'data': newData});
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteData(String id) async {
    try {
      await _dataCollection.doc(id).delete();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
