import 'package:hivebase/hivebase/hivebase.dart';
import 'package:hivebase/hivebase/hivebase_exception.dart';

void main() async {
  var hiveBase = HiveBase();
  try {
    await hiveBase.initInDart();
    await hiveBase.deleteAll('teste1');
    await hiveBase.addBox('teste1');
    await hiveBase.create(
      boxName: 'teste1',
      data: {'time': DateTime.now()},
    );
    // await hiveBase.createAll(
    //   boxName: 'teste1',
    //   data: [
    //     {
    //       'uuid': '069bf11d-f36f-4adb-8178-d98bf16ec79f',
    //       'time': DateTime.now().toIso8601String()
    //     },
    //     {'time': DateTime.now().toIso8601String()},
    //   ],
    // );

    // await hiveBase.update(
    //   boxName: 'teste1',
    //   data: {
    //     'uuid': '069bf11d-f36f-4adb-8178-d98bf16ec79f',
    //     'time': DateTime.now().toIso8601String()
    //   },
    // );
    // Map<String, dynamic> collection = await hiveBase.read(
    //   boxName: 'teste1',
    //   id: '069bf11d-f36f-4adb-8178-d98bf16ec79f',
    // );
    // print('$collection');
    //ReadAll
    List<Map<String, dynamic>> collections = await hiveBase.readAll('teste1');
    for (var item in collections) {
      print(item);
    }
    //ReadAll Boxes
    List<String> boxes = await hiveBase.listAllBoxes();
    for (var item in boxes) {
      print(item);
    }
  } on HiveBaseException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}
