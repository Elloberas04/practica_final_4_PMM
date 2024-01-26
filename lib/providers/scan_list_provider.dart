import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

/* 
 * La classe ScanListProvider es la que s'encarrega de gestionar la llista de scans actuals i el nombre de scans per tipus.
 * Aquesta classe hereta de ChangeNotifier, que es la que ens permetrà notificar a tots els widgets que estiguin
 * utilitzant aquest provider per produir canvis d'estat dins la nostra aplicació. Aquí tindrem una serie de funcions per anar actualitzant les variables.
 * Aquesta classe es com una capa d'abstracció per poder accedir a la base de dades i poder fer les operacions necessaries. 
*/
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];

  int numScansGeo = 0;
  int numScansHttp = 0;

  String tipusSeleccionat = 'http';

  // Funcio per afegir un nou scan a la base de dades i si es del mateix tipus a la llista actual.
  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if (nouScan.tipus == tipusSeleccionat) {
      scans.add(nouScan);
      notifyListeners();
    }

    return nouScan;
  }

  // Funcio per carregar tots els scans de la base de dades a la llista actual.
  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

  // Funcio per carregar els scans del tipus indicat de la base de dades a la llista actual.
  carregaScansPerTipus(String tipus) async {
    final scans = await DBProvider.db.getRawScanByTipus(tipus);
    this.scans = [...scans];
    tipusSeleccionat = tipus;
    notifyListeners();
  }

  // Funcio per esborrar tots els scans de la base de dades i de la llista actual.
  esborraTots() async {
    await DBProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }

  // Funcio per esborrar un scan de la base de dades per el seu ID i de la llista actual.
  esborraPerId(int id) async {
    // final scan = await DBProvider.db.getScanById(id);
    await DBProvider.db.deleteScanById(id);

    // scans.remove(scan);

    // notifyListeners();
  }

  // // Funcio per contar el nombre de scans de tipus 'geo'.
  // countScansGeo() async {
  //   numScansGeo = await DBProvider.db.getRawCountScans("geo");
  //   notifyListeners();
  // }

  // // Funcio per contar el nombre de scans de tipus 'http'.
  // countScansHttp() async {
  //   numScansHttp = await DBProvider.db.getRawCountScans("http");
  //   notifyListeners();
  // }
}
