import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class MuteMateSlidingPill extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onSegmentChosen;

  const MuteMateSlidingPill({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSegmentChosen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / labels.length;
          
          return Stack(
            children: [
              // Sliding Indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                alignment: Alignment(
                  -1.0 + (selectedIndex * (2.0 / (labels.length - 1))),
                  0.0,
                ),
                child: Container(
                  width: segmentWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Labels
              Row(
                children: List.generate(
                  labels.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () => onSegmentChosen(index),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: selectedIndex == index
                                ? AppColors.onPrimary
                                : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          child: Text(labels[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
