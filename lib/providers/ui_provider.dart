import 'package:flutter/material.dart';

/*
 * Aquesta classe es la que s'encarrega de controlar l'estat del nostre menu inferior per poder navegar entre les diferents pestanyes.
 * Aquesta classe exten de ChangeNotifier, que permet notificar a tots els widgets que estan escoltant aquesta classe i actualitzar el seu estat.
 * Tindrem una variable privada que sra l'index del menu seleccionat i un getter i setter per poder accedir o canviar aquesta variable.
 */
class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 1;

  // Getter
  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  // Setter
  set selectMenuOpt(int index) {
    _selectedMenuOpt = index;
    notifyListeners();
  }
}
