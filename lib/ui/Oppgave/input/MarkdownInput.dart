import 'package:flutter/material.dart';
import 'package:loypa/config/markdown/markdown_builders.dart';
import 'package:loypa/config/markdown/markdown_stylesheet.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/data/type/InputType.dart';
import 'package:loypa/ui/widgets/molekyl/MarkdownNoScroll.dart';
import 'package:styled_widget/styled_widget.dart';

class MarkdownInput extends StatelessWidget {
  const MarkdownInput({
    Key? key,
    required this.value,
    required this.onChange,
    required this.markdownInput,
  }) : super(key: key);

  final String value;

  final void Function(String) onChange;

  final MarkdownTekstInputType markdownInput;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MarkdownNoScroll(
          imageBuilder: imageBuilder,
          styleSheet: markdownStylesheet(context).copyWith(
            textAlign: WrapAlignment.center,
            h3Align: WrapAlignment.center,
            h4Align: WrapAlignment.center,
          ),
          data: markdownInput.innhold,
        ).padding(vertical: 20),
        Text('Skriv inn svaret', style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: value,
          ),
          decoration: inputDecoration(context, 'Skriv her...'),
          onChanged: onChange,
        ),
      ],
    );
  }
}
