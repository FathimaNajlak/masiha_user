import 'package:flutter/material.dart';
import 'package:masiha_user/models/onboardings/onboarding1_model.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentPage = 0;
  int _currentSection = 1;

  int get currentPage => _currentPage;
  int get currentSection => _currentSection;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setSection(int section) {
    _currentSection = section;
    _currentPage = 0;
    notifyListeners();
  }

  void nextPage() {
    final int maxPages = _currentSection == 1
        ? onboarding1Data.length
        : _currentSection == 2
            ? onboarding2Data.length
            : onboarding3Data.length;

    if (_currentPage < maxPages - 1) {
      _currentPage++;
    } else {
      if (_currentSection < 3) {
        _currentSection++;
        _currentPage = 0;
      }
    }
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
    } else {
      if (_currentSection > 1) {
        _currentSection--;
        _currentPage = _currentSection == 1
            ? onboarding1Data.length - 1
            : onboarding2Data.length - 1;
      }
    }
    notifyListeners();
  }
}
