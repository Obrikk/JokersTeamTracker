import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mesures/wellness_model.dart';
import '../../services/mesures/wellness_service.dart';
import '../../services/user/joueur_service.dart';
import '../../core/constants/supabase_constants.dart';

class WellnessProvider {
  final WellnessModel? todayModel;
  final List<WellnessModel> history;
  final bool isLoading;
  final String? errorMessage;

  const WellnessProvider({
    this.todayModel,
    this.history = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  WellnessProvider copyWith({
    WellnessModel? Function()? todayModel,
    List<WellnessModel>? history,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WellnessProvider(
      todayModel: todayModel != null ? todayModel() : this.todayModel,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class WellnessNotifier extends StateNotifier<WellnessProvider> {
  final WellnessService _wellnessService;
  final JoueurService _joueurService;

  WellnessNotifier(this._wellnessService, this._joueurService)
    : super(const WellnessProvider(isLoading: true)) {
    loadToday();
  }

  final userId = supabase.auth.currentUser!.id;

  Future<void> loadToday() async {
    final joueurId = await _joueurService.getPlayerId(userId);

    state = state.copyWith(isLoading: true);
    try {
      // ignore: unnecessary_null_comparison, dead_code
      if (joueurId == null) return;

      final model = await _wellnessService.getTodayWellness(joueurId);
      state = state.copyWith(todayModel: () => model, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> printToday() async {
    state = state.copyWith(isLoading: true);
    try {
      await _wellnessService.getTodayWellnessAllPlayers();
      await loadToday();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> saveToday(WellnessModel model) async {
    state = state.copyWith(isLoading: true);
    try {
      await _wellnessService.saveToday(model);
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

      final history = await _wellnessService.getWellnessHistory(joueurId);
      state = state.copyWith(history: history);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> averageWellness() async {
    await _wellnessService.getTodayWellnessAverages();
  }
}

final wellnessServiceProvider = Provider((ref) => WellnessService());
final joueurServiceProvider = Provider((ref) => JoueurService());

final wellnessProvider =
    StateNotifierProvider<WellnessNotifier, WellnessProvider>(
      (ref) => WellnessNotifier(
        ref.watch(wellnessServiceProvider),
        ref.watch(joueurServiceProvider),
      ),
    );
