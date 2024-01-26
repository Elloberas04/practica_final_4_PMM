import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

/*
 * Dins aquest arxiu es troba al funcio 'launchURL', que es la que s'encarrega de obrir el scan en funcio del seu tipus.
 * Si es un scan de tipus http, es crida a la funcio 'launchUrl' per obrir la url a un navegador, i si es un scan de 
 * tipus geo, es crida a la funcio 'Navigator.pushNamed' per navegar a la pantalla del mapa i mostrar la ubicacio.
 */
void launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;

  if (scan.tipus == 'http') {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
