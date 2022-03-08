import 'package:hivebase/hivebase/hivebase.dart';
import 'package:hivebase/hivebase/hivebase_exception.dart';
import 'package:hivebase/test02/task_model.dart';

void main() async {
  var hiveBase = HiveBase();
  try {
    await hiveBase.initInDart();
    await hiveBase.deleteAll('todo');
    await hiveBase.addBox('todo');
    var date = DateTime.now();
    await hiveBase.create(
      boxName: 'todo',
      data: {
        'date': date,
        'description': 'teste',
        'finished': false,
      },
    );
    List<Map<String, dynamic>> collections = await hiveBase.readAll('todo');
    for (var item in collections) {
      print(item);
    }
    print('=============');
    final resultTasksModel =
        collections.map((e) => TaskModel.fromMap(e)).toList();
    for (var item in resultTasksModel) {
      print(item);
    }
    // Map<String, dynamic> collection = await hiveBase.read(
    //   boxName: 'todo',
    //   id: '069bf11d-f36f-4adb-8178-d98bf16ec79f',
    // );
    // print('$collection');
  } on HiveBaseException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}
