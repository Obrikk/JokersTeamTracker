import 'package:flutter/material.dart';

import '../../../services/user/joueur_service.dart';
import '../../../services/mesures/wellness_service.dart';
import '../../../models/mesures/wellness_model.dart';

import '../../../core/constants/supabase_constants.dart';

class WellnessForm extends StatefulWidget {
  @override
  State<WellnessForm> createState() => _WellnessFormState();

  const WellnessForm({super.key});
}

class _WellnessFormState extends State<WellnessForm> {
  // Services Wellness => loadWellness, saveWellness
  final WellnessService _wellnessService = WellnessService();

  // Services Joueur => userId vers joueurId
  final JoueurService _joueurService = JoueurService();
  late Future<WellnessModel?> _wellnessFuture;

  // Variables du wellness
  final userId = supabase.auth.currentUser!.id;
  double _wellnessTotal = 0;

  double _sommeil = 0;
  double _humeur = 0;
  double _energie = 0;
  double _courbatures = 0;
  double _stress = 0;

  @override
  initState() {
    super.initState();
    _wellnessFuture = _loadWellness();
  }

  // Initialiser le wellness
  Future<WellnessModel?> _loadWellness() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final wellness = await _wellnessService.getTodayWellness(joueurId);

    if (wellness != null) {
      setState(() {
        _sommeil = wellness.sommeil;
        _humeur = wellness.humeur;
        _energie = wellness.energie;
        _courbatures = wellness.courbatures;
        _stress = wellness.stress;
        _wellnessTotal =
            wellness.sommeil +
            wellness.humeur +
            wellness.energie +
            wellness.courbatures +
            wellness.stress;
      });
    }

    return wellness;
  }

  // Enregistrer wellness bdd
  Future<void> _saveWellness() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final joueurNom = await _joueurService.getPlayerNom(userId);
    final joueurPrenom = await _joueurService.getPlayerPrenom(userId);

    final model = WellnessModel(
      joueurId: joueurId,
      date: DateTime.now(),
      sommeil: _sommeil,
      humeur: _humeur,
      energie: _energie,
      courbatures: _courbatures,
      stress: _stress,
      joueurNom: joueurNom,
      joueurPrenom: joueurPrenom,
    );
    await _wellnessService.saveToday(model);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carte Wellness
        Card(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // En tête
                    Text(
                      'Wellness :',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Etat de forme | 0 - 5',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Appel création de la carte
                _buildWellnessSection(),
                const SizedBox(height: 32),
                SizedBox(
                  // Bouton Sauvegarde
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveWellness();
                      _wellnessFuture = _loadWellness();
                    },
                    child: const Text('Enregistrer Wellness'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Initialisation Carte
  Widget _buildWellnessSection() {
    return FutureBuilder<WellnessModel?>(
      future: _wellnessFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        final wellness = snapshot.data;
        if (wellness == null) {
          return _buildNoWellnessCard();
        }

        return _buildWellnessCard(wellness, _wellnessTotal);
      },
    );
  }

  // Création Carte n°3
  Widget _buildWellnessCard(WellnessModel wellness, double wellnessTotal) {
    return Row(
      children: [
        // Affichage des barres progressives
        Expanded(
          child: Column(
            children: [
              MetricRow(
                label: 'Sommeil',
                icon: Icons.nights_stay,
                initialValue: _sommeil,
                onChanged: (val) {
                  setState(() => _sommeil = val);
                },
              ),
              MetricRow(
                label: 'Humeur',
                icon: Icons.mood,
                initialValue: _humeur,
                onChanged: (val) {
                  setState(() => _humeur = val);
                },
              ),
              MetricRow(
                label: 'Énergie',
                icon: Icons.bolt,
                initialValue: wellness.energie,
                onChanged: (val) {
                  setState(() => _energie = val);
                },
              ),
              MetricRow(
                label: 'Courbatures',
                icon: Icons.fitness_center,
                initialValue: wellness.courbatures,
                onChanged: (val) {
                  setState(() => _courbatures = val);
                },
              ),
              MetricRow(
                label: 'Stress',
                icon: Icons.cached,
                initialValue: wellness.stress,
                onChanged: (val) {
                  setState(() => _stress = val);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Création Carte Vide n°3
  Widget _buildNoWellnessCard() {
    return Expanded(
      // Affichage des barres progressives
      child: Column(
        children: [
          MetricRow(
            label: 'Sommeil',
            icon: Icons.nights_stay,
            initialValue: _sommeil,
            onChanged: (val) => setState(() => _sommeil = val),
          ),
          MetricRow(
            label: 'Humeur',
            icon: Icons.mood,
            initialValue: _humeur,
            onChanged: (val) => setState(() => _humeur = val),
          ),
          MetricRow(
            label: 'Énergie',
            icon: Icons.bolt,
            initialValue: _energie,
            onChanged: (val) => setState(() => _energie = val),
          ),
          MetricRow(
            label: 'Courbatures',
            icon: Icons.fitness_center,
            initialValue: _courbatures,
            onChanged: (val) => setState(() => _courbatures = val),
          ),
          MetricRow(
            label: 'Stress',
            icon: Icons.cached,
            initialValue: _stress,
            onChanged: (val) => setState(() => _stress = val),
          ),
        ],
      ),
    );
  }
}

//Définition classe des barres progressives
class MetricRow extends StatefulWidget {
  final String label;
  final double initialValue;
  final IconData icon;
  final ValueChanged<double> onChanged;

  const MetricRow({
    super.key,
    required this.label,
    required this.initialValue,
    required this.icon,
    required this.onChanged,
  });

  @override
  State<MetricRow> createState() => _MetricRowState();
}

class _MetricRowState extends State<MetricRow> {
  late double _value = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _decrement() {
    if (_value > 0.0) {
      setState(() => _value -= 0.5);
      debugPrint("$_value");
      widget.onChanged(_value);
    }
  }

  void _increment() {
    if (_value < 5.0) {
      setState(() => _value += 0.5);
      debugPrint("$_value");
      widget.onChanged(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Icon + Text indicatif
          Icon(widget.icon, size: 20),
          const SizedBox(width: 16),
          //SizedBox(width: 85, child: Text(widget.label)),

          // Barre progressive
          Expanded(
            child: LinearProgressIndicator(
              value: _value / 5.0,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),

          // Bouton +
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _value > 0.0 ? _decrement : null,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),

          // Bouton -
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _value < 5.0 ? _increment : null,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
