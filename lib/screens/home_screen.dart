import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/screens.dart';
import 'package:qr_scan/widgets/widgets.dart';

/*
 * Home Screen es la pantalla principal de l'aplicació. Es la que es mostra quan s'obre l'aplicació i tenim un scaffold
 * amb un appbar, un body, un bottomNavigationBar i un floatingActionButton. Per el body cridam un widget que es canvia depenent de la pestanya que 
 * seleccionem al bottomNavigationBar. A la appbar tambe hi ha un boto per esborrar tots els scans a través del provider ScanListProvider.
 */
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<ScanListProvider>(context, listen: false)
                  .esborraTots();
            },
          )
        ],
      ),
      body: const _HomeScreenBody(),
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/*
 * _HomeScreenBody es el widget que depenent de la pestanya seleccionada al bottomNavigationBar, crida a un widget o un altre.
 * Primer es crida al provider UIProvider per saber quina pestanya esta seleccionada i despres es crida al provider ScanListProvider
 * per carregar els scans depenent del tipus de scan que es volen mostrar i per contar els scans de cada tipus.
*/
class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    // scanListProvider.countScansGeo();
    // scanListProvider.countScansHttp();

    // Switch per canviar el body depenent de la pestanya seleccionada i carrergar els scans.
    switch (currentIndex) {
      case 0:
        scanListProvider.carregaScansPerTipus('geo');
        return const MapasScreen();

      case 1:
        scanListProvider.carregaScansPerTipus('http');
        return const DireccionsScreen();

      default:
        scanListProvider.carregaScansPerTipus('geo');
        return const MapasScreen();
    }
  }
}
