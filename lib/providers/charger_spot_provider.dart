import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_app/charger_spot.dart';
import 'package:flutter_map_app/charger_spots_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ChargerSpotsRepositoryを管理するプロバイダ
final chargerSpotsRepositoryProvider =
    Provider((ref) => ChargerSpotsRepository());

// 可視範囲に基づく充電スポットの取得と管理
final chargerSpotsProvider =
    FutureProvider.family<GetChargerSpotsResponse, LatLngBounds>(
  (ref, bounds) async {
    final repository = ref.watch(chargerSpotsRepositoryProvider);

    return repository.getChargerSpots(
      swLat: bounds.southwest.latitude,
      swLng: bounds.southwest.longitude,
      neLat: bounds.northeast.latitude,
      neLng: bounds.northeast.longitude,
    );
  },
);

// ChargerSpotクラスからMarkerに変換する関数
Marker _chargerSpotToMarker(ChargerSpot spot) {
  return Marker(
    markerId: MarkerId(spot.uuid),
    position: LatLng(spot.latitude, spot.longitude),
  );
}

final sampleMarker = Provider((ref) => <Marker>{
      const Marker(
        markerId: MarkerId('tokyo_station'),
        position: LatLng(35.681236, 139.767125),
      ),
      const Marker(
        markerId: MarkerId('imperial_palace'),
        position: LatLng(35.685175, 139.752799),
      ),
    });
