// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/rpe_model.dart';
import '../../models/mesures/fill_rate_model.dart';

class RpeService {
  //
  // Enregistrement
  //

  Future<void> saveToday(RpeModel model) async {
    await supabase
        .from('rpe')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  //
  // Lecture
  //
  bool hasRpeSubmitted(String joueurId) {
    return getTodayRpe(joueurId) != null;
  }

  Future<RpeModel?> getTodayRpe(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select()
        .eq('joueur_id', joueurId)
        .eq('date', today)
        .maybeSingle();

    if (data == null) return null;

    return RpeModel(
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      rpem: data['rpem'] as int,
      rpec: data['rpec'] as int,
      joueurNom: data['joueur_nom'] as String,
      joueurPrenom: data['joueur_prenom'] as String,
    );
  }

  Future<FillRateModel> getRpeFillRate() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    try {
      final allJoueurs = await supabase
          .from('joueur')
          .select('id_joueur, nom, prenom');

      final filled = await supabase
          .from('rpe')
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
      debugPrint('❌ fetchRpeFillRate error: $e');
      rethrow;
    }
  }

  Future<List<RpeModel>> getRpeHistory(String joueurId) async {
    final data = await supabase
        .from('rpe')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: true);

    return (data as List).map((e) => RpeModel.fromMap(e)).toList();
  }

  Future<List<RpeModel>> getTodayRpeAllPlayers() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select()
        .eq('date', today)
        .order('joueur_nom', ascending: true);

    return (data as List).map((e) => RpeModel.fromMap(e)).toList();
  }

  Future<List<RpeModel>> getTeamRpeRange({int days = 30}) async {
    final startStr = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .substring(0, 10);

    final data = await supabase
        .from('rpe')
        .select()
        .gte('date', startStr)
        .order('date', ascending: true);

    return (data as List).map((row) {
      return RpeModel.fromMap({
        'joueur_id': row['joueur_id'],
        'joueur_nom': row['joueur_nom'],
        'joueur_prenom': row['joueur_prenom'],
        'date': row['date'],
        'rpem': row['rpem'],
        'rpec': row['rpec'],
      });
    }).toList();
  }

  //
  // Calculs
  //

  Future<List<Map<String, dynamic>>> getTeamRpeRangeAverage({
    int days = 30,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));

    final List<dynamic> data = await supabase
        .from('rpe')
        .select('date, rpem, rpec')
        .gte('date', startDate.toIso8601String().substring(0, 10))
        .order('date', ascending: true);

    if (data.isEmpty) return [];

    final Map<String, List<Map<String, double>>> grouped = {};

    for (final e in data) {
      final date = e['date'] as String;

      grouped.putIfAbsent(date, () => []).add({
        'rpem': (e['rpem'] as num).toDouble(),
        'rpec': (e['rpec'] as num).toDouble(),
      });
    }

    return grouped.entries.map((entry) {
      final values = entry.value;

      final rpemAvg =
          values.map((e) => e['rpem']!).reduce((a, b) => a + b) / values.length;

      final rpecAvg =
          values.map((e) => e['rpec']!).reduce((a, b) => a + b) / values.length;

      return {'date': entry.key, 'rpem': rpemAvg, 'rpec': rpecAvg};
    }).toList();
  }

  Future<Map<String, double>> getTodayRpeAverages() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select('rpem, rpec')
        .eq('date', today);

    if ((data as List).isEmpty) {
      return {'rpem': 0, 'rpec': 0};
    }

    final count = data.length;

    final totals = data.fold<Map<String, int>>(
      {'rpem': 0, 'rpec': 0},
      (acc, e) => {
        'rpem': acc['rpem']! + (e['rpem'] as int),
        'rpec': acc['rpec']! + (e['rpec'] as int),
      },
    );

    return {'rpem': totals['rpem']! / count, 'rpec': totals['rpec']! / count};
  }

  Future<int> getTodayRpeTotal(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select('rpem, rpec')
        .eq('joueur_id', joueurId)
        .eq('date', today);

    if ((data as List).isEmpty) return 0;

    final total = data.fold<int>(
      0,
      (sum, e) => sum + (e['rpem'] as int) + (e['rpec'] as int),
    );

    return total;
  }
}
