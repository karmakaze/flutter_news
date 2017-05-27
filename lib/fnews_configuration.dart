import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeName { light, dark }

const ThemeName defaultTheme = ThemeName.light;

const String prefsKeyTheme = "theme";
const String prefsKeyShowFullComment = "showFullComment";
const String prefsKeyExpandCommentTree = "expandCommentTree";

Future<Null> storeThemeToPrefs(ThemeName themeName) async {
  assert(themeName != null);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(prefsKeyTheme, themeName.toString());
}

Future<Null> storeShowFullCommentToPrefs(bool showFullComment) async {
  assert(showFullComment != null);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(prefsKeyShowFullComment, showFullComment);
}

class FlutterNewsConfiguration {
  FlutterNewsConfiguration({
    @required this.themeName,
    @required this.showFullComment,
    @required this.expandCommentTree,
  }) {
    assert(themeName != null);
    assert(showFullComment != null);
    assert(expandCommentTree != null);
  }

  final ThemeName themeName;
  final bool showFullComment;
  final bool expandCommentTree;

  FlutterNewsConfiguration copyWith(
      {ThemeName themeName, bool showFullComment, bool expandCommentTree}) {
    return new FlutterNewsConfiguration(
      themeName: themeName ?? this.themeName,
      showFullComment: showFullComment ?? this.showFullComment,
      expandCommentTree: expandCommentTree ?? this.expandCommentTree,
    );
  }

  static Future<FlutterNewsConfiguration> loadFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve theme name
    ThemeName themeName;
    final String themeString =
        prefs.getString(prefsKeyTheme) ?? defaultTheme.toString();

    switch (themeString) {
      case 'ThemeName.dark':
        themeName = ThemeName.dark;
        break;
      case 'ThemeName.light':
      default:
        themeName = ThemeName.light;
        break;
    }

    // Retrieve show full comment setting
    final bool showFullComment =
        prefs.getBool(prefsKeyShowFullComment) ?? false;

    // Retrieve expand comments setting
    final bool expandCommentTree =
        prefs.getBool(prefsKeyExpandCommentTree) ?? false;

    return new FlutterNewsConfiguration(
      themeName: themeName,
      showFullComment: showFullComment,
      expandCommentTree: expandCommentTree,
    );
  }
}
