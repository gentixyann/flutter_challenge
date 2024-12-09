import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_app/charger_spot.dart';
import 'package:flutter_map_app/charger_spots_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ChargerSpotsRepositoryを管理するプロバイダ
final chargerSpotsRepositoryProvider =
    Provider((ref) => ChargerSpotsRepository());

// 可視範囲の ChargerSpot を管理するプロバイダ
final chargerSpotListProvider =
    StateNotifierProvider<ChargerSpotListNotifier, List<ChargerSpot>>(
  (ref) => ChargerSpotListNotifier(ref.watch(chargerSpotsRepositoryProvider)),
);

// 選択された ChargerSpot を管理するプロバイダ
final selectedChargerSpotProvider = StateProvider<ChargerSpot?>((ref) => null);

// ChargerSpotList を管理する StateNotifier
class ChargerSpotListNotifier extends StateNotifier<List<ChargerSpot>> {
  final ChargerSpotsRepository _repository;

  ChargerSpotListNotifier(this._repository) : super([]);

  // 可視範囲内の ChargerSpot を取得し、状態を更新する
  Future<void> fetchChargerSpots(LatLngBounds bounds) async {
    try {
      final response = await _repository.getChargerSpots(
        swLat: bounds.southwest.latitude,
        swLng: bounds.southwest.longitude,
        neLat: bounds.northeast.latitude,
        neLng: bounds.northeast.longitude,
      );
      final spots = response.spots;
      state = spots;
    } catch (e) {
      print('Error fetching ChargerSpots: $e');
      state = [];
    }
  }
}
