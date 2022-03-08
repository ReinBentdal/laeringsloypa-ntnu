import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loypa/ui/Dashbord/Meta.dart';
import 'package:loypa/ui/Dashbord/SpillSammen.dart';
import 'package:loypa/ui/Dashbord/SpillIndividuelt.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void showAppInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AppMeta(),
      backgroundColor: Colors.transparent,
    );
  }

  void handleNavbarTap(int index) {
    setState(() => _valgtSide = index);
    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).errorColor,
        currentIndex: _valgtSide,
        onTap: handleNavbarTap,
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
        onPageChanged: handleNavbarTap,
        children: [
          SpillIndividuelt(),
          SpillSammen(),
        ],
      ),
      floatingActionButton: Icon(Icons.more_vert_outlined).gestures(onTap: showAppInfo).padding(top: 10),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
