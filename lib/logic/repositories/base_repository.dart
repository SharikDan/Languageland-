import 'dart:async';
import 'package:flutter/foundation.dart';

abstract class BaseRepository {
  Timer? _saveDebounce;
  bool _isSaving = false;
  bool _needsResave = false;

  /// Атомарное сохранение (защита от race condition)
  Future<void> saveData();

  /// Планирует сохранение с задержкой (батчинг)
  void scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 200), () {
      save().catchError((e) => debugPrint('⚠️ Save failed: $e'));
    });
  }

  Future<void> save() async {
    if (_isSaving) {
      _needsResave = true;
      return;
    }
    _isSaving = true;
    try {
      do {
        _needsResave = false;
        await saveData();
      } while (_needsResave);
    } catch (e) {
      debugPrint('❌ Save error: $e');
      rethrow;
    } finally {
      _isSaving = false;
    }
  }
}