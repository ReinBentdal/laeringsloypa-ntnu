import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/control/provider/loypeProvider.dart';
import 'package:loypa/data/model/Gruppe.dart';
import 'package:loypa/data/storage/loype_local_storage.dart';

import 'provider/gruppeProvider.dart';

final _randomProvider = Provider((ref) => Random(DateTime.now().millisecondsSinceEpoch));

class LoypeControl {
  /// oppretter en ny løype i databasen. Returnerer gruppe id
  static Future<String?> lag(
    BuildContext context,
    String loypeId,
    String gruppenavn,
    bool gruppespill,
  ) async {

    try {
      final docRef = await FirebaseFirestore.instance.collection('grupper').add({
        'gruppenavn': gruppenavn,
        'løype_id': loypeId,
        'status': 'venter',
        'tidsstempel': DateTime.now(),
        'pin': !gruppespill ? '' : (100000 + context.read(_randomProvider).nextInt(899999)).toString(),
        'gyldig': true,
        'hint_brukt': 0,
      });

      final gruppeId = docRef.id;

      return gruppeId;
    } catch (error, trace) {
      print(error);
      print(trace);
      return null;
    }
  }

  static Future<void> start(String gruppeId) async {
    final gruppe = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).get();

    assert(gruppe.exists);
    final gruppeModel = GruppeModel.fromJson(gruppeId, gruppe.data()!);
    assert(gruppeModel.status == GruppeStatus.Venter);

    await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).update({
      'status': 'startet',
    });
  }

  /// prøv å delta i gruppe med gitt id. Returnerer true om suksess
  static Future<bool> deltaMedGruppeId(
    BuildContext context,
    String gruppeId,
    String brukernavn,
  ) async {
    context.read(loypeIdProvider).state = null;
    context.read(gruppeIdProvider).state = null;

    try {
      final gruppe = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).get();

      /* return if no group found */
      if (!gruppe.exists) {
        print("gruppen eksisterer ikke");
        return false;
      }

      final brukerId = FirebaseAuth.instance.currentUser?.uid;

      if (brukerId == null) {
        print("ingen bruker er logget inn");
        return false;
      }

      /* legg til bruker i gruppen */
      await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).collection('deltakere').doc(brukerId).set({
        'brukernavn': brukernavn,
      });

      final gruppeModel = GruppeModel.fromJson(gruppe.id, gruppe.data()!);

      /* fjern tidligere påbegynte lokale løyper */
      final tidligereState = LoypeLocalStorage.getRoute(loypeId: gruppeModel.loypeId);
      if (tidligereState != null) {
        bool forlatt = await LoypeControl.forlat(context, tidligereState.gruppeId);
        if (forlatt == false) {
          print("feilet med å forlate gruppe");
        }
      }

      LoypeLocalStorage.tryDeleteRoute(loypeId: gruppeModel.loypeId);

      /* sett lokal gruppe id og løype id */
      context.read(loypeIdProvider).state = gruppeModel.loypeId;
      context.read(gruppeIdProvider).state = gruppeId;

      return true;
    } catch (error, trace) {
      print(error);
      print(trace);

      return false;
    }
  }

  static Future<bool> gruppePinEksisterer(BuildContext context, String pin) async {
    if (pin == '') {
      return false;
    }

    final grupper = await FirebaseFirestore.instance
        .collection('grupper')
        .where('status', isEqualTo: 'venter')
        .where('pin', isEqualTo: pin)
        .orderBy('tidsstempel', descending: true)
        .limit(1)
        .get();

    /* return if no group found */
    if (grupper.docs.length != 1) {
      return false;
    }
    return true;
  }

  /// prøv å delta i løype med gitt pin kode
  static Future<String?> deltaMedPin(
    BuildContext context,
    String pin,
    String brukernavn,
  ) async {
    context.read(loypeIdProvider).state = null;
    context.read(gruppeIdProvider).state = null;

    try {
      final grupper = await FirebaseFirestore.instance
          .collection('grupper')
          .where('status', isEqualTo: 'venter')
          .where('pin', isEqualTo: pin)
          .orderBy('tidsstempel', descending: true) /* om flere løyper med samme pin, returner den siste */
          .limit(1)
          .get();

      /* return if no group found */
      if (grupper.docs.length != 1) {
        return null;
      }

      final gruppe = GruppeModel.fromJson(
        grupper.docs[0].id,
        grupper.docs[0].data(),
      );

      /* fjern tidligere påbegynte lokale løyper */
      final tidligereState = LoypeLocalStorage.getRoute(loypeId: gruppe.loypeId);
      if (tidligereState != null) {
        bool forlatt = await LoypeControl.forlat(context, tidligereState.gruppeId);
        if (forlatt == false) {
          print("feilet med å forlate gruppe");
        }
      }

      final brukerId = FirebaseAuth.instance.currentUser?.uid;
      assert(brukerId != null);

      /* legg til bruker i gruppen */
      await FirebaseFirestore.instance
          .collection('grupper')
          .doc(gruppe.gruppeId)
          .collection('deltakere')
          .doc(brukerId)
          .set({
        'brukernavn': brukernavn,
      });

      LoypeLocalStorage.tryDeleteRoute(loypeId: gruppe.loypeId);

      /* sett lokal gruppe og løype id */
      context.read(loypeIdProvider).state = gruppe.loypeId;
      context.read(gruppeIdProvider).state = gruppe.gruppeId;

      return gruppe.gruppeId;
    } catch (error, trace) {
      print(error);
      print(trace);
      return null;
    }
  }

/* fjern bruker fra gruppen */
  static Future<bool> forlat(BuildContext context, String gruppeId) async {
    /* sjekk om gruppen eksisterer */
    final gruppe = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).get();

    if (!gruppe.exists) {
      return false;
    }

    final gruppeModel = GruppeModel.fromJson(gruppeId, gruppe.data()!);
    LoypeLocalStorage.tryDeleteRoute(loypeId: gruppeModel.loypeId);

    /* fjern lokal løype og gruppe id */
    context.read(loypeIdProvider).state = null;
    context.read(gruppeIdProvider).state = null;

    /* sjekk om brukeren eksisterer i gruppen og fjern */
    final brukerId = FirebaseAuth.instance.currentUser?.uid;

    if (brukerId == null) {
      return false;
    }

    final bruker = await FirebaseFirestore.instance
        .collection('grupper')
        .doc(gruppeId)
        .collection('deltakere')
        .doc(brukerId)
        .get();

    /* slett bruker fra gruppe */
    if (bruker.exists) {
      await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).collection('deltakere').doc(brukerId).delete();
    }

    /* slett hele gruppen hvis alle har forlatt gruppen */
    final brukere = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).collection('deltakere').get();

    if (brukere.size == 0) {
      await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).delete();
    }

    return true;
  }

  static Future<bool> forlatOgSlett(BuildContext context, String gruppeId) async {
    /* sjekk om gruppen eksisterer */
    final gruppe = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).get();

    if (!gruppe.exists) {
      return false;
    }

    final gruppeModel = GruppeModel.fromJson(gruppeId, gruppe.data()!);

    /* slett alle deltakere */
    final snapshot = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).collection('deltakere').get();

    // fjerne alle deltakere
    snapshot.docs.forEach((doc) {
      doc.reference.delete();
    });

    /* slett gruppen */
    await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).delete();

    LoypeLocalStorage.tryDeleteRoute(loypeId: gruppeModel.loypeId);

    /* fjern lokal løype og gruppe id */
    context.read(loypeIdProvider).state = null;
    context.read(gruppeIdProvider).state = null;

    return true;
  }

/* prøver å fortsette løype fra lagret data. Hvis den feiler
   vil den returnere false */
  static Future<bool> fortsett(BuildContext context, String loypeId) async {
    context.read(loypeIdProvider).state = null;
    context.read(gruppeIdProvider).state = null;
    
    print("CTL: fortsetter løype");
    final localGruppe = LoypeLocalStorage.getRoute(loypeId: loypeId);

    if (localGruppe == null) {
      print("ingen lokal gruppe");
      return false;
    }

    final gruppeId = localGruppe.gruppeId;

    print("lokal gruppe id: $gruppeId");

    final gruppe = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).get();

    /* return if no group found */
    if (!gruppe.exists) {
      print("gruppe $gruppeId eksisterer ikke");
      return false;
    }

    final brukerId = FirebaseAuth.instance.currentUser?.uid;

    if (brukerId == null) {
      return false;
    }

    final bruker = await FirebaseFirestore.instance
        .collection('grupper')
        .doc(gruppeId)
        .collection('deltakere')
        .doc(brukerId)
        .get();

    if (!bruker.exists) {
      print("brukeren er ikke en del av gruppen");
      return false;
    }

    context.read(loypeIdProvider).state = loypeId;
    context.read(gruppeIdProvider).state = gruppeId;

    return true;
  }

  /* avslutter løype lokalt */
  static void avsluttLoype(BuildContext context) {
    assert(context.read(loypeIdProvider).state != null);
    assert(context.read(gruppeIdProvider).state != null);
    context.read(loypeIdProvider).state = null;
    context.read(gruppeIdProvider).state = null;
  }

  static Future<void> fullforLoype(BuildContext context) async {
    final loypeId = context.read(loypeIdProvider).state;
    final gruppeId = context.read(gruppeIdProvider).state;
    assert(gruppeId != null);
    assert(loypeId != null);

    final gruppe = await context.read(gruppeProvider.future);

    if (gruppe.sluttTid == null) {
      /* finn tid brukt */
      final tid = DateTime.now();

      const int TID_PER_HINT = 5000;
      final straffetid = gruppe.hintBrukt * TID_PER_HINT;
      final tidBrukt = Duration(
        milliseconds: tid.millisecondsSinceEpoch - gruppe.startTid!.millisecondsSinceEpoch + straffetid,
      );

      /* sett slutttid */
      await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).update({
        'slutt_tid': tid,
        'status': 'avsluttet',
      });

      if (gruppe.gyldig) {
        /* legg inn i ledertavlen */
        await FirebaseFirestore.instance.collection('ledertavle').add({
          'gruppe_id': gruppeId,
          'løype_id': loypeId,
          'navn': gruppe.gruppenavn,
          'tidsstempel': DateTime.now(),
          'tid': tidBrukt.inSeconds,
        });
      }
    }
  }
}
