import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loypa/data/loypedata/laeringsloypa/loypa.dart';
import 'package:loypa/ui/Dashbord/Meta.dart';
import 'package:loypa/ui/Dashbord/SpillSammen.dart';
import 'package:loypa/ui/Dashbord/SpillIndividuelt.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:styled_widget/styled_widget.dart';

class DashbordSide extends StatefulWidget {
  static const rute = 'Dashbord side';
  const DashbordSide({Key? key}) : super(key: key);

  @override
  _DashbordSideState createState() => _DashbordSideState();
}

class _DashbordSideState extends State<DashbordSide> {
  int _valgtSide = 0;

  final _controller = PageController();

  @override
  void initState() {
    // TODO: Midlertidig
    // () async {
    //   final prefs = await SharedPreferences.getInstance();

    //   await prefs.setBool('sted-showcase', false);
    //   await prefs.setBool('kart-showcase', false);
    // }();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void setSide(int index) {
    setState(() => _valgtSide = index);
    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.linearToEaseOut,
    );
  }

  void oppdaterLoype() {
    FirebaseFirestore.instance
        .collection('løyper')
        .doc('vujiQ389yYZs1Db059Xj')
        .set(laeringsloypa.toJson());
  }

  void test() async {
    final docs = await FirebaseFirestore.instance.collection('grupper').get();
    docs.docs.forEach((element) async {
      print(element);
      final deltakere = await FirebaseFirestore.instance
          .collection('grupper')
          .doc(element.id)
          .collection('deltakere')
          .get();
      deltakere.docs.forEach((e) async {
        await FirebaseFirestore.instance
            .collection('grupper')
            .doc(element.id)
            .collection('deltakere')
            .doc(e.id)
            .delete();
      });
    });
    // FirebaseFirestore.instance.collection('ledertavle').add({
    //     'løype_id': 'vujiQ389yYZs1Db059Xj',
    //     'gruppe_id': 'HaDcvf0LsmNj2CU7ybGJ',
    //     'navn': 'Vegard & Kari',
    //     'tid': (60*60*2) + (60*15),
    //     'tidsstempel': DateTime.now(),
    //   });
    // for (int i = 0; i < 1; i++) {
    //   await FirebaseFirestore.instance.collection('ledertavle').add({
    //     'løype_id': 'vujiQ389yYZs1Db059Xj',
    //     'gruppe_id': 'HaDcvf0LsmNj2CU7ybGJ',
    //     'navn': 'heiheihei',
    //     'tid': 1000,
    //     'tidsstempel': DateTime.now(),
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // test();
      // oppdaterLoype();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).errorColor,
        currentIndex: _valgtSide,
        onTap: setSide,
        items: [
          BottomNavigationBarItem(
            label: 'Spill individuelt',
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: 'Spill sammen',
            icon: Icon(Icons.groups),
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: setSide,
        children: [
          Loyper(),
          SpillSammen(),
        ],
      ),
      floatingActionButton: Icon(
        Icons.more_vert_outlined,
      ).gestures(onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => AppMeta(),
          backgroundColor: Colors.transparent,
        );
      }).padding(top: 10),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
