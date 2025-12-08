import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/home/presentation/widgets/image_slider.dart';

class TimerCard extends StatelessWidget {
  final List<int> minutes;
  final double index;
  final ValueChanged<double> onChanged;
  final ui.Image? thumbImage;
  const TimerCard({
    super.key,
    required this.minutes,
    required this.index,
    required this.onChanged,
    required this.thumbImage,
  });

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
                activeTickMarkColor: AppPallete.transparentColor,
                inactiveTrackColor: AppPallete.textTitleColor,
                inactiveTickMarkColor: AppPallete.transparentColor,
                overlayColor: AppPallete.transparentColor,
                trackHeight: 12,
              ),
              child: Slider(
                value: index,
                min: 0,
                max: (minutes.length - 1).toDouble(),
                divisions: minutes.length - 1,
                onChanged: onChanged,
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

// class _TimerCardState extends State<TimerCard> {
//   @override
//   void initState() {
//     super.initState();
//     _loadThumbImage();
//   }

//   Future<void> _loadThumbImage() async {
//     final data = await rootBundle.load('assets/images/thumb_image.png');
//     final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
//     final frame = await codec.getNextFrame();
//     setState(() {
//       widget.thumbImage = frame.image;
//     });
//   }
// }
