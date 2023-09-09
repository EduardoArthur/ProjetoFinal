import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../services/report_service.dart';
import '../util/conversion_util.dart';
import '../util/location_util.dart';
import '../util/map_util.dart';

import '../domain/report.dart';

class ReportDetails {
  LocationUtil locationUtil = LocationUtil();
  ConversionUtil conversionUtil = ConversionUtil();
  MapUtil mapUtil = MapUtil();
  ReportService reportService = ReportService();
  final Function(Report) onReportStatusChanged;
  final GlobalKey<State> key;

  ReportDetails({required this.key, required this.onReportStatusChanged});

  Future openReportDetails(BuildContext context, Report report,
      LocationData userLocation, List<Marker> markers, bool isAdm) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Detalhes do Registro'),
                const SizedBox(height: 10),
                Text('Data reportada: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(report.timestamp!.toDate())}'),
                const SizedBox(height: 10),
                Text('Tipo de animal: ${report.animalKind}'),
                const SizedBox(height: 10),
                Text('Descrição: ${report.message ?? 'N/A'}'),
                const SizedBox(height: 10),
                if(report.imgUrl != null && report.imgUrl!.isNotEmpty)
                  mostrarImagem(report.imgUrl!),
                  const SizedBox(height: 10),
                casoResolvido(context, report, isAdm),
                const SizedBox(height: 10),
                if(report.ongId != null)
                  exibeOngResponsavel(report),
                  const SizedBox(height: 10),
                Text('Distância: ${locationUtil.formatAndCalculateDistance(userLocation, report.location)}'),
                const SizedBox(height: 10),
                exibeMapa(report, markers),
                const SizedBox(height: 10),
                botaoFechar(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget mostrarImagem(String imgUrl){
    return Container(
      child:
      Image.network(
        imgUrl,
        width: 100, // Defina o tamanho da imagem conforme necessário
        height: 100,
        fit: BoxFit.cover, // Define como a imagem será ajustada dentro do espaço
      ),
    );
  }

  Widget casoResolvido(BuildContext context, Report report, bool isAdm){
    return Row(
      children: [
        Text('Caso resolvido: ${report.solved ? 'Sim' : 'Não'}'),
        // Exibir botao caso ong
        if (isAdm)
          TextButton(
            onPressed: () {
              reportService.setSolvedReport(report, true);
              report.solved = true;
              Navigator.of(context).pop();
              onReportStatusChanged(report);
            },
            child: const Text('Marcar como resolvido'),
          ),
      ],
    );
  }

  Widget exibeOngResponsavel(Report report){
    return Flexible(
      child: Text(
        'Resgate realizado pela ONG: ${report.ongId}',
        overflow: TextOverflow.ellipsis, // Handle long text gracefully
      ),
    );
  }

  Widget exibeMapa(Report report, List<Marker> markers){
    return Container(
      height: 200,
      child: mapUtil.displayMap(
          conversionUtil.geoPointToLatLng(report.location),
          markers),
    );
  }

  Widget botaoFechar(BuildContext context){
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Fechar'),
    );
  }

}
