import 'package:flutter/material.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/data/type/InputType.dart';
import 'package:loypa/ui/widgets/atom/SRow.dart';
import 'package:styled_widget/styled_widget.dart';

class DesimalInput extends StatelessWidget {
  const DesimalInput({
    Key? key,
    required this.onChange,
    required this.value,
    required this.desimalInput,
  }) : super(key: key);

  final String value;

  final void Function(String) onChange;

  final DesimalInputType desimalInput;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Skriv inn svaret', style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 10),
        SRow(
          mainAxisAlignment: MainAxisAlignment.center,
          separator: const SizedBox(width: 5),
          children: [
            TextField(
              controller: TextEditingController(
                text: value,
              ),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(context, '00,00'),
              onChanged: (value) => onChange(value.replaceAll(',', '.')),
            ).constrained(maxWidth: 150),
            if (desimalInput.enhet != null)
              Text(
                desimalInput.enhet!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
