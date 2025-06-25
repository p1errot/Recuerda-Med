import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';

  // Singleton pattern
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  // In-memory cache
  int? _userId;
  String? _username;
  String? _email;

  // Getters
  Future<int?> get userId async => _userId ?? await _getUserId();
  Future<String?> get username async => _username ?? await _getUsername();
  Future<String?> get email async => _email ?? await _getEmail();

  // Store user session data
  Future<void> saveUserSession(int userId, String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
    
    // Update memory cache
    _userId = userId;
    _username = username;
    _email = email;
  }

  // Clear user session data (logout)
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    
    // Clear memory cache
    _userId = null;
    _username = null;
    _email = null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final userId = await this.userId;
    return userId != null;
  }

  // Private methods to retrieve from SharedPreferences
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> _getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }
}
