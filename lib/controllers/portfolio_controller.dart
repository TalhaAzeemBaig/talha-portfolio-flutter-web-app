import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ContactStatus { idle, sending, success, error }

class PortfolioController extends ChangeNotifier {
  // Selected category for filtering projects
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Current visible section on scroll (used to highlight navigation items)
  String _activeSection = 'Home';
  String get activeSection => _activeSection;

  void setActiveSection(String section) {
    if (_activeSection != section) {
      _activeSection = section;
      notifyListeners();
    }
  }

  // Global Keys for each section of the single-page application
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  // Smooth scroll to target section context
  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // Contact form submission status
  ContactStatus _contactStatus = ContactStatus.idle;
  ContactStatus get contactStatus => _contactStatus;

  Future<bool> submitContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || message.trim().isEmpty) {
      _contactStatus = ContactStatus.error;
      notifyListeners();
      return false;
    }

    _contactStatus = ContactStatus.sending;
    notifyListeners();

    try {
      // Simulate network request latency
      await Future.delayed(const Duration(milliseconds: 1800));
      _contactStatus = ContactStatus.success;
      notifyListeners();
      
      // Auto-reset state after showing success message
      Future.delayed(const Duration(seconds: 4), () {
        _contactStatus = ContactStatus.idle;
        notifyListeners();
      });
      return true;
    } catch (_) {
      _contactStatus = ContactStatus.error;
      notifyListeners();
      return false;
    }
  }
}

final portfolioControllerProvider = ChangeNotifierProvider<PortfolioController>((ref) {
  return PortfolioController();
});
