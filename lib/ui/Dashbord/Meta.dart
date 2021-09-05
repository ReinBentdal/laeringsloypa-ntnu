import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AppMeta extends StatefulWidget {
  const AppMeta({Key? key}) : super(key: key);

  @override
  _AppMetaState createState() => _AppMetaState();
}

class _AppMetaState extends State<AppMeta> {
  String? _versjon;
  @override
  void initState() {
    () async {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _versjon = packageInfo.version;
      });
    }();
    super.initState();
  }

  static const personvernURL = 'https://sites.google.com/view/laeringsloypa';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ListTile(
        //   leading: Icon(
        //     Icons.info_outlined,
        //   ),
        //   title: Text('Om appen'),
        //   onTap: () {
        //     varsling(context, tittel: 'Om appen', beskrivelse: 'om appen');
        //   },
        // ).ripple(),
        ListTile(
          leading: Icon(
            Icons.gavel_outlined,
          ),
          title: Text('Personvern'),
          onTap: () async {
            final launchable = await canLaunch(personvernURL);
            if (launchable) {
              await launch(personvernURL);
            }
            Navigator.pop(context);
          },
        ).ripple(),
        Divider(),
        SColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          separator: const SizedBox(height: 5),
          children: [
            Text(
              'App-versjon',
              style: TextStyle(fontSize: 16),
            ),
            Text(_versjon ?? '...', style: TextStyle(color: Colors.black54)),
          ],
        ).padding(left: 15)
      ],
    ).padding(bottom: 10).decorated(color: Colors.white);
  }
}
