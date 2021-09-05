import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/data/type/InputType.dart';
import 'package:loypa/ui/widgets/atom/SRow.dart';
import 'package:styled_widget/styled_widget.dart';

class HeltallInput extends StatelessWidget {
  const HeltallInput({
    Key? key,
    required this.value,
    required this.onChange,
    required this.heltallInput,
  }) : super(key: key);

  final String value;

  final void Function(String) onChange;

  final HeltallInputType heltallInput;

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
              decoration: inputDecoration(context, '00'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: onChange,
            ).constrained(maxWidth: 150),
            if (heltallInput.enhet != null)
              Text(
                heltallInput.enhet!,
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
