import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_app/charger_spots_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'charger_spot_provider.dart';

// マーカーを管理する StateNotifier
class MarkerNotifier extends StateNotifier<Set<Marker>> {
  MarkerNotifier() : super({});

  // マーカーを設定
  void setMarkers(Set<Marker> markers) {
    state = markers;
  }

  // 充電スポットレスポンスからマーカーを更新
  void updateMarkersFromResponse(GetChargerSpotsResponse response) {
    final newMarkers = response.spots
        .map(
          (spot) => Marker(
            markerId: MarkerId(spot.uuid),
            position: LatLng(spot.latitude, spot.longitude),
          ),
        )
        .toSet();
    setMarkers(newMarkers);
  }
}

// マーカー管理用の StateNotifierProvider
final markerProvider = StateNotifierProvider<MarkerNotifier, Set<Marker>>(
    (ref) => MarkerNotifier());
