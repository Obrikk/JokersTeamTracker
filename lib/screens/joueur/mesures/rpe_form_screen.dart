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
        // Carte RPE 1
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
                      'RPE 1 :',
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
                _buildRpeSection1(),

                const SizedBox(height: 32),
                SizedBox(
                  // Bouton Sauvegarde
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Remplir RPE'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Carte RPE 2
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
                      'RPE 2 :',
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
                _buildRpeSection2(),

                const SizedBox(height: 32),
                SizedBox(
                  // Bouton Sauvegarde
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveRpe();
                      _rpeFuture = _loadRpe();
                    },
                    child: const Text('Enregistrer Wellness'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Carte RPE 3
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
                      'RPE 3 :',
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
                _buildRpeSection3(),

                const SizedBox(height: 32),
                SizedBox(
                  // Bouton Sauvegarde
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveRpe();
                      _rpeFuture = _loadRpe();
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

  // Initialisation Carte n°1
  Widget _buildRpeSection1() {
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
          return _buildNoRpeCard1();
        }

        return _buildRpeCard1(rpe, _rpeTotal);
      },
    );
  }

  // Création Carte n°1
  Widget _buildRpeCard1(RpeModel rpe, rpeTotal) {
    final color = _getColor(_rpeTotal * 10);

    // Valeurs RPE
    final valueSelection = [rpe.rpem, rpe.rpec];

    // Icons Indicatifs
    final iconsSelection = [
      Icon(Icons.fitness_center),
      Icon(Icons.monitor_heart_outlined),
    ];

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cercle de Progression
                CircularProgressIndicator(
                  value: rpeTotal / 20,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),

                // Pourcentage de progression
                Center(
                  child: Text(
                    '${rpeTotal * 5}%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Affichage des carrés avec leurs valeurs
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(2, (index) {
              int? value = valueSelection[index];
              final color = _getGradientColor(value);
              return Column(
                children: [
                  iconsSelection[index],
                  const SizedBox(height: 16),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$value',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // Création Carte Vide n°1
  Widget _buildNoRpeCard1() {
    // Icons Indicatifs
    final iconsSelection = [
      Icon(Icons.fitness_center),
      Icon(Icons.monitor_heart_outlined),
    ];

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cercle de Progression
                CircularProgressIndicator(
                  value: 0 / 20,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),

                // Pourcentage de progression
                Center(
                  child: Text(
                    '0%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Affichage des carrés vides
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(2, (index) {
              final color = const Color(0xFFA9A9A9);

              return Column(
                children: [
                  iconsSelection[index],
                  const SizedBox(height: 16),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '?',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // Initialisation Carte n°2
  Widget _buildRpeSection2() {
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
          return _buildNoRpeCard2();
        }

        return _buildRpeCard2(rpe, _rpeTotal);
      },
    );
  }

  // Création Carte n°2
  Widget _buildRpeCard2(RpeModel rpe, rpeTotal) {
    final color = _getColor(_rpeTotal * 10);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cercle de Progression
                CircularProgressIndicator(
                  value: rpeTotal / 20,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),

                // Pourcentage de progression
                Center(
                  child: Text(
                    '${rpeTotal * 5}%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

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
            ],
          ),
        ),
      ],
    );
  }

  // Création Carte Vide n°2
  Widget _buildNoRpeCard2() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cercle de progression vide
                CircularProgressIndicator(
                  value: 0 / 20,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),

                // Pourcentage de progression
                Center(
                  child: Text(
                    '0%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Affichage des barres progressives
        Expanded(
          child: Column(
            children: [
              MetricRow(
                label: 'Rpe Musclaire',
                icon: Icons.fitness_center,
                initialValue: _rpem,
                onChanged: (val) => setState(() => _rpem = val),
              ),
              MetricRow(
                label: 'Rpe Cardio',
                icon: Icons.monitor_heart_outlined,
                initialValue: _rpec,
                onChanged: (val) => setState(() => _rpec = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Initialisation Carte n°3
  Widget _buildRpeSection3() {
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
          return _buildNoRpeCard3();
        }

        return _buildRpeCard3(rpe, _rpeTotal);
      },
    );
  }

  // Création Carte n°3
  Widget _buildRpeCard3(RpeModel rpe, rpeTotal) {
    final color = _getColor(_rpeTotal * 10);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cercle de Progression
                      CircularProgressIndicator(
                        value: rpeTotal / 20,
                        strokeWidth: 8,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),

                      // Pourcentage de progression
                      Center(
                        child: Text(
                          '${rpeTotal * 5}%',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Création Carte Vide n°3
  Widget _buildNoRpeCard3() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cercle de progression vide
                CircularProgressIndicator(
                  value: 0 / 20,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),

                // Pourcentage de progression
                Center(
                  child: Text(
                    '0%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Affichage des barres progressives
        Expanded(
          child: Column(
            children: [
              MetricRow(
                label: 'Rpe Musclaire',
                icon: Icons.fitness_center,
                initialValue: _rpem,
                onChanged: (val) => setState(() => _rpem = val),
              ),
              MetricRow(
                label: 'Rpe Cardio',
                icon: Icons.monitor_heart_outlined,
                initialValue: _rpec,
                onChanged: (val) => setState(() => _rpec = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Carte 1 : Changement couleurs carré
  Color _getGradientColor(int index) {
    const colors = [
      Color(0xFF1B5E20), // vert foncé
      Color(0xFF388E3C),
      Color(0xFF7CB342),
      Color(0xFFC0CA33),
      Color(0xFFFDD835),
      Color(0xFFF9A825),
      Color(0xFFEF6C00),
      Color(0xFFD84315),
      Color(0xFFC62828),
      Color(0xFFB71C1C), // rouge foncé
    ];
    return colors[index];
  }

  // Carte 1 et 2 : Couleurs cercle de progression
  Color _getColor(double percentage) {
    if (percentage >= 40) return const Color(0xFFB71C1C);
    if (percentage >= 70) return const Color(0xFFF57F17);
    return const Color(0xFF1B5E20);
  }
}

// Carte 2 : Définition classe des barres progressives
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
    if (_value > 1) {
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
          const SizedBox(width: 4),
          SizedBox(width: 60, child: Text(widget.label)),

          // Barre progressive
          Expanded(
            child: LinearProgressIndicator(
              value: _value / 10,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),

          // Résultat
          Text('$_value/10'),
          const SizedBox(width: 8),

          // Bouton +
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _value > 1 ? _decrement : null,
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
