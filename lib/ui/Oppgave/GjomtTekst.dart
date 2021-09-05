import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/molekyl/MultiInput.dart';
import 'package:styled_widget/styled_widget.dart';

class GjomtTekst extends StatelessWidget {
  const GjomtTekst({
    Key? key,
    required this.tekst,
    required this.onChange,
    this.placeholder,
    required this.value,
  }) : super(key: key);

  final List<String> tekst;

  final List<String>? placeholder;

  final void Function(String) onChange;

  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              ...tekst
                  .asMap()
                  .map(
                    (i, e) {
                      return MapEntry(
                        i,
                        TextSpan(
                          children: [
                            TextSpan(text: e),
                            if (i != tekst.length - 1)
                              WidgetSpan(
                                child: Text(
                                  (i + 1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                )
                                    .decorated(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(5),
                                    )
                                    .constrained(width: 30, height: 15)
                                    .padding(horizontal: 5),
                              ),
                          ],
                        ),
                      );
                    },
                  )
                  .values
                  .toList(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Skriv inn svaret', style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 10),
        MultiInput(
          onChange: onChange,
          length: tekst.length - 1,
          keyboardType: TextInputType.text,
          placeholder: placeholder,
          value: value,
        )
      ],
    );
  }
}
