import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mesures/rpe_model.dart';
import '../../services/mesures/rpe_service.dart';
import '../../services/user/joueur_service.dart';
import '../../core/constants/supabase_constants.dart';

class RpeProvider {
  final RpeModel? todayModel;
  final List<RpeModel> history;
  final bool isLoading;
  final String? errorMessage;

  const RpeProvider({
    this.todayModel,
    this.history = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  RpeProvider copyWith({
    RpeModel? Function()? todayModel,
    List<RpeModel>? history,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RpeProvider(
      todayModel: todayModel != null ? todayModel() : this.todayModel,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RpeNotifier extends StateNotifier<RpeProvider> {
  final RpeService _rpeService;
  final JoueurService _joueurService;

  RpeNotifier(this._rpeService, this._joueurService)
    : super(const RpeProvider(isLoading: true)) {
    loadToday();
  }

  final userId = supabase.auth.currentUser!.id;

  Future<void> loadToday() async {
    final joueurId = await _joueurService.getPlayerId(userId);

    state = state.copyWith(isLoading: true);
    try {
      // ignore: unnecessary_null_comparison, dead_code
      if (joueurId == null) return;

      final model = await _rpeService.getTodayRpe(joueurId);
      state = state.copyWith(todayModel: () => model, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> printToday() async {
    state = state.copyWith(isLoading: true);
    try {
      await _rpeService.getTodayRpeAllPlayers();
      await loadToday();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> saveToday(RpeModel model) async {
    state = state.copyWith(isLoading: true);
    try {
      await _rpeService.saveToday(model);
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

      final history = await _rpeService.getRpeHistory(joueurId);
      state = state.copyWith(history: history);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> averageRpe() async {
    await _rpeService.getTodayRpeAverages();
  }
}

final rpeServiceProvider = Provider((ref) => RpeService());
final joueurServiceProvider = Provider((ref) => JoueurService());

final rpeProvider = StateNotifierProvider<RpeNotifier, RpeProvider>(
  (ref) => RpeNotifier(
    ref.watch(rpeServiceProvider),
    ref.watch(joueurServiceProvider),
  ),
);
