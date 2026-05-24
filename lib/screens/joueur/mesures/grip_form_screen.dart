import 'package:flutter/material.dart';

import '../../../services/user/joueur_service.dart';
import '../../../services/mesures/grip_service.dart';
import '../../../models/mesures/grip_model.dart';

import '../../../core/constants/supabase_constants.dart';

class GripForm extends StatefulWidget {
  @override
  State<GripForm> createState() => _GripFromState();

  const GripForm({super.key});
}

class _GripFromState extends State<GripForm> {
  final GripService _gripService = GripService();

  final JoueurService _joueurService = JoueurService();

  final TextEditingController _gripController = TextEditingController();

  final userId = supabase.auth.currentUser!.id;
  double _grip = 0;

  @override
  void dispose() {
    _gripController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadGrip();
  }

  // Initialiser le grip
  Future<GripModel?> _loadGrip() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final grip = await _gripService.getTodayGrip(joueurId);

    if (grip != null) {
      setState(() {
        _grip = grip.grip;
      });
    }

    return grip;
  }

  Future<void> _saveGrip() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final joueurNom = await _joueurService.getPlayerNom(userId);
    final joueurPrenom = await _joueurService.getPlayerPrenom(userId);

    final model = GripModel(
      joueurId: joueurId,
      date: DateTime.now(),
      grip: _grip,
      joueurNom: joueurNom,
      joueurPrenom: joueurPrenom,
    );

    await _gripService.saveToday(model);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Carte Grip
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
                      'Grip :',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Force du grip',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                //Appel création de la carte
                TextField(
                  controller: _gripController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _grip.toString(),
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
                      _grip = double.tryParse(_gripController.text) ?? 0.0;
                      _saveGrip();
                      debugPrint('grip: $_grip');
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
