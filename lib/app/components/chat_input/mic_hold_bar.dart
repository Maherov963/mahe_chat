import 'package:mahe_chat/data/extensions/extension.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class MicHoldBar extends ConsumerWidget {
  const MicHoldBar({
    super.key,
    required this.time,
    required this.onDelete,
  });
  final void Function()? onDelete;
  final String time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final micWatch = ref.watch(micProvicer);
    final theme = Theme.of(context);
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete,
                color: theme.colorScheme.error,
              ),
            ),
            10.getWidthSizedBox,
            Text(time),
            Expanded(
              child: AnimatedContainer(
                duration: Duration.zero,
                transform: Matrix4.translationValues(
                    micWatch.offset.dx, 0, 0), //_position.dx
                child: Shimmer.fromColors(
                  baseColor: theme.colorScheme.primary,
                  highlightColor: theme.colorScheme.inverseSurface,
                  child: Text(
                    "اسحب للالغاء ---> ",
                    textDirection:
                        Directionality.of(context).trigDirectionality,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
