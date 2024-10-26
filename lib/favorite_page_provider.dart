import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavouriteScreenProvider with ChangeNotifier {
  bool _drawingBoard = false;
  bool get drawingBoard => _drawingBoard;

  List<int> _selectedItemList = [];
  List<int> get selectedItemList => _selectedItemList;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FavouriteScreenProvider() {
    loadFromFirebase();
  }

  void setDrawingBoard() {
    _drawingBoard = !_drawingBoard;
    notifyListeners();
    saveToFirebase();
  }

  void setList(int item) {
    if (!_selectedItemList.contains(item)) {
      _selectedItemList.add(item);
      notifyListeners();
      saveToFirebase();
    }
  }

  void removeList(int item) {
    _selectedItemList.remove(item);
    notifyListeners();
    saveToFirebase();
  }

  Future<void> loadFromFirebase() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _drawingBoard = data['drawingBoard'] ?? false;
          _selectedItemList = List<int>.from(data['selectedItemList'] ?? []);
        } else {
          // If the document doesn't exist, create it with default values
          await saveToFirebase();
        }
        notifyListeners();
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error loading favorites: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  Future<void> saveToFirebase() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'drawingBoard': _drawingBoard,
          'selectedItemList': _selectedItemList,
        }, SetOptions(merge: true));
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error saving favorites: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }
}
