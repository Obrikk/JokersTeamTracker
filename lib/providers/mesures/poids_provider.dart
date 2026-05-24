import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mesures/poids_model.dart';
import '../../services/mesures/poids_service.dart';
import '../../services/user/joueur_service.dart';
import '../../core/constants/supabase_constants.dart';

class PoidsProvider {
  final PoidsModel? todayModel;
  final List<PoidsModel> history;
  final bool isLoading;
  final String? errorMessage;

  const PoidsProvider({
    this.todayModel,
    this.history = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  PoidsProvider copyWith({
    PoidsModel? Function()? todayModel,
    List<PoidsModel>? history,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PoidsProvider(
      todayModel: todayModel != null ? todayModel() : this.todayModel,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PoidsNotifier extends StateNotifier<PoidsProvider> {
  final PoidsService _poidsService;
  final JoueurService _joueurService;

  PoidsNotifier(this._poidsService, this._joueurService)
    : super(const PoidsProvider(isLoading: true)) {
    loadToday();
  }

  final userId = supabase.auth.currentUser!.id;

  Future<void> loadToday() async {
    final joueurId = await _joueurService.getPlayerId(userId);

    state = state.copyWith(isLoading: true);
    try {
      // ignore: unnecessary_null_comparison, dead_code
      if (joueurId == null) return;

      final model = await _poidsService.getTodayPoids(joueurId);
      state = state.copyWith(todayModel: () => model, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> printToday() async {
    state = state.copyWith(isLoading: true);
    try {
      await _poidsService.getTodayPoidsAllPlayers();
      await loadToday();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> saveToday(PoidsModel model) async {
    state = state.copyWith(isLoading: true);
    try {
      await _poidsService.saveToday(model);
      await loadToday();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadHistory() async {
    try {
      final joueurId = await _joueurService.getPlayerId(userId);
      // ignore: unnecessary_null_comparison, dead_code
      if (joueurId == null) return;

      final history = await _poidsService.getPoidsHistory(joueurId);
      state = state.copyWith(history: history);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> averagePoids() async {
    await _poidsService.getTodayPoidsAverages();
  }
}

final poidsServiceProvider = Provider((ref) => PoidsService());
final joueurServiceProvider = Provider((ref) => JoueurService());

final poidsProvider = StateNotifierProvider<PoidsNotifier, PoidsProvider>(
  (ref) => PoidsNotifier(
    ref.watch(poidsServiceProvider),
    ref.watch(joueurServiceProvider),
  ),
);
