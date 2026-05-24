import 'package:flutter/material.dart';

import '../../../services/user/joueur_service.dart';
import '../../../services/mesures/poids_service.dart';
import '../../../models/mesures/poids_model.dart';

import '../../../core/constants/supabase_constants.dart';

class PoidsForm extends StatefulWidget {
  @override
  State<PoidsForm> createState() => _PoidsFromState();

  const PoidsForm({super.key});
}

class _PoidsFromState extends State<PoidsForm> {
  final PoidsService _poidsService = PoidsService();

  final JoueurService _joueurService = JoueurService();

  final TextEditingController _poidsController = TextEditingController();

  final userId = supabase.auth.currentUser!.id;
  double _poids = 0;

  @override
  void dispose() {
    _poidsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPoids();
  }

  // Initialiser le poids
  Future<PoidsModel?> _loadPoids() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final poids = await _poidsService.getTodayPoids(joueurId);

    if (poids != null) {
      setState(() {
        _poids = poids.poids;
      });
    }

    return poids;
  }

  Future<void> _savePoids() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final joueurNom = await _joueurService.getPlayerNom(userId);
    final joueurPrenom = await _joueurService.getPlayerPrenom(userId);

    final model = PoidsModel(
      joueurId: joueurId,
      date: DateTime.now(),
      poids: _poids,
      joueurNom: joueurNom,
      joueurPrenom: joueurPrenom,
    );

    await _poidsService.saveToday(model);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Carte Poids
        Card.filled(
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
                      'Poids :',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Poids du jour',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                //Appel création de la carte
                TextField(
                  controller: _poidsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _poids.toString(),
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixText: 'kg',
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  // Bouton Sauvegarde
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _poids = double.tryParse(_poidsController.text) ?? 0.0;
                      _savePoids();
                      debugPrint('poids: $_poids');
                    },
                    child: const Text('Enregistrer'),
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
}
