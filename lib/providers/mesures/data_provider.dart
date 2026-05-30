import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mesures/fill_rate_model.dart';
import '../../services/mesures/grip_service.dart';
import '../../services/mesures/poids_service.dart';
import '../../services/mesures/rpe_service.dart';
import '../../services/mesures/wellness_service.dart';

class StatsState {
  final FillRateModel? rpeFillRate;
  final FillRateModel? wellnessFillRate;
  final FillRateModel? gripFillRate;
  final FillRateModel? poidsFillRate;
  final bool isLoading;
  final String? errorMessage;

  const StatsState({
    this.rpeFillRate,
    this.wellnessFillRate,
    this.gripFillRate,
    this.poidsFillRate,
    this.isLoading = false,
    this.errorMessage,
  });

  StatsState copyWith({
    FillRateModel? rpeFillRate,
    FillRateModel? wellnessFillRate,
    FillRateModel? gripFillRate,
    FillRateModel? poidsFillRate,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StatsState(
      rpeFillRate: rpeFillRate ?? this.rpeFillRate,
      wellnessFillRate: wellnessFillRate ?? this.wellnessFillRate,
      gripFillRate: gripFillRate ?? this.gripFillRate,
      poidsFillRate: poidsFillRate ?? this.poidsFillRate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class StatsNotifier extends StateNotifier<StatsState> {
  final WellnessService _wellnessService;
  final RpeService _rpeService;
  final GripService _gripService;
  final PoidsService _poidsService;

  StatsNotifier(
    this._wellnessService,
    this._rpeService,
    this._gripService,
    this._poidsService,
  ) : super(const StatsState(isLoading: true)) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final wellness = await _wellnessService.getWellnessFillRate();
      final rpe = await _rpeService.getRpeFillRate();
      final grip = await _gripService.getGripFillRate();
      final poids = await _poidsService.getPoidsFillRate();

      state = state.copyWith(
        rpeFillRate: rpe,
        wellnessFillRate: wellness,
        gripFillRate: grip,
        poidsFillRate: poids,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refreshWellness() async {
    final wellness = await _wellnessService.getWellnessFillRate();
    state = state.copyWith(wellnessFillRate: wellness);
  }

  Future<void> refreshRpe() async {
    final rpe = await _rpeService.getRpeFillRate();
    state = state.copyWith(rpeFillRate: rpe);
  }

  Future<void> refreshGrip() async {
    final grip = await _gripService.getGripFillRate();
    state = state.copyWith(gripFillRate: grip);
  }

  Future<void> refreshPoids() async {
    final poids = await _poidsService.getPoidsFillRate();
    state = state.copyWith(poidsFillRate: poids);
  }
}

final wellnessServiceProvider = Provider((ref) => WellnessService());
final rpeServiceProvider = Provider((ref) => RpeService());
final gripServiceProvider = Provider((ref) => GripService());
final poidsServiceProvider = Provider((ref) => PoidsService());

final dataProvider = StateNotifierProvider<StatsNotifier, StatsState>(
  (ref) => StatsNotifier(
    ref.watch(wellnessServiceProvider),
    ref.watch(rpeServiceProvider),
    ref.watch(gripServiceProvider),
    ref.watch(poidsServiceProvider),
  ),
);
