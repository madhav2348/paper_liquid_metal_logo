import 'package:flutter/material.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_logo_state.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_shader_controller.dart';
import 'package:paper_liquid_metal_logo/simple_slider.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LiquidMetalShaderController>();

    final controls = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        children: [
          const _BackgroundControl(),
          _Control(
            label: 'Dispersion',
            parameter: controller.dispersion,
          ),
          _Control(
            label: 'Edge',
            parameter: controller.edge,
          ),
          _Control(
            label: 'Pattern Blur',
            parameter: controller.patternBlur,
          ),
          _Control(
            label: 'Liquify',
            parameter: controller.liquid,
          ),
          _Control(
            label: 'Speed',
            parameter: controller.speed,
          ),
          _Control(
            label: 'Pattern Scale',
            parameter: controller.patternScale,
          ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x33FFFFFF)),
        ),
      ),
      child: Builder(
        builder: (context) {
          final windowWidth = MediaQuery.sizeOf(context).width;

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: windowWidth >= 1200 ? 500 : double.infinity,
              maxWidth: 500,
            ),
            child: controls,
          );
        },
      ),
    );
  }
}

class _BackgroundControl extends StatelessWidget {
  const _BackgroundControl();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24,
      children: [
        const Expanded(
          child: _Label(label: 'Background'),
        ),
        Builder(
          builder: (context) {
            final width = MediaQuery.sizeOf(context).width;
            final isCompactLayout = width < 600;

            return SizedBox(
              width: isCompactLayout ? 200 : 284,
              child: Row(
                spacing: 8,
                children: [
                  for (final background in LiquidMetalLogoBackground.values)
                    _BackgroundCircle(background: background),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  const _BackgroundCircle({
    required this.background,
  });

  final LiquidMetalLogoBackground background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<LiquidMetalLogoState>().background = background;
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: background == LiquidMetalLogoBackground.black
                    ? const BorderSide(color: Color(0x4DFFFFFF))
                    : BorderSide.none,
              ),
              gradient: background.gradient,
            ),
            child: const SizedBox.square(dimension: 28),
          ),
        ),
      ),
    );
  }
}

class _Control extends StatelessWidget {
  const _Control({
    required this.label,
    required this.parameter,
  });

  final String label;

  final LiquidMetalShaderEditableParameter parameter;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24,
      children: [
        Expanded(
          child: _Label(label: label),
        ),
        RepaintBoundary(
          child: ValueListenableBuilder(
            valueListenable: parameter,
            builder: (context, value, _) {
              final width = MediaQuery.sizeOf(context).width;
              final isCompactLayout = width < 600;

              return Row(
                spacing: 24,
                children: [
                  SizedBox(
                    width: isCompactLayout ? 200 : 160,
                    child: SimpleSlider(
                      value: value,
                      minValue: parameter.minValue,
                      maxValue: parameter.maxValue,
                      onChanged: (value) {
                        parameter.value = value;
                      },
                    ),
                  ),
                  if (!isCompactLayout) _ValuePreview(value: value),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w400,
        fontSize: 18,
        height: 28 / 18,
        letterSpacing: -0.68,
        color: Colors.white,
      ),
    );
  }
}

class _ValuePreview extends StatelessWidget {
  const _ValuePreview({
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Color(0x26FFFFFF),
      ),
      child: SizedBox(
        height: 40,
        width: 100,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              value % 1 == 0
                  ? value.toStringAsFixed(0)
                  : value.toStringAsFixed(3),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 24 / 16,
                letterSpacing: -0.68,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
