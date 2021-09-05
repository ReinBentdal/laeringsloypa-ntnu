import 'package:loypa/data/model/Oppgave.dart';

abstract class BaseInputType {
  final OppgaveType _oppgaveType;

  const BaseInputType(this._oppgaveType);

  T map<T>({
    required T Function() tekstInput,
    required T Function(HeltallInputType) heltallInput,
    required T Function(DesimalInputType) desimalInput,
    required T Function(PinkodeInputType) pinkodeInput,
    required T Function(GjomtTekstInputType) gjomtTekst,
    required T Function(MarkdownTekstInputType) markdownTekstInput,
  }) {
    switch (this._oppgaveType) {
      case OppgaveType.tekst:
        return tekstInput();
      case OppgaveType.heltall:
        return heltallInput(this as HeltallInputType);
      case OppgaveType.desimal:
        return desimalInput(this as DesimalInputType);
      case OppgaveType.pinkode:
        return pinkodeInput(this as PinkodeInputType);
      case OppgaveType.gjomtTekst:
        return gjomtTekst(this as GjomtTekstInputType);
      case OppgaveType.markdownTekst:
        return markdownTekstInput(this as MarkdownTekstInputType);
    }
  }
}

class TekstInputType extends BaseInputType {
  TekstInputType() : super(OppgaveType.tekst);
}

class MarkdownTekstInputType extends BaseInputType {
  final String innhold;
  MarkdownTekstInputType({
    required this.innhold,
  }) : super(OppgaveType.markdownTekst);
}

class HeltallInputType extends BaseInputType {
  final String? enhet;

  const HeltallInputType({
    this.enhet,
  }) : super(OppgaveType.heltall);
}

class DesimalInputType extends BaseInputType {
  final String? enhet;

  const DesimalInputType({
    this.enhet,
  }) : super(OppgaveType.desimal);
}

class PinkodeInputType extends BaseInputType {
  final int antall;
  final int antallPerFelt;
  final List<String>? hintTekst;

  const PinkodeInputType({
    required this.antall,
    this.antallPerFelt = 1,
    this.hintTekst,
  }) : super(OppgaveType.pinkode);
}

class GjomtTekstInputType extends BaseInputType {
  GjomtTekstInputType({
    required this.tekst,
    this.hintTekst,
  }) : super(OppgaveType.gjomtTekst);

  final List<String> tekst;
  final List<String>? hintTekst;
}
