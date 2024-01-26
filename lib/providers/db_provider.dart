import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
 * La classe DBProvider es la que s'encarrega de gestionar la base de dades. Aquesta classe utilitza el disseny Singleton que ens permetrà
 * tenir una única instancia de la classe i així poder accedir a la base de dades sempre des de la mateixa instancia.
 * Aqui tindrem les funcions per poder fer les operacions amb la base de dades.
*/
class DBProvider {
  static Database? _database;

  static final DBProvider db = DBProvider._();

  // Constructor privat per fer el disseny Singleton.
  DBProvider._();

  // Getter per obtenir la base de dades.
  Future<Database> get database async {
    if (_database == null) _database = await initDB();

    return _database!;
  }

  // Funcio per inicialitzar la base de dades quan es crea la primera instancia de la classe i per crear la taula per guardar les Scans.
  Future<Database> initDB() async {
    // Obtenir es path.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');

    // Creació de la BBDD.
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipus TEXT,
            valor TEXT
          )
        ''');
      },
    );
  }

  // Funcions per inserir un nou scan a la base de dades a prtir de les dades del ScanModel passat per parametre.
  // Mode RAW:
  Future<int> insertRawScan(ScanModel nouScan) async {
    final id = nouScan.id;
    final tipus = nouScan.tipus;
    final valor = nouScan.valor;

    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor)
        VALUES ($id, $tipus, $valor)
    ''');

    return res;
  }

  // Mode NORMAL:
  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;

    final res = await db.insert('Scans', nouScan.toMap());

    return res;
  }

  // Funcio per obtenir tots els scans de la base de dades.
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  // Funcio per obtenir un scan a partir del seu id.
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {
      return ScanModel.fromMap(res.first);
    }

    return null;
  }

  // Funcions per obtenir tots els scans de la base de dades depenent del tipus passat per parametre.
  // Mode RAW:
  Future<List<ScanModel>> getRawScanByTipus(String tipus) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipus = '$tipus'
    ''');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  // Mode NORMAL:
  Future<List<ScanModel>> getScanByTipus(String tipus) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);

    return res.isEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  // Funcio per actualitzar un scan de la base de dades a partir de les dades del ScanModel passat per parametre.
  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    final res = db.update('Scans', nouScan.toMap(),
        where: 'id = ?', whereArgs: [nouScan.id]);

    return res;
  }

  // Funcions per eliminar tots els scans de la base de dades.
  // Mode RAW:
  Future<int> deleteRawAllScans() async {
    final db = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');

    return res;
  }

  // Mode NORMAL:
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = db.delete('Scans');

    return res;
  }

  // Funcio per eliminar un scan de la base de dades a partir de l'id passat per parametre.
  Future<int> deleteScanById(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  // Funcio per obtenir el nombre de scans de la base de dades depenent del tipus indicat.
  Future<int> getRawCountScans(String tipus) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT COUNT(*) as count FROM Scans WHERE tipus = '$tipus'
    ''');

    return res.first['count'] as int;
  }
}
