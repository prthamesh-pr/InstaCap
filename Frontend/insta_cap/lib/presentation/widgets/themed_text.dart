import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A helper widget that ensures proper text colors based on context
class ThemedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final bool primary;
  final bool onGlass;
  final bool onGradient;
  final Color? color;

  const ThemedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.primary = true,
    this.onGlass = false,
    this.onGradient = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;

    if (color != null) {
      textColor = color!;
    } else if (onGradient) {
      textColor = AppColors.textOnGradient;
    } else if (onGlass) {
      textColor = AppTheme.getTextOnGlassColor(context);
    } else {
      textColor = AppTheme.getTextColor(context, primary: primary);
    }

    return Text(
      text,
      style: (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
        color: textColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

/// Specialized text widgets for common use cases
class HeadlineText extends StatelessWidget {
  final String text;
  final bool onGlass;
  final bool onGradient;
  final Color? color;

  const HeadlineText(
    this.text, {
    super.key,
    this.onGlass = false,
    this.onGradient = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedText(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
      onGlass: onGlass,
      onGradient: onGradient,
      color: color,
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final bool onGlass;
  final bool onGradient;
  final Color? color;

  const TitleText(
    this.text, {
    super.key,
    this.onGlass = false,
    this.onGradient = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedText(
      text,
      style: Theme.of(context).textTheme.titleMedium,
      onGlass: onGlass,
      onGradient: onGradient,
      color: color,
    );
  }
}

class BodyText extends StatelessWidget {
  final String text;
  final bool primary;
  final bool onGlass;
  final bool onGradient;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;

  const BodyText(
    this.text, {
    super.key,
    this.primary = true,
    this.onGlass = false,
    this.onGradient = false,
    this.color,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedText(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
      primary: primary,
      onGlass: onGlass,
      onGradient: onGradient,
      color: color,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class CaptionText extends StatelessWidget {
  final String text;
  final bool onGlass;
  final bool onGradient;
  final Color? color;

  const CaptionText(
    this.text, {
    super.key,
    this.onGlass = false,
    this.onGradient = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedText(
      text,
      style: Theme.of(context).textTheme.bodySmall,
      primary: false,
      onGlass: onGlass,
      onGradient: onGradient,
      color: color,
    );
  }
}
