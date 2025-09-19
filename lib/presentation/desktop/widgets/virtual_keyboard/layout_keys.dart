import 'key_action.dart';
import 'layouts.dart';

abstract class VirtualKeyboardLayoutKeys {
  int activeIndex = 0;

  bool showSymbol = false;

  List<List> get defaultEnglishLayout => _defaultEnglishLayout;
  List<List> get defaultRussianLayout => _defaultRussianLayout;

  List<List> get activeLayout {
    var layout = getLanguage(activeIndex);
    return List<List>.from(layout)..removeAt(showSymbol ? 0 : 1);
  }

  int getLanguagesCount();
  List<List> getLanguage(int index);

  void switchLanguage() {
    if ((activeIndex + 1) == getLanguagesCount()) {
      activeIndex = 0;
    } else {
      activeIndex++;
    }
  }
}

class VirtualKeyboardDefaultLayoutKeys extends VirtualKeyboardLayoutKeys {
  List<VirtualKeyboardDefaultLayouts> defaultLayouts;
  VirtualKeyboardDefaultLayoutKeys(this.defaultLayouts);

  @override
  int getLanguagesCount() => defaultLayouts.length;

  @override
  List<List> getLanguage(int index) {
    switch (defaultLayouts[index]) {
      case VirtualKeyboardDefaultLayouts.English:
        return _defaultEnglishLayout;
      case VirtualKeyboardDefaultLayouts.Russian:
        return _defaultRussianLayout;
    }
  }
}

/// Keys for Virtual Keyboard's rows.
const List<List> _defaultEnglishLayout = [
  [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    VirtualKeyboardKeyAction.Backspace
  ],
  [
    '.',
    '@',
    '#',
    '\$',
    '%',
    ',',
    '*',
    '(',
    ')',
    '-',
    '+',
    '=',
    VirtualKeyboardKeyAction.Backspace
  ],
  [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
    '{',
    '}',
  ],
  [
    '',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    ';',
    '\'',
    '"',
  ],
  [
    'z',
    'x',
    'c',
    'v',
    'supplies_1c',
    'n',
    'm',
    ':',
    '/',
    '_',
    '[',
    ']',
  ],
  [
    VirtualKeyboardKeyAction.Shift,
    VirtualKeyboardKeyAction.Symbol,
    VirtualKeyboardKeyAction.SwithLanguage,
    VirtualKeyboardKeyAction.Space,
    VirtualKeyboardKeyAction.Return,
  ]
];

const List<List> _defaultRussianLayout = [
  [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    VirtualKeyboardKeyAction.Backspace
  ],
  [
    '.',
    '@',
    '#',
    '\$',
    '%',
    ',',
    '*',
    '(',
    ')',
    '-',
    '+',
    '=',
    VirtualKeyboardKeyAction.Backspace
  ],
  [
    'й',
    'ц',
    'у',
    'к',
    'е',
    'н',
    'г',
    'ш',
    'щ',
    'з',
    'х',
    'ъ',
  ],
  [
    'ф',
    'ы',
    'в',
    'а',
    'п',
    'р',
    'о',
    'л',
    'д',
    'ж',
    'э',
    '\'',
  ],
  ['я', 'ч', 'с', 'м', 'и', 'т', 'ь', 'б', 'ю', '/', '"', ':'],
  [
    VirtualKeyboardKeyAction.Shift,
    VirtualKeyboardKeyAction.Symbol,
    VirtualKeyboardKeyAction.SwithLanguage,
    VirtualKeyboardKeyAction.Space,
    VirtualKeyboardKeyAction.Return
  ]
];
