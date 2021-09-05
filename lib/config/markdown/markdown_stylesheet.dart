import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final markdownStylesheet = (BuildContext context) => MarkdownStyleSheet(
      h1: Theme.of(context).textTheme.headline1,
      h2: Theme.of(context).textTheme.headline2,
      h3: Theme.of(context).textTheme.headline3,
      p: TextStyle(fontSize: 16),
      tableBorder: TableBorder.all(
        color: Theme.of(context).primaryColor,
        width: 2,
      ),
      tableCellsPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
    );
