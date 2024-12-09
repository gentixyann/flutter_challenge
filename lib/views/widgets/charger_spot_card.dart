import 'package:flutter/material.dart';
import 'package:flutter_map_app/charger_spot.dart';
import 'package:flutter_map_app/theme.dart';
import 'package:flutter_svg/svg.dart';

class ChargerSpotCard extends StatelessWidget {
  final ChargerSpot chargerSpot;
  const ChargerSpotCard({
    super.key,
    required this.chargerSpot,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChargerSpotImage(chargerSpot: chargerSpot),
            // 下部の詳細情報部分
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(chargerSpot.name),
                  const SizedBox(height: 8),
                  _Power(chargerSpot.chargerDevices),
                  const SizedBox(height: 8),
                  _Bolt(chargerSpot.chargerDevices),
                  const SizedBox(height: 8),
                  _Time(chargerSpot.serviceTimes),
                  const SizedBox(height: 8),
                  _BusinessDays(chargerSpot.serviceTimes),
                  const SizedBox(height: 8),
                  const _OpenMapAppButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChargerSpotImage extends StatelessWidget {
  final ChargerSpot chargerSpot;

  const _ChargerSpotImage({required this.chargerSpot});

  @override
  Widget build(BuildContext context) {
    String noImagePath = 'assets/card_place_holder.svg';
    const double imageHeight = 72;
    return chargerSpot.imageUrl != null && chargerSpot.imageUrl!.isNotEmpty
        ? Image.network(
            chargerSpot.imageUrl!,
            width: double.infinity,
            height: imageHeight,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) {
              return SvgPicture.asset(
                noImagePath,
                height: imageHeight,
                fit: BoxFit.cover,
              );
            },
          )
        : SvgPicture.asset(
            noImagePath,
            height: imageHeight,
            fit: BoxFit.cover,
          );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    );
  }
}

class _Power extends StatelessWidget {
  const _Power(this.chargerDevices);

  final List<ChargerDevice> chargerDevices;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/power.svg',
        ),
        const Text('充電器数'),
        const SizedBox(width: 15),
        Text('${chargerDevices.length}台'),
      ],
    );
  }
}

class _Bolt extends StatelessWidget {
  const _Bolt(this.chargerDevices);
  final List<ChargerDevice> chargerDevices;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/bolt.svg',
        ),
        const Text('充電出力'),
        const SizedBox(width: 15),
        Text('${chargerDevices.first.power}KW'),
      ],
    );
  }
}

class _Time extends StatelessWidget {
  const _Time(this.serviceTime);
  final List<ServiceTime> serviceTime;

  @override
  Widget build(BuildContext context) {
    final firstServiceTime = serviceTime.isNotEmpty ? serviceTime.first : null;
    final startTime = firstServiceTime?.startTime ?? '';
    final endTime = firstServiceTime?.endTime ?? '';

    return Row(
      children: [
        SvgPicture.asset(
          'assets/watch_later.svg',
        ),
        Text(
          firstServiceTime?.businessDay == true ? '営業中' : '営業時間外',
          style: TextStyle(
            color: firstServiceTime?.businessDay == true
                ? ThemeColor.green
                : ThemeColor.gray,
          ),
        ),
        const SizedBox(width: 25),
        Text('$startTime - $endTime'),
      ],
    );
  }
}

class _BusinessDays extends StatelessWidget {
  const _BusinessDays(this.serviceTime);
  final List<ServiceTime> serviceTime;

  @override
  Widget build(BuildContext context) {
    // 休業日のみを抽出
    final holidays =
        serviceTime.where((serviceTime) => !serviceTime.businessDay);

    // 曜日の文字列を連結
    final holidayString =
        holidays.map((holiday) => holiday.day.name).join(', ');

    return Row(
      children: [
        SvgPicture.asset(
          'assets/today.svg',
        ),
        const Text(
          '定休日',
        ),
        const SizedBox(width: 25),
        Text(holidayString.isNotEmpty ? holidayString : ' - '),
      ],
    );
  }
}

class _OpenMapAppButton extends StatelessWidget {
  const _OpenMapAppButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 地図アプリへのリンク処理
      },
      child: const Row(
        children: [
          Text(
            '地図アプリで経路を見る',
            style: TextStyle(
              color: ThemeColor.green,
              decoration: TextDecoration.underline,
              decorationColor: ThemeColor.green,
            ),
          ),
          Icon(
            Icons.copy,
            color: ThemeColor.green,
            size: 20,
          ),
        ],
      ),
    );
  }
}
