import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_app/theme.dart';
import 'package:flutter_svg/svg.dart';

class ChargerSpotCard extends StatelessWidget {
  const ChargerSpotCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/card_place_holder.svg',
            fit: BoxFit.fill,
          ),
          // 下部の詳細情報部分
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(),
                SizedBox(height: 8),
                _Power(),
                SizedBox(height: 8),
                _Bolt(),
                SizedBox(height: 8),
                _Time(),
                SizedBox(height: 8),
                _BusinessDays(),
                SizedBox(height: 8),
                _OpenMapAppButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '八景島シーパラダイス',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    );
  }
}

class _Power extends StatelessWidget {
  const _Power();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/power.svg',
        ),
        const Text('充電器数'),
        const SizedBox(width: 15),
        const Text('8台'),
      ],
    );
  }
}

class _Bolt extends StatelessWidget {
  const _Bolt();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/bolt.svg',
        ),
        const Text('充電出力'),
        const SizedBox(width: 15),
        const Text('3.2kW、6.0KW'),
      ],
    );
  }
}

class _Time extends StatelessWidget {
  const _Time();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/watch_later.svg',
        ),
        const Text(
          '営業中',
          style: TextStyle(
            color: ThemeColor.green,
          ),
        ),
        const SizedBox(width: 25),
        const Text(
          '10:00 - 19:00',
        ),
      ],
    );
  }
}

class _BusinessDays extends StatelessWidget {
  const _BusinessDays();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/today.svg',
        ),
        const Text(
          '定休日',
        ),
        const SizedBox(width: 25),
        const Text(
          '土曜日',
        ),
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
