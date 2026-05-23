import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mesures/wellness_model.dart';
import '../../services/mesures/wellness_service.dart';
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
}
