import 'package:hivebase/hivebase/hivebase_connection.dart';
import 'package:hivebase/hivebase/hivebase_exception.dart';

void main() async {
  final conn = await HiveBaseConnection().openConnection();

  try {
    await conn.initInDart();
    await conn.deleteAll('teste1');
    await conn.addBox('teste1');
    await conn.create(
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
    List<Map<String, dynamic>> collections = await conn.readAll('teste1');
    for (var item in collections) {
      print(item);
    }
    //ReadAll Boxes
    print('+++>Listando todos os boxes');
    List<String> boxes = await conn.listAllBoxes();
    for (var item in boxes) {
      print(item);
    }
    print('--->Listando todos os boxes');
    await conn.deleteAll('todo');
    await conn.deleteAll('teste2');
  } on HiveBaseException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}
