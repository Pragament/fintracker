import 'package:fintracker/helpers/db.helper.dart';
import '../model/tag.model.dart';

class TagDao {
  Future<int> create(Tag tag) async {
    final db = await getDBInstance();
    var result = await db.insert("tags", tag.toJson());
    return result;
  }

  Future<List<Tag>> searchByName(String query) async {
    final db = await getDBInstance();
    final List<Map<String, dynamic>> rows = await db.query(
      'tags',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return rows.map((row) => Tag.fromJson(row)).toList();
  }


  Future<List<Tag>> findAll() async {
    final db = await getDBInstance();
    final List<Map<String, dynamic>> rows = await db.query('tags');
    print("Fetched Tags: $rows"); // Log fetched tags
    return rows.map((row) => Tag.fromJson(row)).toList();
  }


  Future<Tag?> findById(int id) async {
    final db = await getDBInstance();
    final List<Map<String, dynamic>> rows =
    await db.query('tags', where: 'id = ?', whereArgs: [id]);

    if (rows.isNotEmpty) {
      return Tag.fromJson(rows.first);
    }
    return null;
  }

  Future<int> update(Tag tag) async {
    final db = await getDBInstance();
    return await db.update(
      'tags',
      tag.toJson(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await getDBInstance();
    return await db.delete('tags', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await getDBInstance();
    await db.delete('tags');
  }

  Future<int> upsert(Tag tag) async {
    return create(tag);
  }

}
