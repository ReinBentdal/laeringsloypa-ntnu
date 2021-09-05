import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/config/markdown/markdown_builders.dart';
import 'package:loypa/config/markdown/markdown_stylesheet.dart';
import 'package:loypa/data/provider/reisebokProvider.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:loypa/ui/widgets/molekyl/FirebaseImage.dart';
import 'package:loypa/ui/widgets/molekyl/MarkdownNoScroll.dart';
import 'package:styled_widget/styled_widget.dart';

final valgtBokmerkeProvider = StateProvider((ref) => 0);

class Reiseboka extends StatelessWidget {
  static const String rute = 'Reiseboka';
  Reiseboka({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageController =
        PageController(initialPage: context.read(valgtBokmerkeProvider).state);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubpageAppBar(title: 'Reiseboka').padding(horizontal: 30),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, watch, _) {
                final valgtBokmerkeIndex = watch(valgtBokmerkeProvider).state;
                final data = context.read(reisebokaProvider);

                return data.when(
                  loading: () => CircularProgressIndicator().center(),
                  error: (_, __) => Text('En feil har oppstått').center(),
                  data: (data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: data.bokmerker
                              .asMap()
                              .map((i, _) {
                                final valgtBokmerkedata = data.bokmerker[i];
                                final erValgtBokmerke = valgtBokmerkeIndex == i;
                                return MapEntry(
                                  i,
                                  FirebaseImage(
                                    prefix: 'reiseboka/',
                                    path: valgtBokmerkedata.ikon,
                                    showLoader: false,
                                    height: 20,
                                    semanticsLabel:
                                        'Faneikon i reiseboka med navn ${valgtBokmerkedata.tittel}',
                                    color: erValgtBokmerke
                                        ? Theme.of(context).backgroundColor
                                        : Theme.of(context).accentColor,
                                  )
                                      .padding(horizontal: 15, vertical: 10)
                                      .decorated(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 3,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                      .ripple(enable: !erValgtBokmerke)
                                      .decorated(
                                        color: erValgtBokmerke
                                            ? Theme.of(context).errorColor
                                            : null,
                                        animate: true,
                                      )
                                      .animate(
                                        Duration(milliseconds: 300),
                                        Curves.easeOut,
                                      )
                                      .clipRRect(all: 10)
                                      .gestures(onTap: () {
                                        pageController.jumpToPage(i);
                                      })
                                      .padding(horizontal: 10)
                                      .expanded(),
                                );
                              })
                              .values
                              .toList(),
                        ).padding(bottom: 10),
                        // tab bar
                        PageView.builder(
                          controller: pageController,
                          onPageChanged: (i) =>
                              context.read(valgtBokmerkeProvider).state = i,
                          itemCount: data.bokmerker.length,
                          itemBuilder: (context, i) {
                            return ListView(
                              children: [
                                Text(
                                  data.bokmerker[i].tittel,
                                  style: Theme.of(context).textTheme.headline1,
                                ).padding(horizontal: 20, top: 10),
                                const SizedBox(height: 20),
                                MarkdownNoScroll(
                                  imageBuilder: imageBuilder,
                                  styleSheet: markdownStylesheet(context),
                                  data: data.bokmerker[i].markdownInnhold,
                                ).padding(horizontal: 20, vertical: 10),
                              ],
                            );
                          },
                        ).expanded(),
                      ],
                    ).expanded();
                  },
                );
              },
            ),
          ],
        ),
      ).padding(top: 20),
    );
  }
}
