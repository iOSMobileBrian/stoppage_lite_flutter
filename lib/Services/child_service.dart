import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoppage_lite/Constants/timer_constants.dart';
import 'package:stoppage_lite/Models/child_profile.dart';
import 'package:stoppage_lite/Models/timeout_log.dart';

class ChildService extends ChangeNotifier {
  List<ChildProfile> _children = [];
  List<TimeoutLog> _logs = [];
  ChildProfile? _selectedChild;

  List<ChildProfile> get children => _children;
  List<TimeoutLog> get logs => _logs;
  ChildProfile? get selectedChild => _selectedChild;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final childrenJson = prefs.getString(kChildProfilesKey);
    if (childrenJson != null) {
      final List<dynamic> decoded = jsonDecode(childrenJson);
      _children = decoded.map((e) => ChildProfile.fromJson(e)).toList();
    }

    final logsJson = prefs.getString(kTimeoutLogsKey);
    if (logsJson != null) {
      final List<dynamic> decoded = jsonDecode(logsJson);
      _logs = decoded.map((e) => TimeoutLog.fromJson(e)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveChildren() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_children.map((e) => e.toJson()).toList());
    await prefs.setString(kChildProfilesKey, json);
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_logs.map((e) => e.toJson()).toList());
    await prefs.setString(kTimeoutLogsKey, json);
  }

  Future<void> addChild(ChildProfile child) async {
    _children.add(child);
    notifyListeners();
    await _saveChildren();
  }

  Future<void> updateChild(ChildProfile updated) async {
    final index = _children.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _children[index] = updated;
      if (_selectedChild?.id == updated.id) {
        _selectedChild = updated;
      }
      notifyListeners();
      await _saveChildren();
    }
  }

  Future<void> deleteChild(String id) async {
    _children.removeWhere((c) => c.id == id);
    _logs.removeWhere((l) => l.childId == id);
    if (_selectedChild?.id == id) {
      _selectedChild = null;
    }
    notifyListeners();
    await _saveChildren();
    await _saveLogs();
  }

  void selectChild(ChildProfile? child) {
    _selectedChild = child;
    notifyListeners();
  }

  List<TimeoutLog> logsForChild(String childId) {
    return _logs.where((l) => l.childId == childId).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> addLog(TimeoutLog log) async {
    _logs.add(log);
    notifyListeners();
    await _saveLogs();
  }

  Future<void> deleteLog(String id) async {
    _logs.removeWhere((l) => l.id == id);
    notifyListeners();
    await _saveLogs();
  }
}
