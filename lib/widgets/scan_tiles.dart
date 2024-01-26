import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

/*
 * La classe ScanTiles es l'encarregada de mostrar la llista de scans. Per fer-ho, rep per parametre el tipus de scans i a 
 * partir d'aqui es fa servir un ListView.builder que va mostrant els diferents scans que hi ha a la llista actual del ScanListProvider. 
 * A mes, es fa servir un Dismissible per poder esborrar els scans de la llista amb aquell index. Per cada element es crea un ListTile
 * que al clicar-hi es crida a la funcio launchURL per obrir el link o el mapa.
*/
class ScanTiles extends StatelessWidget {
  final String tipus;

  const ScanTiles({super.key, required this.tipus});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    // Per crear la llista.
    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, index) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.delete_forever),
            ),
          ),
        ),
        // Per eliminar un element de la llista i de la base de dades.
        onDismissed: (DismissDirection direccio) {
          final test = Provider.of<ScanListProvider>(context, listen: false);
          test.esborraPerId(scans[index].id!);
          // scanListProvider.countScansGeo();
          // scanListProvider.countScansHttp();
        },
        // Cada element de la llista.
        child: ListTile(
          leading: Icon(
            tipus == 'http' ? Icons.home_outlined : Icons.map_outlined,
          ),
          title: Text(scans[index].valor),
          subtitle: Text(scans[index].id.toString()),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          onTap: () {
            //Funcio per obrir el link o el mapa segons el tipus.
            launchURL(context, scans[index]);
          },
        ),
      ),
    );
  }
}
