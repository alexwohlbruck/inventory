// Model for navigation history  
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class NavigationModel extends Model {
  Queue _navigationStack = Queue();

  Queue get navigationStack => _navigationStack;

  void advanceHistory(DocumentSnapshot group) {
    // Add a new group to the navigation history
    _navigationStack.addLast(group);
    notifyListeners();
  }

  void regressHistory() {
    _navigationStack.removeLast();
    notifyListeners();
  }
}