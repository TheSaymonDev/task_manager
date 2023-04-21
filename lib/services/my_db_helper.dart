import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/task_models.dart';

class MyDatabase {
  static final String _tableName = 'tasks';
  static final MyDatabase instance = MyDatabase._init();
  static Database? _database;
  MyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    print('creating a new one');
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        note TEXT,
        date DATETIME,
        startTime TEXT,
        endTime TEXT,
        color INTEGER,
        remind INTEGER,
        repeat TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  Future<int> create(TaskModels task) async {
    final db = await instance.database;
    print('insert function called');
    return await db.insert('tasks', task.toJson());
  }

  // Future<List<TaskModels>?> read(String date) async {
  //   final db = await instance.database;
  //   final maps = await db.query('tasks',
  //       columns: TaskModels().toJson().keys.toList(),
  //       where: 'date = ?',
  //       whereArgs: [date]);
  //   if (maps.isNotEmpty) {
  //     // return TaskModels.fromJson(maps.first);
  //     return maps.map((e) => TaskModels.fromJson(e)).toList();
  //   } else {
  //     return null;
  //   }
  // }

  Future<List<TaskModels>> getTasksByDate(String date) async {
    Database db = await database;
    print('get function called');
    List<Map<String, dynamic>> maps = await db.query(_tableName,
        where: 'date = ?', whereArgs: [date], orderBy: 'startTime ASC');
    return List.generate(maps.length, (i) {
      return TaskModels.fromJson(maps[i]);
    });
  }

  Future<List<TaskModels>> readAll() async {
    final db = await instance.database;
    final orderBy = 'date ASC, startTime ASC';
    final result = await db.query('tasks', orderBy: orderBy);
    return result.map((json) => TaskModels.fromJson(json)).toList();
  }

  Future<int> update(TaskModels task) async {
    final db = await instance.database;
    return db
        .update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
