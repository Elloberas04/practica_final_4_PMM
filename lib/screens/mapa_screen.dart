import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_scan/models/scan_model.dart';

// Aquesta classe es la que s'encarrega de mostrar el mapa amb la localització del scan. Dir que serà una StatefulWidget perquè
// necessitarem actualitzar l'estat del mapa en alguns moments.
class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  // Cream un controller per poder accedir al mapa i poder fer zoom, etc.
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Variable per guardar el tipus de mapa que estem mostrant.
  MapType _currentMapType = MapType.satellite;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    // Definim el punt inicial del mapa a partir de les dades del scan pasades per parametre quan navegam fins a aquesta pantalla.
    final CameraPosition _puntInicial =
        CameraPosition(target: scan.getLatLng(), zoom: 17, tilt: 50);

    // Definim un set de markers per poder mostrar el marker de la localització del scan.
    Set<Marker> markers = new Set<Marker>();
    markers.add(
      Marker(
        markerId: const MarkerId('id1'),
        position: scan.getLatLng(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            onPressed: () {
              tornarAlLlocInicial(_puntInicial);
            },
            icon: const Icon(Icons.location_pin),
          )
        ],
      ),
      // Aquesta vegada el body serà un GoogleMap del plugin google_maps_flutter.
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: _currentMapType,
        markers: markers,
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          elevation: 0,
          child: const Icon(Icons.layers),
          onPressed: () {
            changeMapType();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Funcio per tornar al punt inicial del mapa.
  Future<void> tornarAlLlocInicial(CameraPosition puntInicial) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(puntInicial));
  }

  // Funcio per canviar el tipus de mapa (feim us del setState per actualitzar l'estat del mapa).
  void changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
}
