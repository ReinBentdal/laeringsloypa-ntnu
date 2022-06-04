
import 'package:hive/hive.dart';

import 'package:loypa/data/model/LoypeState.dart';

class LoypeLocalStorage {

  /* stores all ongoing routes with: key: id, value: route data */
  static Box<Map<dynamic, dynamic>> get _getRoutesBox => Hive.box<Map<dynamic, dynamic>>('loyper');

  /* wether local route data exist or not */
  static bool containesRoute({required  String loypeId}) => _getRoutesBox.containsKey(loypeId);

  static Future<void> newRoute(LoypeStateModel loype) async {
    final loyperBox = _getRoutesBox;
    
    assert(loyperBox.containsKey(loype.loypeId) == false, "Cant create route which already exist");
  
    print("new route ${loype.loypeId}");

    await loyperBox.put(loype.loypeId, loype.toJson());
  }

  static Future<void> tryDeleteRoute({required String loypeId}) async {
    await _getRoutesBox.delete(loypeId);
  }

  static Future<void> updateRoute({required LoypeStateModel loype}) async {
    
    final loyperBox = _getRoutesBox;

    assert(loyperBox.containsKey(loype.loypeId), "Cant update route which does not exist");
    print("update route ${loype.loypeId}");
    /* update route  */
    await loyperBox.put(loype.loypeId, loype.toJson());
  }

  static LoypeStateModel? getRoute({required String loypeId}) {
    print("get route $loypeId");
    final Map<dynamic, dynamic>? routeMap = _getRoutesBox.get(loypeId);
    if (routeMap == null) {
      return null;
    }
    
    return LoypeStateModel.fromJson(routeMap);
  }

}