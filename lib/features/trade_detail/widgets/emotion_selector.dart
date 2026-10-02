import 'package:flutter/material.dart';

import '../../../core/constants/labels.dart';
import '../../../data/repository/trade_repository.dart';

class EmotionSelector extends StatelessWidget {
  const EmotionSelector({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final EmotionState? value;
  final bool enabled;
  final ValueChanged<EmotionState?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final emotion in EmotionState.values)
          ChoiceChip(
            label: Text(emotion.label),
            selected: value == emotion,
            // Tap chip yang sudah terpilih untuk mengosongkan pilihan.
            onSelected: enabled
                ? (selected) => onChanged(selected ? emotion : null)
                : null,
          ),
      ],
    );
  }
}
