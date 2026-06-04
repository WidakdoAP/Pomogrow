import 'package:flutter/cupertino.dart';
import 'package:pomogrow/features/notes/domain/entities/sticker_entity.dart';

class DraggableSticker extends StatelessWidget {
  final StickerEntity sticker;

  final Function(Offset delta) onMove;

  const DraggableSticker({
    super.key,
    required this.sticker,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: sticker.x,
      top: sticker.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          onMove(details.delta);
        },
        child: Transform.rotate(
          angle: sticker.rotation,
          child: Image.asset(
            sticker.imageUrl,
            width: sticker.width,
            height: sticker.height,
          ),
        ),
      ),
    );
  }
}