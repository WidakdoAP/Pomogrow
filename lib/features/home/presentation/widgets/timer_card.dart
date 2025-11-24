import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/home/presentation/widgets/image_slider.dart';

class TimerCard extends StatefulWidget {
  const TimerCard({super.key});

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  ui.Image? thumbImage;
  final List<int> minutes = [25, 50, 75, 100];
  double index = 0;

  @override
  void initState() {
    super.initState();
    _loadThumbImage();
  }

  Future<void> _loadThumbImage() async {
    final data = await rootBundle.load('assets/images/thumb_image.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      thumbImage = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppPallete.blackShadow,
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "WAKTU FOKUS",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppPallete.textBlack,
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: CustomThumbImage(thumbImage!),
                activeTrackColor: AppPallete.gradient1,
                inactiveTrackColor: AppPallete.textTitleColor,
                overlayColor: AppPallete.transparentColor,
              ),
              child: Slider(
                value: index,
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (v) => setState(() => index = v),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${minutes[index.toInt()]} minute",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Divider(thickness: 1, indent: 0),
            Text(
              "Geser daun untuk memilih waktu!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
