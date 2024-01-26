import 'package:flutter/material.dart';
import 'package:qr_scan/widgets/widgets.dart';

/*
 * Aquesta classe és el que es mostra quan es selecciona la pestanya de Mapes, la seva unica funcio de la qual es
 * cridar al widget ScanTiles amb el tipus de scan que volem mostrar. ScanTiles es un widget que mostra els scans en forma de llista.
 */
class MapasScreen extends StatelessWidget {
  const MapasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScanTiles(tipus: 'geo');
  }
}
