import 'package:flutter/foundation.dart';

class AuthModeProvider extends ChangeNotifier {
  AuthModeProvider(this._hasAccount);
  bool _hasAccount;
  String _errorText = '';
  bool get hasAccount => _hasAccount;
  String get errorText => _errorText;
  void toggleState() {
    _hasAccount = !_hasAccount;
    _errorText = '';
    notifyListeners();
  }

  void setError(String? newError) {
    if (newError != null) {
      _errorText = newError;
      notifyListeners();
    }
  }

  void clearError() {
    _errorText = '';
    notifyListeners();
  }
}
