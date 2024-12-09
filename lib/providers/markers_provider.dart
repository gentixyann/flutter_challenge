import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map_app/charger_spot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_app/charger_spots_repository.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'charger_spot_provider.dart';

// SVGからBitmapDescriptorを生成する関数
Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
  String assetName, [
  Size size = const Size(48, 48), // デフォルトサイズを 48x48 に変更
]) async {
  // SVGアセットを読み込む
  final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

  // デバイスのPixel Ratioを取得
  double devicePixelRatio =
      ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
  int width = (size.width * devicePixelRatio).toInt();
  int height = (size.height * devicePixelRatio).toInt();

  // スケール計算
  final scaleFactor = min(
    width / pictureInfo.size.width,
    height / pictureInfo.size.height,
  );

  // 描画処理
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder)
    ..scale(scaleFactor)
    ..drawPicture(pictureInfo.picture);

  // ピクチャをイメージに変換
  final rasterPicture = recorder.endRecording();
  final image = rasterPicture.toImageSync(width, height);

  // バイトデータに変換
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

  // マーカーアイコンとして返す
  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}

// マーカーを管理する StateNotifier
class MarkerNotifier extends StateNotifier<Set<Marker>> {
  MarkerNotifier() : super({});

  // マーカーを設定
  void setMarkers(Set<Marker> markers) {
    state = markers;
  }

  // 充電スポットリストからマーカーを生成して更新するメソッド
  Future<void> updateMarkersFromChargerSpots(List<ChargerSpot> spots) async {
    final futures = spots.map((spot) async {
      final icon = await _bitmapDescriptorFromSvgAsset('assets/Marker.svg');
      return Marker(
        markerId: MarkerId(spot.uuid),
        position: LatLng(spot.latitude, spot.longitude),
        icon: icon,
        onTap: () => print('マーカー押した'),
      );
    }).toList();

    final newMarkers = await Future.wait(futures);
    setMarkers(newMarkers.toSet());
  }

  // 充電スポットレスポンスからマーカーを非同期で更新
  Future<void> updateMarkersFromResponse(
      GetChargerSpotsResponse response) async {
    // 各スポットの非同期マーカー生成をリスト化
    final futures = response.spots.map((spot) async {
      // SVGアイコンを非同期で生成
      final icon = await _bitmapDescriptorFromSvgAsset('assets/Marker.svg');
      return Marker(
        markerId: MarkerId(spot.uuid),
        position: LatLng(spot.latitude, spot.longitude),
        icon: icon,
        onTap: () => print('マーカー押した'),
      );
    }).toList();

    // 非同期マーカー生成の結果を待つ
    final newMarkers = await Future.wait(futures);

    // 新しいマーカーを設定
    setMarkers(newMarkers.toSet());
  }
}

// マーカー管理用の StateNotifierProvider
final markerProvider = StateNotifierProvider<MarkerNotifier, Set<Marker>>(
    (ref) => MarkerNotifier());
