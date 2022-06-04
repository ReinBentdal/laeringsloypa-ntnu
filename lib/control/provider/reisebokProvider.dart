import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Reisebok.dart';
import 'loypeProvider.dart';

final reisebokaProvider = Provider<AsyncValue<ReisebokaModel>>((ref) {
  final data = ref.watch(valgtLoypeProvider);

  return data.when(
    data: (data) => AsyncValue.data(data!.reiseboka),
    loading: () => AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});
