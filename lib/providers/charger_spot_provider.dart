import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_app/charger_spot.dart';
import 'package:flutter_map_app/charger_spots_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final chargerSpotsRepositoryProvider =
    Provider((ref) => ChargerSpotsRepository());

// 地図範囲内の充電スポットを非同期で取得するProvider
final chargerSpotsProvider =
    FutureProvider.family<GetChargerSpotsResponse, Map<String, double>>(
  (ref, region) async {
    final repository = ref.watch(chargerSpotsRepositoryProvider);
    return await repository.getChargerSpots(
      swLat: region['swLat']!,
      swLng: region['swLng']!,
      neLat: region['neLat']!,
      neLng: region['neLng']!,
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
