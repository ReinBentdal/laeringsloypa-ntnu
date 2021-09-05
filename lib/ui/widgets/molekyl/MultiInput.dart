import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/SRow.dart';
import 'package:styled_widget/styled_widget.dart';

class MultiInput extends StatefulWidget {
  const MultiInput({
    Key? key,
    required this.onChange,
    this.length = 4,
    this.digits = 1,
    this.placeholder,
    this.keyboardType = TextInputType.number,
    required this.value,
  }) :
        // assert((placeholder?.length ?? length) == length, 'Antall felt-beskrivelser stemmer ikke overens med antall felt i pinkoden'),
        super(key: key);

  final int length;

  final int digits;

  final List<String>? placeholder;

  final TextInputType keyboardType;

  final void Function(String) onChange;

  final String value;

  @override
  _MultiInputState createState() => _MultiInputState();
}

class _MultiInputState extends State<MultiInput> {
  List<FocusNode> _focusNodes = [];
  List<String?> _values = [];
  int focusIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.value.split('-').forEach((e) => _values.add(e));
    final valuesLength = _values.length;
    for (int i = 0; i < widget.length; i++) {
      _focusNodes.add(
        FocusNode()
          ..addListener(() {
            if (_focusNodes[i].hasFocus && focusIndex != i) focusIndex = i;
          }),
      );
      if (valuesLength <= i) _values.add('');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNodes.forEach((e) => e.dispose());
  }

  void generateTotalValue() {
    if (widget.keyboardType == TextInputType.number) {
      _values.forEach((e) {
        if (e != null && e != '') e = int.parse(e.trim()).toString();
      });
    }
    final value = _values.join('-') + '';
    widget.onChange(value);
  }

  void handleFocus() {
    if (widget.keyboardType == TextInputType.number &&
        (_values[focusIndex]?.length ?? 0) == widget.digits) {
      _focusNodes[focusIndex].unfocus();
      if (focusIndex + 1 != widget.length) {
        focusIndex++;
        _focusNodes[focusIndex].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final erTall = widget.keyboardType == TextInputType.number;
    return SRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.min,
      separator: const SizedBox(width: 10),
      children: [
        for (int i = 0; i < widget.length; i++)
          TextField(
            controller: TextEditingController(text: _values[i]),
            focusNode: _focusNodes.elementAt(i),
            textAlign: TextAlign.center,
            keyboardType: widget.keyboardType,
            maxLength: erTall ? widget.digits : null,
            decoration: InputDecoration(
              hintText: (() {
                if (erTall) {
                  return widget.placeholder?[i];
                } else if (widget.keyboardType == TextInputType.text) {
                  return '${(i + 1).toString()}. ord';
                }
                return null;
              })(),
              fillColor: Colors.orange[50],
              focusColor: Colors.grey[300],
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF0095FA),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF06314C),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.shade200,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
            ),
            onChanged: (String value) {
              _values[i] = value;
              generateTotalValue();
              handleFocus();
            },
          )
              .constrained(maxWidth: erTall ? 50 : double.infinity)
              .expanded(flex: erTall ? 0 : 1),
      ],
    );
  }
}
