import 'package:flutter/material.dart';
import 'package:privacyapp/services/models.dart';

class QuizState with ChangeNotifier{
  double _progress = 0;
  option? _selected;

  final PageController controller = PageController();

  double get progress =>_progress;
  option? get selected =>_selected;

  set progress(double newvalue){
    _progress = newvalue;
    notifyListeners();
  }
  set selected(option? newvalue){
    _selected = newvalue;
    notifyListeners();
  }
  void nextPage() async {
    await controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}