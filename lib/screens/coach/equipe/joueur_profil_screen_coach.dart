import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_age_calculator/flutter_age_calculator.dart';

import 'package:jokers_team_tracker/models/mesures/statistiques_model.dart';
import 'package:jokers_team_tracker/services/mesures/statistiques_service.dart';

import 'package:jokers_team_tracker/models/mesures/wellness_model.dart';
import 'package:jokers_team_tracker/services/mesures/wellness_service.dart';

import 'package:jokers_team_tracker/models/mesures/rpe_model.dart';
import 'package:jokers_team_tracker/services/mesures/rpe_service.dart';

import 'package:jokers_team_tracker/models/mesures/grip_model.dart';
import 'package:jokers_team_tracker/services/mesures/grip_service.dart';

import 'package:jokers_team_tracker/models/mesures/poids_model.dart';
import 'package:jokers_team_tracker/services/mesures/poids_service.dart';

import 'package:jokers_team_tracker/models/user/joueur_model.dart';
import 'package:jokers_team_tracker/services/user/joueur_service.dart';

import 'package:jokers_team_tracker/widgets/common/app_bar_widget.dart';

import 'package:jokers_team_tracker/providers/user/auth_provider.dart';

class JoueurProfilScreenStaff extends ConsumerStatefulWidget {
  final String joueurId;
  const JoueurProfilScreenStaff({super.key, required this.joueurId});

  @override
  ConsumerState<JoueurProfilScreenStaff> createState() =>
      _JoueurProfilScreenState();
}

class _JoueurProfilScreenState extends ConsumerState<JoueurProfilScreenStaff> {
  final JoueurService joueurService = JoueurService();
  final StatsService statsService = StatsService();
  final WellnessService wellnessService = WellnessService();
  final RpeService rpeService = RpeService();
  final GripService gripService = GripService();
  final PoidsService poidsService = PoidsService();

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

  double sommeil = 0.0;
  double humeur = 0.0;
  double energie = 0.0;
  double courbatures = 0.0;
  double stress = 0.0;

  double sommeilEquipe = 0.0;
  double humeurEquipe = 0.0;
  double energieEquipe = 0.0;
  double courbaturesEquipe = 0.0;
  double stressEquipe = 0.0;

  int rpem = 0;
  int rpec = 0;

  double rpemEquipe = 0;
  double rpecEquipe = 0;

  double poids = 0.0;
  double poidsEquipe = 0.0;

  double grip = 0.0;
  double gripEquipe = 0.0;

  @override
  void initState() {
    super.initState();
    _loadJoueur();
    _loadStats();
    _loadData();
    _loadTeamData();
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

  Future<void> _loadTeamData() async {
    final wellnessTeam = await wellnessService.getTodayWellnessAverages();
    final rpeTeam = await rpeService.getTodayRpeAverages();
    final gripTeam = await gripService.getTodayGripAverages();
    final poidsTeam = await poidsService.getTodayPoidsAverages();

    setState(() {
      sommeilEquipe = wellnessTeam['sommeil']!;
      humeurEquipe = wellnessTeam['humeur']!;
      energieEquipe = wellnessTeam['energie']!;
      courbaturesEquipe = wellnessTeam['courbatures']!;
      stressEquipe = wellnessTeam['stress']!;

      rpemEquipe = rpeTeam['rpem']!;
      rpecEquipe = rpeTeam['rpec']!;

      gripEquipe = gripTeam['grip']!;

      poidsEquipe = poidsTeam['poids']!;
    });
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      wellnessService.getTodayWellness(widget.joueurId),
      rpeService.getTodayRpe(widget.joueurId),
      gripService.getTodayGrip(widget.joueurId),
      poidsService.getTodayPoids(widget.joueurId),
    ]);

    final wellnessJoueur = results[0] as WellnessModel?;
    final rpeJoueur = results[1] as RpeModel?;
    final gripJoueur = results[2] as GripModel?;
    final poidsJoueur = results[3] as PoidsModel?;

    setState(() {
      sommeil = wellnessJoueur?.sommeil ?? 0;
      humeur = wellnessJoueur?.humeur ?? 0;
      energie = wellnessJoueur?.energie ?? 0;
      courbatures = wellnessJoueur?.courbatures ?? 0;
      stress = wellnessJoueur?.stress ?? 0;

      rpem = rpeJoueur?.rpem ?? 0;
      rpec = rpeJoueur?.rpec ?? 0;

      grip = gripJoueur?.grip ?? 0;

      poids = poidsJoueur?.poids ?? 0;
    });
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
                                'Données du jour',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Wellness :',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                ),
                                Text(
                                  'Joueur - Equipe',
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
                                _buildDataRow(
                                  'Sommeil',
                                  '$sommeil',
                                  '$sommeilEquipe',
                                  1.5,
                                ),
                                const SizedBox(height: 8),
                                _buildDataRow(
                                  'Humeur',
                                  '$humeur',
                                  '$humeurEquipe',
                                  1.5,
                                ),
                                const SizedBox(height: 8),
                                _buildDataRow(
                                  'Energie',
                                  '$energie',
                                  '$energieEquipe',
                                  1.5,
                                ),
                                const SizedBox(height: 8),
                                _buildDataRow(
                                  'Courbatures',
                                  '$courbatures',
                                  '$courbaturesEquipe',
                                  1.5,
                                ),
                                const SizedBox(height: 8),
                                _buildDataRow(
                                  'Stress',
                                  '$stress',
                                  '$stressEquipe',
                                  1.5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'RPE :',
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
                                _buildDataRow(
                                  'RPE M.',
                                  '$rpem',
                                  '$rpemEquipe',
                                  2,
                                ),
                                const SizedBox(height: 8),
                                _buildDataRow(
                                  'RPE C.',
                                  '$rpec',
                                  '$rpecEquipe',
                                  2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Grip :',
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
                                _buildDataRow(
                                  'Grip',
                                  '$grip',
                                  '$gripEquipe',
                                  10.0,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Poids :',
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
                                _buildDataRow(
                                  'Poids',
                                  '$poids',
                                  '$poidsEquipe',
                                  20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Afficher Graphiques'),
                              ),
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
                                _buildStatsRow('Développé Couché', '$bench kg'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Squat', '$squat kg'),
                                const SizedBox(height: 8),
                                _buildStatsRow(
                                  'Soulevé de Terre',
                                  '$deadlift kg',
                                ),
                                const SizedBox(height: 8),
                                _buildStatsRow('Épaulé', '$clean kg'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Tractions', '$tractions reps'),
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
                                _buildStatsRow('CMJ', '$cmj'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Broad Jump', '$broadjump cm'),
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
                                _buildStatsRow('Sprint 5m', '$sprint5m'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Sprint 10m', '$sprint10m'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Sprint 20m', '$sprint20m'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Afficher Graphiques'),
                              ),
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
                                _buildStatsRow('Matchs joués', '??'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Points', '??'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Buts', '??'),
                                const SizedBox(height: 8),
                                _buildStatsRow('Assistances', '??'),
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

  Row _buildStatsRow(String label, dynamic value) {
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

  Row _buildDataRow(
    String label,
    dynamic valuePlayer,
    dynamic valueTeam,
    double difference,
  ) {
    final player = double.tryParse(valuePlayer.toString()) ?? 0.0;
    final team = double.tryParse(valueTeam.toString()) ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label :', style: Theme.of(context).textTheme.headlineSmall),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${player.toString()}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: (player < team - difference)
                      ? Theme.of(context)
                            .colorScheme
                            .error // rouge
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextSpan(
                text: '  ---  ${team.toString()}  ',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
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
