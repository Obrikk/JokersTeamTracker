import 'package:flutter/material.dart';

import '../../../services/user/joueur_service.dart';
import '../../../services/mesures/rpe_service.dart';
import '../../../models/mesures/rpe_model.dart';

import '../../../core/constants/supabase_constants.dart';

class RpeForm extends StatefulWidget {
  @override
  State<RpeForm> createState() => _RpeFormState();

  const RpeForm({super.key});
}

class _RpeFormState extends State<RpeForm> {
  // Services Wellness => loadWellness, saveWellness
  final RpeService _rpeService = RpeService();

  // Services Joueur => userId vers joueurId
  final JoueurService _joueurService = JoueurService();

  late Future<RpeModel?> _rpeFuture;

  // Variables du rpe
  final userId = supabase.auth.currentUser!.id;
  int _rpeTotal = 0;

  int _rpem = 0;
  int _rpec = 0;

  @override
  initState() {
    super.initState();
    _rpeFuture = _loadRpe();
  }

  // Initialiser le rpe
  Future<RpeModel?> _loadRpe() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final rpe = await _rpeService.getTodayRpe(joueurId);

    if (rpe != null) {
      setState(() {
        _rpem = rpe.rpem;
        _rpec = rpe.rpec;

        _rpeTotal = rpe.rpem + rpe.rpec;
      });
    }

    return rpe;
  }

  Future<void> _saveRpe() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final joueurNom = await _joueurService.getPlayerNom(userId);
    final joueurPrenom = await _joueurService.getPlayerPrenom(userId);

    final model = RpeModel(
      joueurId: joueurId,
      date: DateTime.now(),
      rpem: _rpem,
      rpec: _rpec,
      joueurNom: joueurNom,
      joueurPrenom: joueurPrenom,
    );

    await _rpeService.saveToday(model);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carte RPE
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
                      'RPE :',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Difficulté | 1 - 10',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                //Appel création de la carte
                _buildRpeSection(),

                const SizedBox(height: 32),
                SizedBox(
                  // Bouton Sauvegarde
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveRpe();
                      _rpeFuture = _loadRpe();
                    },
                    child: const Text('Enregistrer RPE'),
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
  Widget _buildRpeSection() {
    return FutureBuilder<RpeModel?>(
      future: _rpeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        final rpe = snapshot.data;
        if (rpe == null) {
          return _buildNoRpeCard();
        }

        return _buildRpeCard(rpe, _rpeTotal);
      },
    );
  }

  // Création Carte
  Widget _buildRpeCard(RpeModel rpe, rpeTotal) {
    return Row(
      children: [
        // Affichage des carrés avec leurs valeurs
        Expanded(
          child: Column(
            children: [
              MetricRow(
                label: 'Rpe M.',
                icon: Icons.fitness_center,
                initialValue: _rpem,
                onChanged: (val) => setState(() => _rpem = val),
              ),
              MetricRow(
                label: 'Rpe C.',
                icon: Icons.monitor_heart_outlined,
                initialValue: _rpec,
                onChanged: (val) => setState(() => _rpec = val),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  // Création Carte Vide
  Widget _buildNoRpeCard() {
    return Row(
      children: [
        // Affichage des barres progressives
        Expanded(
          child: Column(
            children: [
              MetricRow(
                label: 'Rpe M.',
                icon: Icons.fitness_center,
                initialValue: _rpem,
                onChanged: (val) => setState(() => _rpem = val),
              ),
              MetricRow(
                label: 'Rpe C.',
                icon: Icons.monitor_heart_outlined,
                initialValue: _rpec,
                onChanged: (val) => setState(() => _rpec = val),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

// Définition classe des barres progressives
class MetricRow extends StatefulWidget {
  final String label;
  final int initialValue;
  final IconData icon;
  final ValueChanged<int> onChanged;

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
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _decrement() {
    if (_value > 0) {
      setState(() => _value--);
      widget.onChanged(_value);
    }
  }

  void _increment() {
    if (_value < 10) {
      setState(() => _value++);
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
          //SizedBox(width: 60, child: Text(widget.label)),

          // Barre progressive
          Expanded(
            child: LinearProgressIndicator(
              value: _value / 10,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),

          // Bouton +
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _value > 0 ? _decrement : null,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),

          // Bouton -
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _value < 10 ? _increment : null,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
