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
      data: {'datetime': DateTime.now()},
    );

    //ReadAll
    List<Map<String, dynamic>> collections = await conn.readAll('teste1');
    print('ReadAll');
    for (var item in collections) {
      print(item);
    }
    //findByPeriod
    List<Map<String, dynamic>> collections2 = await conn.findByPeriod(
        boxName: 'teste1',
        fieldName: 'datetime',
        start: DateTime(2022, 03, 08, 0, 0),
        end: DateTime(2022, 03, 08, 14, 0));
    print('findByPeriod');
    for (var item in collections2) {
      print(item);
    }
  } on HiveBaseException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}
