// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/grip_model.dart';
import '../../models/mesures/fill_rate_model.dart';

class GripService {
  //
  // Enregistrement
  //
  Future<void> saveToday(GripModel model) async {
    await supabase
        .from('grip')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  //
  // Lecture
  //
  bool hasGripSubmitted(String joueurId) {
    return getTodayGrip(joueurId) != null;
  }

  Future<GripModel?> getTodayGrip(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('grip')
        .select()
        .eq('joueur_id', joueurId)
        .eq('date', today)
        .maybeSingle();

    if (data == null) return null;

    return GripModel(
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      grip: data['grip'] as double,
      joueurNom: data['joueur_nom'] as String,
      joueurPrenom: data['joueur_prenom'] as String,
    );
  }

  Future<FillRateModel> getGripFillRate() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    try {
      final allJoueurs = await supabase
          .from('joueur')
          .select('id_joueur, nom, prenom');

      final filled = await supabase
          .from('grip')
          .select('joueur_id')
          .eq('date', today);

      final filledIds = (filled as List)
          .where((e) => e['joueur_id'] != null)
          .map((e) => e['joueur_id'] as String)
          .toSet();

      final missing = (allJoueurs as List)
          .where((p) => !filledIds.contains(p['id_joueur']))
          .map((p) {
            final prenom = p['prenom']?.toString() ?? '';
            final nom = p['nom']?.toString() ?? '';
            return '$prenom $nom'.trim();
          })
          .toList();

      return FillRateModel(
        total: allJoueurs.length,
        filled: filledIds.length,
        missingPlayers: missing,
      );
    } catch (e) {
      debugPrint('❌ fetchgripFillRate error: $e');
      rethrow;
    }
  }

  Future<List<GripModel>> getGripHistory(String joueurId) async {
    final data = await supabase
        .from('grip')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: true);

    return (data as List).map((e) => GripModel.fromMap(e)).toList();
  }

  Future<List<GripModel>> getTodayGripAllPlayers() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('grip')
        .select()
        .eq('date', today)
        .order('joueur_nom', ascending: true);

    return (data as List).map((e) => GripModel.fromMap(e)).toList();
  }

  Future<List<GripModel>> getTeamGripRange({int days = 30}) async {
    final startStr = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .substring(0, 10);

    final data = await supabase
        .from('grip')
        .select()
        .gte('date', startStr)
        .order('date', ascending: true);

    return (data as List).map((row) {
      return GripModel.fromMap({
        'joueur_id': row['joueur_id'],
        'joueur_nom': row['joueur_nom'],
        'joueur_prenom': row['joueur_prenom'],
        'date': row['date'],
        'grip': row['grip'],
      });
    }).toList();
  }

  //
  // Calculs
  //

  Future<List<Map<String, dynamic>>> getTeamGripRangeAverage({
    int days = 30,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));

    final List<dynamic> data = await supabase
        .from('grip')
        .select('date, grip')
        .gte('date', startDate.toIso8601String().substring(0, 10))
        .order('date', ascending: true);

    if (data.isEmpty) {
      return [
        {'grip': 0.0},
      ];
    }

    final Map<String, List<Map<String, double>>> grouped = {};

    for (final e in data) {
      final date = e['date'] as String;

      grouped.putIfAbsent(date, () => []).add({
        'grip': (e['grip'] as num).toDouble(),
      });
    }

    return grouped.entries.map((entry) {
      final values = entry.value;

      final gripAvg =
          values.map((e) => e['grip']!).reduce((a, b) => a + b) / values.length;

      return {'date': entry.key, 'grip': gripAvg};
    }).toList();
  }

  Future<Map<String, double>> getTodayGripAverages() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase.from('grip').select('grip').eq('date', today);

    if ((data as List).isEmpty) {
      return {'grip': 0};
    }

    final count = data.length;

    final totals = data.fold<Map<String, double>>({
      'grip': 0,
    }, (acc, e) => {'grip': acc['grip']! + (e['grip'] as double)});

    return {'grip': totals['grip']! / count};
  }

  Future<Map<String, double>> getTodayGripMinMax() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('grip')
        .select('grip')
        .eq('date', today)
        .order('grip', ascending: true);

    if (data.isNotEmpty) {
      final gripMin = data.first['grip'];
      final gripMax = data.last['grip'];

      return {'gripMin': gripMin, 'gripMax': gripMax};
    } else {
      return {'gripMin': 0, 'gripMax': 0};
    }
  }

  Future<double> getTodayGripTotal(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('grip')
        .select('grip')
        .eq('joueur_id', joueurId)
        .eq('date', today);

    if ((data as List).isEmpty) return 0;

    final total = data.fold<double>(0, (sum, e) => sum + (e['grip'] as double));

    return total;
  }
}
