// ignore_for_file: library_private_types_in_public_api, always_declare_return_types, type_annotate_public_apis, prefer_int_literals, avoid_redundant_argument_values, prefer_final_locals, prefer_final_in_for_each, prefer_if_elements_to_conditional_expressions, prefer_single_quotes, inference_failure_on_function_return_type, avoid_dynamic_calls, discarded_futures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonViewer extends StatefulWidget {
  final dynamic jsonObj;

  const JsonViewer(
    this.jsonObj, {
    super.key,
  });

  @override
  _JsonViewerState createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  @override
  Widget build(BuildContext context) {
    final content = widget.jsonObj;
    if (content == null) {
      return const SelectableText('{}');
    } else if (content is List) {
      return JsonArrayViewer(content, notRoot: false);
    } else {
      return JsonObjectViewer(
        content,
        notRoot: false,
      );
    }
  }
}

class JsonObjectViewer extends StatefulWidget {
  final Map<String, dynamic> jsonObj;
  final bool notRoot;

  const JsonObjectViewer(
    this.jsonObj, {
    super.key,
    this.notRoot = false,
  });

  @override
  JsonObjectViewerState createState() => JsonObjectViewerState();
}

class JsonObjectViewerState extends State<JsonObjectViewer> {
  late Map<String, bool> _openMapFlag;

  @override
  void initState() {
    _openMapFlag = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getList(),
    );
  }

  _getList() {
    List<Widget> list = [];
    for (MapEntry<String, dynamic> entry in widget.jsonObj.entries) {
      bool ex = isExtensible(entry.value);
      bool ink = isInkWell(entry.value);
      final isOpen = _openMapFlag[entry.key] ?? false;
      list.add(
        Row(
          children: <Widget>[
            ex
                ? InkWell(
                    onTap: () => _toggle(entry.key),
                    child: Icon(
                      isOpen ? Icons.arrow_drop_down : Icons.arrow_right,
                      size: 14,
                      color: Colors.grey[700],
                    ),
                  )
                : const InkWell(child: Icon(Icons.add, color: Colors.transparent, size: 14)),
            ex && ink
                ? SelectableText(entry.key, style: const TextStyle(color: Colors.black))
                : SelectableText(
                    entry.key,
                    style: TextStyle(color: entry.value == null ? Colors.grey : Colors.black),
                  ),
            const Text(':', style: TextStyle(color: Colors.grey)),
            const Padding(padding: EdgeInsets.only(left: 3)),
            getValueWidget(entry)
          ],
        ),
      );
      list.add(const Padding(padding: EdgeInsets.only(top: 4)));
      if (isOpen) {
        list.add(getContentWidget(entry.value));
      }
    }
    return list;
  }

  void _toggle(String str) => setState(() => _openMapFlag[str] = !(_openMapFlag[str] ?? false));

  static getContentWidget(dynamic content) {
    if (content is List) {
      return JsonArrayViewer(content, notRoot: true);
    } else {
      return JsonObjectViewer(content, notRoot: true);
    }
  }

  static isInkWell(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    } else if (content is List) {
      if (content.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  getValueWidget(MapEntry<String, dynamic> entry) {
    if (entry.value == null) {
      return const Expanded(
        child: SelectableText(
          'undefined',
          style: TextStyle(color: Colors.grey),
        ),
      );
    } else if (entry.value is int) {
      return Expanded(
        child: SelectableText(
          entry.value.toString(),
          style: const TextStyle(color: Color(0xff6491b3)),
        ),
      );
    } else if (entry.value is String) {
      return Expanded(
        child: SelectableText(
          "\"${entry.value}\"",
          style: const TextStyle(color: Color(0xff6a8759)),
        ),
      );
    } else if (entry.value is bool) {
      return Expanded(
        child: SelectableText(
          entry.value.toString(),
          style: const TextStyle(color: Color(0xffca7832)),
        ),
      );
    } else if (entry.value is double) {
      return Expanded(
        child: SelectableText(
          entry.value.toString(),
          style: const TextStyle(color: Color(0xff6491b3)),
        ),
      );
    } else if (entry.value is List) {
      if (entry.value.isEmpty) {
        return InkWell(
          onTap: () => _toggle(entry.key),
          onDoubleTap: () => Clipboard.setData(ClipboardData(
            text: jsonEncode(entry.value),
          )).then(
            (_) => ScaffoldMessenger.of(context).showSnackBar(const CustomSnackBar()),
          ),
          child: const Text('Array[0]', style: TextStyle(color: Colors.grey)),
        );
      } else {
        return InkWell(
          onTap: () => _toggle(entry.key),
          onDoubleTap: () => Clipboard.setData(ClipboardData(text: jsonEncode(entry.value))).then(
            (_) => ScaffoldMessenger.of(context).showSnackBar(const CustomSnackBar()),
          ),
          child: Text(
            'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }
    }
    return InkWell(
      onTap: () => _toggle(entry.key),
      onDoubleTap: () => Clipboard.setData(ClipboardData(text: jsonEncode(entry.value))).then(
        (_) => ScaffoldMessenger.of(context).showSnackBar(const CustomSnackBar()),
      ),
      child: const Text('Object', style: TextStyle(color: Colors.grey)),
    );
  }

  static isExtensible(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    }
    return true;
  }

  static getTypeName(dynamic content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    }
    return 'Object';
  }
}

class JsonArrayViewer extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool notRoot;

  const JsonArrayViewer(this.jsonArray, {super.key, this.notRoot = false});

  @override
  _JsonArrayViewerState createState() => _JsonArrayViewerState();
}

class _JsonArrayViewerState extends State<JsonArrayViewer> {
  late List<bool> _openListFlag;

  @override
  void initState() {
    super.initState();
    _openListFlag = List.filled(widget.jsonArray.length, false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getList(),
    );
  }

  _getList() {
    List<Widget> list = [];
    for (int i = 0; i < widget.jsonArray.length; i++) {
      final content = widget.jsonArray[i];
      bool ex = JsonObjectViewerState.isExtensible(content);
      bool ink = JsonObjectViewerState.isInkWell(content);
      final isListOpen = _openListFlag[i];
      list.add(
        Row(
          children: <Widget>[
            ex
                ? InkWell(
                    onTap: () => _toggleList(i),
                    child: Icon(
                      isListOpen ? Icons.arrow_drop_down : Icons.arrow_right,
                      size: 14,
                      color: Colors.grey[700],
                    ),
                  )
                : const InkWell(child: Icon(Icons.arrow_right, color: Colors.transparent, size: 14)),
            ex && ink
                ? getInkWell(i)
                : Text(
                    '[$i]',
                    style: TextStyle(color: content == null ? Colors.grey : Colors.black),
                  ),
            const Text(':', style: TextStyle(color: Colors.grey)),
            const Padding(padding: EdgeInsets.only(left: 3)),
            getValueWidget(content, i)
          ],
        ),
      );
      list.add(const Padding(padding: EdgeInsets.only(top: 4)));
      if (_openListFlag[i]) {
        list.add(JsonObjectViewerState.getContentWidget(content));
      }
    }
    return list;
  }

  void _toggleList(int i) => setState(() => _openListFlag[i] = !_openListFlag[i]);

  getInkWell(int i) => Text('[$i]', style: const TextStyle(color: Colors.black));

  getValueWidget(dynamic content, int index) {
    if (content == null) {
      return const Expanded(
        child: SelectableText(
          'undefined',
          style: TextStyle(color: Colors.grey),
        ),
      );
    } else if (content is int) {
      return Expanded(
        child: SelectableText(
          content.toString(),
          style: const TextStyle(color: Color(0xff6491b3)),
        ),
      );
    } else if (content is String) {
      return Expanded(
        child: SelectableText(
          "\"$content\"",
          style: const TextStyle(color: Color(0xff6a8759)),
        ),
      );
    } else if (content is bool) {
      return Expanded(
        child: SelectableText(
          content.toString(),
          style: const TextStyle(color: Color(0xffca7832)),
        ),
      );
    } else if (content is double) {
      return Expanded(
        child: SelectableText(
          content.toString(),
          style: const TextStyle(color: Color(0xff6491b3)),
        ),
      );
    } else if (content is List) {
      if (content.isEmpty) {
        return InkWell(
          onTap: () {
            setState(() {
              _openListFlag[index] = !_openListFlag[index];
            });
          },
          onDoubleTap: () {
            Clipboard.setData(ClipboardData(text: jsonEncode(content))).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(const CustomSnackBar());
            });
          },
          child: const Text(
            'Array[0]',
            style: TextStyle(color: Colors.grey),
          ),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              _openListFlag[index] = !_openListFlag[index];
            });
          },
          onDoubleTap: () {
            Clipboard.setData(ClipboardData(text: jsonEncode(content))).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(const CustomSnackBar());
            });
          },
          child: Text(
            'Array<${JsonObjectViewerState.getTypeName(content)}>[${content.length}]',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        setState(() {
          _openListFlag[index] = !_openListFlag[index];
        });
      },
      onDoubleTap: () {
        Clipboard.setData(ClipboardData(text: jsonEncode(content))).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const CustomSnackBar());
        });
      },
      child: const Text(
        'Object',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class CustomSnackBar extends SnackBar {
  const CustomSnackBar({
    super.key,
    super.backgroundColor = Colors.yellow,
    super.content = const Text(
      'Copied to your clipboard !',
      style: TextStyle(color: Colors.black),
    ),
  });

  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: content,
    );
  }
}
