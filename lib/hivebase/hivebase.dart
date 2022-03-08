import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:hivebase/hivebase/hivebase_exception.dart';

class HiveBase {
  String _folder = 'hivebaseboxes';
  String _boxWithListAllBoxes = 'hivebaseboxes';
  String get folder => _folder;
  String get boxWithListAllBoxes => _boxWithListAllBoxes;

  Set<String> _boxes = <String>{};
  Box? _box;

  /// The box with the name of all the boxes is 'hivebaseboxes'
  /// Please dont create any box with this name
  ///
  /// First method start is initInDart()
  static HiveBase? _instance;
  HiveBase._();
  factory HiveBase() {
    _instance ??= HiveBase._();
    return _instance!;
  }
  Future<void> initInDart({String? folder}) async {
    _folder = folder ?? _folder;
    _boxWithListAllBoxes = _folder;
    var pathFinal = '';
    try {
      var appPath = Directory.current.path;
      pathFinal = p.join(appPath, _folder);
    } catch (e) {
      throw HiveBaseException(message: 'In initInDart. ICantOpenDirectory');
    }
    try {
      Hive.init(pathFinal);
    } catch (e) {
      throw HiveBaseException(message: 'In initInDart. ICantInit');
    }
    await _getNameOfBoxes();
  }

  // /// Uncomment and import package hive_flutter
  // ///
  // Future<void> initInFlutter({String? folder}) async {
  //   _folder = folder ?? _folder;
  //   _nameBoxWithListAllBoxes = _folder;
  //   try {
  //     await Hive.initFlutter(_folder);
  //   } catch (e) {
  //     throw HiveException(message:'ICantInit');
  //   }
  //   await _getNameOfBoxes();
  // }

  Future<void> _getNameOfBoxes() async {
    var boxOpen = await Hive.openBox(_boxWithListAllBoxes);
    if (!boxOpen.isOpen) {
      throw HiveBaseException(message: 'In _getNameOfBoxes. ICantOpenTheBox');
    }
    dynamic boxes;
    try {
      boxes = boxOpen.get(_boxWithListAllBoxes) ?? {};
    } catch (e) {
      throw HiveBaseException(message: 'In _getNameOfBoxes. ICantGetValue');
    }
    _updateNameOfBoxes(boxes);
  }

  _updateNameOfBoxes(dynamic boxes) {
    if (boxes.isNotEmpty) {
      _boxes.clear();
      _boxes.addAll(boxes);
    }
  }

  Future<void> closeAll() async {
    try {
      await Hive.close();
    } catch (e) {
      throw HiveBaseException(message: 'In closeAll. ICantCloseBoxes');
    }
  }

  Future<void> close(String boxName) async {
    await _getBox(boxName);
    try {
      await _box!.close();
    } catch (e) {
      throw HiveBaseException(message: 'In close. ICantCloseBox');
    }
  }

  Future<void> addBox(String name) async {
    if (_boxes.add(name)) {
      await _updateAllBoxes();
    }
  }

  Future<void> _updateAllBoxes() async {
    try {
      _box = Hive.box(_boxWithListAllBoxes);
    } catch (e) {
      throw HiveBaseException(message: 'In _saveBox. ICantGetTheBox');
    }
    try {
      await _box!.put(_boxWithListAllBoxes, _boxes.toList());
    } catch (e) {
      throw HiveBaseException(message: 'In _saveBox. ICantPutValue');
    }
  }

  Future<void> _openBox(String name) async {
    try {
      await Hive.openBox(name);
    } catch (e) {
      throw HiveBaseException(message: 'In _openBox. ICantOpenTheBox');
    }
  }

  Future<void> _getBox(String name) async {
    if (_boxes.contains(name)) {
      if (!Hive.isBoxOpen(name)) {
        await _openBox(name);
      }
      _box = Hive.box(name);
    } else {
      throw HiveBaseException(message: 'In _getBox. UnregisteredBox');
    }
  }

  /// Return uuid create
  Future<String> create({
    required String boxName,
    required Map<String, dynamic> data,
    String? fieldId,
  }) async {
    await _getBox(boxName);
    String fieldUuid = fieldId ?? 'uuid';

    if (!data.containsKey(fieldUuid)) {
      data.addAll({fieldUuid: Uuid().v4()});
    }
    try {
      await _box!.put(data[fieldUuid], data);
    } catch (e) {
      throw HiveBaseException(message: 'In create. ICantPutValue');
    }
    return data[fieldUuid];
  }

  Future<void> createAll({
    required String boxName,
    required List<Map<String, dynamic>> data,
    String? fieldId,
  }) async {
    await _getBox(boxName);
    String fieldUuid = fieldId ?? 'uuid';
    for (var item in data) {
      if (!item.containsKey(fieldUuid)) {
        item.addAll({fieldUuid: Uuid().v4()});
      }
      try {
        await _box!.put(item[fieldUuid], item);
      } catch (e) {
        throw HiveBaseException(message: 'In createAll. ICantPutValue');
      }
    }
  }

  Future<Map<String, dynamic>> read(
      {required String boxName, required String id}) async {
    await _getBox(boxName);
    var map = <String, dynamic>{};
    dynamic doc;
    if (_box!.isNotEmpty) {
      try {
        doc = _box!.get(id);
      } catch (e) {
        throw HiveBaseException(message: 'In get. ICantGetValue');
      }
      if (doc != null) {
        try {
          map = doc.cast<String, dynamic>();
        } catch (e) {
          throw HiveBaseException(message: 'In get. ICantCastData');
        }
      }
    }
    return map;
  }

  Future<List<Map<String, dynamic>>> readAll(
    String boxName,
  ) async {
    await _getBox(boxName);
    var docs = <Map<String, dynamic>>{};
    dynamic doc;
    if (_box!.isNotEmpty) {
      for (var boxKey in _box!.keys) {
        try {
          doc = _box!.get(boxKey);
        } catch (e) {
          throw HiveBaseException(message: 'In readAll. ICantGetValue');
        }
        if (doc != null) {
          var map = <String, dynamic>{};
          try {
            map = doc.cast<String, dynamic>();
          } catch (e) {
            throw HiveBaseException(message: 'In readAll. ICantGetValue');
          }
          docs.add(map);
        }
      }
    }
    return docs.toList();
  }

  Future<bool> update({
    required String boxName,
    required Map<String, dynamic> data,
    String? fieldId,
  }) async {
    await _getBox(boxName);
    String fieldUuid = fieldId ?? 'uuid';

    if (!data.containsKey(fieldUuid)) {
      return Future.value(false);
    }
    try {
      await _box!.put(data[fieldUuid], data);
    } catch (e) {
      throw HiveBaseException(message: 'In update. ICantGetValue');
    }
    return Future.value(true);
  }

  Future<void> delete({required String boxName, required String id}) async {
    try {
      _box!.delete(id);
    } catch (e) {
      throw HiveBaseException(message: 'In delete. ICantOneDelete');
    }
  }

  Future<void> deleteAll(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
    } catch (e) {
      throw HiveBaseException(message: 'In deleteAll. ICantDeleteAllBox');
    }
  }

  Future<void> removeBox(String boxName) async {
    try {
      if (_boxes.contains(boxName)) {
        _boxes.remove(boxName);
        await _updateAllBoxes();
        await Hive.deleteBoxFromDisk(boxName);
      }
    } catch (e) {
      throw HiveBaseException(message: 'In deleteAll. ICantDeleteAllBox');
    }
  }

  Future<List<String>> listAllBoxes() async {
    Box box;
    try {
      box = await Hive.openBox(_boxWithListAllBoxes);
    } catch (e) {
      throw HiveBaseException(message: 'In listOfBoxes. ICantOpenTheBox');
    }
    var list = <String>[];
    dynamic doc;
    if (box.isNotEmpty) {
      try {
        doc = box.get(_boxWithListAllBoxes);
      } catch (e) {
        throw HiveBaseException(message: 'In listOfBoxes. ICantGetValue');
      }
      if (doc != null) {
        try {
          list = doc.cast<String>();
        } catch (e) {
          throw HiveBaseException(message: 'In listOfBoxes. ICantCastData');
        }
      }
    }
    return list;
  }
}
