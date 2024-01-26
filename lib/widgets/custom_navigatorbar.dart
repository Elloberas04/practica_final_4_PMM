import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';

/*
 * Aquesta classe es basa en construir el widget del bottomNavigationBar. Aquest widget es el que es mostra a la part 
 * inferior de la pantalla per poder navegar entre els diferents menus de la nostra app. Per això, es necessita el
 * UIProvider per saber quin menu esta seleccionat i el ScanListProvider per saber quants scans hi ha de cada tipus.
 * Quan es fa click a un dels menus, es crida a la funcio onTap, que actualitza el menu seleccionat.
 */
class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;
    // final scanListProvider = Provider.of<ScanListProvider>(context);

    return BottomNavigationBar(
      onTap: (int i) => uiProvider.selectMenuOpt = i,
      elevation: 0,
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          // label: 'Mapa (${scanListProvider.numScansGeo})',
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compass_calibration),
          // label: 'Direccions (${scanListProvider.numScansHttp})',
          label: 'Direccions',
        )
      ],
    );
  }
}
