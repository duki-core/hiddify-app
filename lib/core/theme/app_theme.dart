import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiddify/core/theme/app_theme_mode.dart';
import 'package:hiddify/core/theme/theme_extensions.dart';

class AppTheme {
  AppTheme(this.mode, this.fontFamily);
  final AppThemeMode mode;
  final String fontFamily;
  static const List<String> _monoStack = ['Cascadia Mono', 'Consolas', 'Menlo', 'DejaVu Sans Mono', 'monospace'];

  ThemeData lightTheme(ColorScheme? lightColorScheme) => _monoTheme(Brightness.light);
  ThemeData darkTheme(ColorScheme? darkColorScheme) => _monoTheme(Brightness.dark);
  ThemeData _monoTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme base = ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
    );
    final Color bg = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF4F4F4);
    final ColorScheme scheme = base.copyWith(
      surface: bg,
      error: isDark ? const Color(0xFFE5736F) : const Color(0xFFB3261E),
    );

    const RoundedRectangleBorder square = RoundedRectangleBorder(borderRadius: BorderRadius.zero);
    final BorderSide line = BorderSide(color: scheme.outlineVariant);
    final OutlineInputBorder inputBorder = OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: line);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      fontFamily: _monoStack.first,
      fontFamilyFallback: _monoStack.sublist(1),
      visualDensity: VisualDensity.compact,
      splashFactory: NoSplash.splashFactory,
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(backgroundColor: bg, elevation: 0, scrolledUnderElevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        color: bg,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: line),
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: line),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(shape: square, elevation: 0)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shape: square, elevation: 0)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(shape: square)),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: square, side: BorderSide(color: scheme.onSurface)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: scheme.onSurface),
        ),
      ),
      listTileTheme: const ListTileThemeData(shape: square),
      chipTheme: const ChipThemeData(shape: square),
      extensions: const <ThemeExtension<dynamic>>{ConnectionButtonTheme.light},
    );
  }

  CupertinoThemeData cupertinoThemeData(bool sysDark, ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
    final bool isDark = switch (mode) {
      AppThemeMode.system => sysDark,
      AppThemeMode.light => false,
      AppThemeMode.dark => true,
      AppThemeMode.black => true,
    };
    final def = CupertinoThemeData(brightness: isDark ? Brightness.dark : Brightness.light);

    final defaultMaterialTheme = isDark ? darkTheme(darkColorScheme) : lightTheme(lightColorScheme);
    return MaterialBasedCupertinoThemeData(
      materialTheme: defaultMaterialTheme.copyWith(
        cupertinoOverrideTheme: def.copyWith(
          textTheme: CupertinoTextThemeData(
            textStyle: def.textTheme.textStyle.copyWith(fontFamily: fontFamily),
            actionTextStyle: def.textTheme.actionTextStyle.copyWith(fontFamily: fontFamily),
            navActionTextStyle: def.textTheme.navActionTextStyle.copyWith(fontFamily: fontFamily),
            navTitleTextStyle: def.textTheme.navTitleTextStyle.copyWith(fontFamily: fontFamily),
            navLargeTitleTextStyle: def.textTheme.navLargeTitleTextStyle.copyWith(fontFamily: fontFamily),
            pickerTextStyle: def.textTheme.pickerTextStyle.copyWith(fontFamily: fontFamily),
            dateTimePickerTextStyle: def.textTheme.dateTimePickerTextStyle.copyWith(fontFamily: fontFamily),
            tabLabelTextStyle: def.textTheme.tabLabelTextStyle.copyWith(fontFamily: fontFamily),
          ).copyWith(),
          barBackgroundColor: def.barBackgroundColor,
          scaffoldBackgroundColor: def.scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
