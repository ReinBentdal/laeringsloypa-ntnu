import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/control/provider/ledertavleProvider.dart';
import 'package:loypa/control/provider/loyperProvider.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/utils/tid_formattering.dart';
import 'package:styled_widget/styled_widget.dart';

class Ledertavle extends StatefulWidget {
  const Ledertavle({
    Key? key,
    required this.loypeId,
    this.gruppeId,
    this.rangeringCallback,
  }) : super(key: key);

  final String loypeId;
  final String? gruppeId;
  final void Function(int)? rangeringCallback;

  @override
  _LedertavleState createState() => _LedertavleState();
}

class _LedertavleState extends State<Ledertavle> {
  final _scrollController = ScrollController();
  String? loypenavn;

  @override
  void initState() {
    _scrollController.addListener(this.scollListener);
    context.read(ledertavleProvider(widget.loypeId)).hentFler();
    () async {
      final loype =
          await context.read(loypeinfoProvider(widget.loypeId).future);
      setState(() {
        this.loypenavn = loype?.navn;
      });
    }();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scollListener() async {
    final provider = context.read(ledertavleProvider(widget.loypeId));
    final flerTilgjengelig = provider.flerTilgjengelig;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_scrollController.position.outOfRange) {
      if (flerTilgjengelig) {
        await provider.hentFler();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SColumn(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      separator: const SizedBox(height: 10),
      children: [
        Text(
          this.loypenavn ?? 'Henter løypenavn..',
          style: Theme.of(context).textTheme.headline4,
        ),
        Consumer(builder: (context, watch, _) {
          final ledertavleController =
              watch(ledertavleProvider(widget.loypeId));
          final resultater = ledertavleController.hentResultater();
          // final gruppeId = watch(gruppeIdProvider).state;
          Future.delayed(Duration(milliseconds: 200), () {
            this.scollListener();
          });
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: resultater.length + 1,
            itemBuilder: (context, i) {
              if (i == resultater.length) {
                if (ledertavleController.flerTilgjengelig)
                  return LasterIndikator(
                    beskrivelse: 'Laster flere resultater',
                    scaleFactor: 0.7,
                  ).padding(vertical: 10);
                return Text(
                  'Ingen flere resultater',
                  textAlign: TextAlign.center,
                ).padding(vertical: 10);
              }
              final denneGruppen = widget.gruppeId == resultater[i].gruppeId;
              if (denneGruppen) {
                if (widget.rangeringCallback != null) {
                  widget.rangeringCallback!(i + 1);
                }
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${i + 1}. ${resultater[i].navn}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: denneGruppen
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                  Text(
                    formaterTid(
                      resultater[i].tid,
                      format: TidFormat.Digital,
                    ),
                  ),
                ],
              )
                  .padding(bottom: 5)
                  .decorated(
                    border: Border(
                      bottom: BorderSide(width: 1),
                    ),
                  )
                  .padding(bottom: 15);
            },
          );
        }),
      ],
    )
        .padding(all: 20)
        .scrollable(controller: _scrollController)
        .decorated(
          border: Border.all(
            width: 3,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(10),
        )
        .clipRRect(all: 10);
  }
}
