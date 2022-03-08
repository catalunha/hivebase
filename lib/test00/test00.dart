import 'package:hivebase/hivebase/hivebase_connection.dart';
import 'package:hivebase/hivebase/hivebase_exception.dart';

void main() async {
  final conn = await HiveBaseConnection().openConnection();

  try {
    await conn.initInDart();

    //ReadAll Boxes
    print('+++>Listando todos os boxes');
    List<String> boxes = await conn.listAllBoxes();
    for (var item in boxes) {
      print(item);
    }
    print('--->Listando todos os boxes');
    print('+++>Removendo box');
    // await conn.removeBox('todo');
    // await conn.removeBox('teste2');
    print('--->Removendo box');
  } on HiveBaseException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}
