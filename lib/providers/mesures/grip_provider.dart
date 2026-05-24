import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mesures/grip_model.dart';
import '../../services/mesures/grip_service.dart';
import '../../services/user/joueur_service.dart';
import '../../core/constants/supabase_constants.dart';

class GripProvider {
  final GripModel? todayModel;
  final List<GripModel> history;
  final bool isLoading;
  final String? errorMessage;

  const GripProvider({
    this.todayModel,
    this.history = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  GripProvider copyWith({
    GripModel? Function()? todayModel,
    List<GripModel>? history,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GripProvider(
      todayModel: todayModel != null ? todayModel() : this.todayModel,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class GripNotifier extends StateNotifier<GripProvider> {
  final GripService _gripService;
  final JoueurService _joueurService;

  GripNotifier(this._gripService, this._joueurService)
    : super(const GripProvider(isLoading: true)) {
    loadToday();
  }

  final userId = supabase.auth.currentUser!.id;

  Future<void> loadToday() async {
    final joueurId = await _joueurService.getPlayerId(userId);

    state = state.copyWith(isLoading: true);
    try {
      // ignore: unnecessary_null_comparison, dead_code
      if (joueurId == null) return;

      final model = await _gripService.getTodayGrip(joueurId);
      state = state.copyWith(todayModel: () => model, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> printToday() async {
    state = state.copyWith(isLoading: true);
    try {
      await _gripService.getTodayGripAllPlayers();
      await loadToday();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> saveToday(GripModel model) async {
    state = state.copyWith(isLoading: true);
    try {
      await _gripService.saveToday(model);
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

      final history = await _gripService.getGripHistory(joueurId);
      state = state.copyWith(history: history);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> averageGrip() async {
    await _gripService.getTodayGripAverages();
  }
}

final gripServiceProvider = Provider((ref) => GripService());
final joueurServiceProvider = Provider((ref) => JoueurService());

final gripProvider = StateNotifierProvider<GripNotifier, GripProvider>(
  (ref) => GripNotifier(
    ref.watch(gripServiceProvider),
    ref.watch(joueurServiceProvider),
  ),
);
