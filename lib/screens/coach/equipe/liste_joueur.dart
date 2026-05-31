// ignore_for_file: dead_null_aware_expression, deprecated_member_use, dead_code

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokers_team_tracker/providers/user/auth_provider.dart';

import '../../../core/theme/colors.dart';
import '../../../models/user/joueur_model.dart';
import '../../../widgets/common/app_bar_widget.dart';

import '../../../services/mesures/grip_service.dart';
import '../../../services/mesures/poids_service.dart';
import '../../../services/mesures/wellness_service.dart';
import '../../../services/mesures/rpe_service.dart';
import '../../../services/user/joueur_service.dart';

class ListeJoueur extends ConsumerStatefulWidget {
  const ListeJoueur({super.key});

  @override
  ConsumerState<ListeJoueur> createState() => _ListeJoueurState();
}

class _ListeJoueurState extends ConsumerState<ListeJoueur> {
  // Services Wellness => hasWellnessSubmitted
  final WellnessService _wellnessService = WellnessService();

  // Services Rpe => hasRpeSubmitted
  final RpeService _rpeService = RpeService();

  // Services Poids => hasGripSubmitted
  final PoidsService _poidsService = PoidsService();

  // Services Grip => hasPoidsSubmitted
  final GripService _gripService = GripService();

  // Services Joueurs => getAllPlayers
  final JoueurService _joueurService = JoueurService();
  late Future<List<JoueurStatut>> allJoueurs;

  @override
  void initState() {
    super.initState();
    allJoueurs = _loadJoueurs();
  }

  Future<List<JoueurStatut>> _loadJoueurs() async {
    final allPlayers = await _joueurService.getAllPlayers();
    final List<JoueurStatut> result = [];

    for (final joueur in allPlayers) {
      result.add(
        JoueurStatut(
          joueur: joueur,
          wellnessSubmitted: _wellnessService.hasWellnessSubmitted(joueur.id),
          rpeSubmitted: _rpeService.hasRpeSubmitted(joueur.id),
          gripSubmitted: _gripService.hasGripSubmitted(joueur.id),
          poidsSubmitted: _poidsService.hasPoidsSubmitted(joueur.id),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profile = authState.profile;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(profil: profile, page: 'Liste Joueurs'),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              FutureBuilder<List<JoueurStatut>>(
                future: allJoueurs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  }

                  final joueurs = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: joueurs.length,
                    itemBuilder: (context, index) =>
                        _buildPlayerCard(context, index, joueurs[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JoueurStatut {
  final JoueurModel joueur;
  final bool wellnessSubmitted;
  final bool rpeSubmitted;
  final bool gripSubmitted;
  final bool poidsSubmitted;

  JoueurStatut({
    required this.joueur,
    required this.wellnessSubmitted,
    required this.rpeSubmitted,
    required this.gripSubmitted,
    required this.poidsSubmitted,
  });
}

Widget _buildPlayerCard(BuildContext context, int index, JoueurStatut statut) {
  final joueur = statut.joueur;

  return Container(
    height: 72,
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        hoverColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.1),
        onTap: () {
          // Navigation vers le profil du joueur
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // ── Gauche : numéro + nom + poste ──
              SizedBox(
                width: 40,
                child: Text(
                  '#${joueur.numero}',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${joueur.prenom} ${joueur.nom}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                joueur.poste ?? '',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),

              const Spacer(),

              // ── Droite : statuts + bouton ──
              _buildStatutBadge('Wellness', statut.wellnessSubmitted),
              _buildStatutBadge('RPE', statut.rpeSubmitted),
              _buildStatutBadge('Grip', statut.gripSubmitted),
              _buildStatutBadge('Poids', statut.poidsSubmitted),
              const SizedBox(width: 32),

              // Bouton Afficher Profil
              TextButton(
                onPressed: () {
                  // Navigation vers le profil
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Afficher Profil',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildStatutBadge(String label, bool submitted) {
  final color = submitted ? AppColors.green : AppColors.red;
  return SizedBox(
    width: 70,
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );
}
