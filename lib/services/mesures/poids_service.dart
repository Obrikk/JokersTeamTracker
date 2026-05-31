// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/poids_model.dart';
import '../../models/mesures/fill_rate_model.dart';

class PoidsService {
  //
  // Enregistrement
  //
  Future<void> saveToday(PoidsModel model) async {
    await supabase
        .from('poids')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  //
  // Lecture
  //
  bool hasPoidsSubmitted(String joueurId) {
    return getTodayPoids(joueurId) != null;
  }

  Future<PoidsModel?> getTodayPoids(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('poids')
        .select()
        .eq('joueur_id', joueurId)
        .eq('date', today)
        .maybeSingle();

    if (data == null) return null;

    return PoidsModel(
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      poids: data['poids'] as double,
      joueurNom: data['joueur_nom'] as String,
      joueurPrenom: data['joueur_prenom'] as String,
    );
  }

  Future<FillRateModel> getPoidsFillRate() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    try {
      final allJoueurs = await supabase
          .from('joueur')
          .select('id_joueur, nom, prenom');

      final filled = await supabase
          .from('poids')
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
      debugPrint('❌ fetchPoidsFillRate error: $e');
      rethrow;
    }
  }

  Future<List<PoidsModel>> getPoidsHistory(String joueurId) async {
    final data = await supabase
        .from('poids')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: true);

    return (data as List).map((e) => PoidsModel.fromMap(e)).toList();
  }

  Future<List<PoidsModel>> getTodayPoidsAllPlayers() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('poids')
        .select()
        .eq('date', today)
        .order('joueur_nom', ascending: true);

    return (data as List).map((e) => PoidsModel.fromMap(e)).toList();
  }

  Future<List<PoidsModel>> getTeamPoidsRange({int days = 30}) async {
    final startStr = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .substring(0, 10);

    final data = await supabase
        .from('poids')
        .select()
        .gte('date', startStr)
        .order('date', ascending: true);

    return (data as List).map((row) {
      return PoidsModel.fromMap({
        'joueur_id': row['joueur_id'],
        'joueur_nom': row['joueur_nom'],
        'joueur_prenom': row['joueur_prenom'],
        'date': row['date'],
        'poids': row['poids'],
      });
    }).toList();
  }

  //
  // Calculs
  //

  Future<List<Map<String, dynamic>>> getTeamPoidsRangeAverage({
    int days = 30,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));

    final List<dynamic> data = await supabase
        .from('poids')
        .select('date, poids')
        .gte('date', startDate.toIso8601String().substring(0, 10))
        .order('date', ascending: true);

    if (data.isEmpty) {
      return [
        {'poids': 0.0},
      ];
    }

    final Map<String, List<Map<String, double>>> grouped = {};

    for (final e in data) {
      final date = e['date'] as String;

      grouped.putIfAbsent(date, () => []).add({
        'poids': (e['poids'] as num).toDouble(),
      });
    }

    return grouped.entries.map((entry) {
      final values = entry.value;

      final poidsAvg =
          values.map((e) => e['poids']!).reduce((a, b) => a + b) /
          values.length;

      return {'date': entry.key, 'poids': poidsAvg};
    }).toList();
  }

  Future<Map<String, double>> getTodayPoidsAverages() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase.from('poids').select('poids').eq('date', today);

    if ((data as List).isEmpty) {
      return {'poids': 0};
    }

    final count = data.length;

    final totals = data.fold<Map<String, double>>({
      'poids': 0,
    }, (acc, e) => {'poids': acc['poids']! + (e['poids'] as double)});

    return {'poids': totals['poids']! / count};
  }

  Future<Map<String, double>> getTodayPoidsMinMax() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('poids')
        .select('poids')
        .eq('date', today)
        .order('poids', ascending: true);

    if (data.isNotEmpty) {
      final poidsMin = data.first['poids'];
      final poidsMax = data.last['poids'];

      return {'poidsMin': poidsMin, 'poidsMax': poidsMax};
    } else {
      return {'poidsMin': 0, 'poidsMax': 0};
    }
  }

  Future<double> getTodayPoidsTotal(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('poids')
        .select('poids')
        .eq('joueur_id', joueurId)
        .eq('date', today);

    if ((data as List).isEmpty) return 0;

    final total = data.fold<double>(
      0,
      (sum, e) => sum + (e['poids'] as double),
    );

    return total;
  }
}
