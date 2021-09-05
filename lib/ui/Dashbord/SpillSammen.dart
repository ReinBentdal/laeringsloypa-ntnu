import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/data/provider/gruppeProvider.dart';
import 'package:loypa/ui/OpprettSpill/VelgLoype.dart';
import 'package:loypa/ui/Dashbord/VerifisererPin.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SRow.dart';
import 'package:styled_widget/styled_widget.dart';

final ugyldigPin = StateProvider<bool>((ref) => false);

class SpillSammen extends StatelessWidget {
  const SpillSammen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Styled.builder(
          builder: (context, child) {
            return child.padding(horizontal: 20).safeArea();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spill sammen',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Theme.of(context).errorColor),
              ).padding(top: 20),
              const SizedBox(height: 40),
              SColumn(
                separator: const SizedBox(height: 20),
                children: [
                  SRow(
                    separator: const SizedBox(width: 10),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: TextEditingController(
                          text: context.read(gruppepinVerdiProvider).state,
                        ),
                        decoration: inputDecoration(context, 'PIN for spillet'),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onChanged: (verdi) {
                          context.read(gruppepinVerdiProvider).state = verdi;
                        },
                      ).constrained(maxWidth: 200).center(),
                      OutlinedButton(
                        onPressed: () {
                          final pin =
                              context.read(gruppepinVerdiProvider).state;
                          if (pin != '') {
                            Navigator.pushNamed(context, VerifiserPin.rute);
                          }
                        },
                        child: Icon(
                          Icons.arrow_right,
                          size: 32,
                          color: Colors.white,
                        ),
                      )
                          .decorated(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(10))
                          .constrained(height: 50),
                    ],
                  ),
                  Text(
                    'eller',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  $Button(
                    onPressed: () =>
                        Navigator.pushNamed(context, VelgLoype.rute),
                    text: 'Opprett spill',
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}