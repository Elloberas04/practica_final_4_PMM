import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/home_screen.dart';
import 'package:qr_scan/screens/mapa_screen.dart';

/*
* Com sabem, tota aplicacio de flutter comença amb el main, que es el punt d'entrada
* de l'aplicació. En aquest cas, només es crea un MultiProvider que conte el UIProvider (per navegar entre
* els diferents menus) i el ScanListProvider (per anar actualitzant els estats de la llista de scans). Despres
* es crida a la classe MyApp, que es la que conte el MaterialApp.
*/
void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => ScanListProvider())
      ], child: const MyApp()),
    );

/*
 * Dins el nostre MaterialApp definim les preferencies de la nostra app, com el titol, la ruta inicial, altres rutes i el tema.
 */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'mapa': (_) => const MapaScreen(),
      },
      theme: ThemeData(
        // No es pot emprar colorPrimary des de l'actualització de Flutter
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.deepPurple,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
