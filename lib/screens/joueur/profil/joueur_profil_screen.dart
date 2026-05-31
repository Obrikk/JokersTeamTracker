import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokers_team_tracker/models/mesures/statistiques_model.dart';
import 'package:jokers_team_tracker/services/mesures/statistiques_service.dart';
import 'package:jokers_team_tracker/services/user/joueur_service.dart';
import 'package:jokers_team_tracker/widgets/common/app_bar_widget.dart';
import '../../../models/user/joueur_model.dart';
import '../../../providers/user/auth_provider.dart';
import 'package:flutter_age_calculator/flutter_age_calculator.dart';

class JoueurProfilScreen extends ConsumerStatefulWidget {
  final String joueurId;
  const JoueurProfilScreen({super.key, required this.joueurId});

  @override
  ConsumerState<JoueurProfilScreen> createState() => _JoueurProfilScreenState();
}

class _JoueurProfilScreenState extends ConsumerState<JoueurProfilScreen> {
  final JoueurService joueurService = JoueurService();
  final StatsService statsService = StatsService();

  String id = '';
  String nom = '';
  String prenom = '';
  DateTime dateNaissance = DateTime.now();
  String poste = '';
  int numero = 0;
  int? tailleCm;
  double? poidsKg;
  DateTime dateArrivee = DateTime.now();

  int bench = 0;
  int squat = 0;
  int deadlift = 0;
  int clean = 0;
  int tractions = 0;
  double cmj = 0.0;
  double broadjump = 0.0;
  double sprint5m = 0.0;
  double sprint10m = 0.0;
  double sprint20m = 0.0;

  @override
  void initState() {
    super.initState();
    _loadJoueur();
    _loadStats();
  }

  Future<JoueurModel?> _loadJoueur() async {
    final profileJoueur = await joueurService.getPlayer(widget.joueurId);

    if (profileJoueur != null) {
      setState(() {
        id = profileJoueur.id;
        nom = profileJoueur.nom;
        prenom = profileJoueur.prenom;
        dateNaissance = profileJoueur.dateNaissance;
        poste = profileJoueur.poste;
        numero = profileJoueur.numero;
        tailleCm = profileJoueur.tailleCm;
        poidsKg = profileJoueur.poidsKg;
        dateArrivee = profileJoueur.dateArrivee;
      });
    } else {
      return null;
    }

    return profileJoueur;
  }

  Future<StatsModel?> _loadStats() async {
    final statsJoueur = await statsService.getPlayerRecentStats(
      widget.joueurId,
    );

    if (statsJoueur != null) {
      setState(() {
        bench = statsJoueur.bench;
        squat = statsJoueur.squat;
        deadlift = statsJoueur.deadlift;
        clean = statsJoueur.clean;
        tractions = statsJoueur.pullup;
        cmj = statsJoueur.cmj;
        broadjump = statsJoueur.broadjump;
        sprint5m = statsJoueur.sprint5m;
        sprint10m = statsJoueur.sprint10m;
        sprint20m = statsJoueur.sprint20m;
      });
    } else {
      return null;
    }

    return statsJoueur;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profile = authState.profile;

    final String nomJoueur = "$nom $prenom".trim();

    if (nomJoueur.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<String> mots = nomJoueur.split(RegExp(r'\s+'));

    final String initiales = mots.length >= 2
        ? mots[0][0].toUpperCase() + mots[1][0].toUpperCase()
        : mots[0][0].toUpperCase();

    final age = AdvancedAgeCalculator.calculateAge(birthDate: dateNaissance);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(profil: profile, page: 'Profil'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 500,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).inputDecorationTheme.fillColor,
                                      shape: BoxShape.circle,
                                    ),

                                    alignment: Alignment.center,
                                    child: Text(
                                      initiales,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayLarge,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '#$numero',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.displayLarge,
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            nomJoueur,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.displayLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Column(
                                children: [
                                  _buildInfoRow('Age', '${age.years} ans'),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Date de naissance',
                                    '${dateNaissance.year.toString()}/${dateNaissance.month.toString().padLeft(2, '0')}/${dateNaissance.day.toString()}',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Date d\'arrivée',
                                    '${dateArrivee.year.toString()}/${dateArrivee.month.toString().padLeft(2, '0')}/${dateArrivee.day.toString()}',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('Poste', poste),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('Taille', '$tailleCm cm'),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('Poids', '$poidsKg kg'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 500,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Records Musculation',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Force :',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                _buildDataRow('Développé Couché', '$bench kg'),
                                const SizedBox(height: 8),
                                _buildDataRow('Squat', '$squat kg'),
                                const SizedBox(height: 8),
                                _buildDataRow(
                                  'Soulevé de Terre',
                                  '$deadlift kg',
                                ),
                                const SizedBox(height: 8),
                                _buildDataRow('Épaulé', '$clean kg'),
                                const SizedBox(height: 8),
                                _buildDataRow('Tractions', '$tractions reps'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Explosivité :',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                _buildDataRow('CMJ', '$cmj'),
                                const SizedBox(height: 8),
                                _buildDataRow('Broad Jump', '$broadjump cm'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Vitesse :',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                _buildDataRow('Sprint 5m', '$sprint5m'),
                                const SizedBox(height: 8),
                                _buildDataRow('Sprint 10m', '$sprint10m'),
                                const SizedBox(height: 8),
                                _buildDataRow('Sprint 20m', '$sprint20m'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 500,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Performances sur Glace',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                _buildDataRow('Matchs joués', 25),
                                const SizedBox(height: 8),
                                _buildDataRow('Points', 29),
                                const SizedBox(height: 8),
                                _buildDataRow('Buts', 11),
                                const SizedBox(height: 8),
                                _buildDataRow('Assistances', 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildDataRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label :', style: Theme.of(context).textTheme.headlineSmall),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Row _buildInfoRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label :', style: Theme.of(context).textTheme.bodyLarge),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
