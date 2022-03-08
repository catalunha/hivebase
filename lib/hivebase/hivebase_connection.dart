import 'package:hivebase/hivebase/hivebase.dart';
import 'package:synchronized/synchronized.dart';

class HiveBaseConnection {
  static HiveBaseConnection? _instance;
  HiveBaseConnection._();
  factory HiveBaseConnection() {
    _instance ??= HiveBaseConnection._();
    return _instance!;
  }

  HiveBase? _hiveDatabase;
  final _lock = Lock();

  Future<HiveBase> openConnection() async {
    if (_hiveDatabase == null) {
      await _lock.synchronized(() async {
        if (_hiveDatabase == null) {
          print('+++> HiveBase openConnection ');
          _hiveDatabase = HiveBase();
          await _hiveDatabase!.initInDart();
          // await _hiveDatabase!.addBox('todo');
          // var listBoxes = await _hiveDatabase!.listAllBoxes();
        }
      });
    }
    print('+++> HiveBase connected ... ');
    return _hiveDatabase!;
  }

  // void onConfigureBoxes() async {}

  void closeConnection() {
    _hiveDatabase?.closeAll();
    _hiveDatabase = null;
  }
}
