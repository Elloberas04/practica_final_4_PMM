import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

/*
 * La classe ScanButton es l'encarregada de mostrar el botó per escanejar un codi QR. Basicament
 * retornam un FloatingActionButton amb la funcio onPressed que es crida quan es polsa el botó. Aquesta funcio fa servir el plugin FlutterBarcodeScanner
 * per escanejar el codi QR. Un cop escanejat, es comprova que el resultat no sigui -1 (que es el que retorna el plugin si es cancela l'escaneig) i que
 * el resultat contingui http o geo. Si es compleixen aquestes condicions, es crea un nou ScanModel amb el valor del codi QR i es crida a la funcio
 * nouScan del ScanListProvider per afegir el nou scan a la llista de scans i finalment es crida a la funcio launchURL per obrir la pagina web o el mapa segons el
 * tipus.
 */
class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.filter_center_focus),
      onPressed: () async {
        // Cream l'Scan.
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3D8BEF', 'Cancel·lar', false, ScanMode.QR);

        if (barcodeScanRes != '-1' &&
            (barcodeScanRes.contains('http') ||
                barcodeScanRes.contains('geo'))) {
          final scanListProvider =
              Provider.of<ScanListProvider>(context, listen: false);
          ScanModel nouScan = ScanModel(valor: barcodeScanRes);

          scanListProvider.nouScan(barcodeScanRes);
          // scanListProvider.countScansGeo();
          // scanListProvider.countScansHttp();

          if (scanListProvider.tipusSeleccionat == 'http') {
            scanListProvider.carregaScansPerTipus('http');
          } else {
            scanListProvider.carregaScansPerTipus('geo');
          }

          launchURL(context, nouScan);
        }
      },
    );
  }
}
