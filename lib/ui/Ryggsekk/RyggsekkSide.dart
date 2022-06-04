import 'package:flutter/material.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:loypa/control/provider/loypeProvider.dart';
import 'package:loypa/control/provider/loypeStateProvider.dart';
import 'package:loypa/ui/Ryggsekk/GjenstandIkon.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// local
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/control/provider/RyggsekkProvider.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';

class Ryggsekk extends StatelessWidget {
  static const String rute = 'Ryggsekk';
  const Ryggsekk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SubpageAppBar(title: 'Ryggsekken'),
            SizedBox(height: 40),
            Consumer(
              builder: (context, watch, _) {
                List<RyggsekkGjenstandModel> ryggsekkElementer =
                    watch(ryggsekkInnholdProvider);
                return GridView.count(
                  clipBehavior: Clip.none,
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  shrinkWrap: true,
                  children: [
                    ...ryggsekkElementer
                        .asMap()
                        .map((i, _) => MapEntry(i, GjenstandIkon(i)))
                        .values
                        .toList(),
                    for (int i = 0; i < 20 - ryggsekkElementer.length; i++)
                      Styled.widget().padding(all: 15).decorated(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 2,
                              color: Color(0xFFEEEEEE),
                            ),
                          ),
                  ],
                ).expanded();
              },
            ),
          ],
        ),
      ).padding(vertical: 20, horizontal: 30),
    );
  }
}
