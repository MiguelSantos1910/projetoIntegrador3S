import 'package:flutter/material.dart';
import '../services/api_bomba.dart';

class WarningCard extends StatelessWidget {
  final BombaService apiBomba;

  const WarningCard({
    super.key,
    required this.apiBomba,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alerta de Irrigação'),
      content: const Text('Deseja ligar a bomba de irrigação?'),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              // Chama a API para ligar a bomba
              await apiBomba.ligaBombas();

              // Fecha o diálogo de confirmação
              Navigator.of(context).pop(true);

              // Exibe um novo diálogo informando sucesso
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Bomba Ligada'),
                    content: const Text(
                      'A bomba de irrigação foi ligada com sucesso.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              // Fecha o diálogo atual
              Navigator.of(context).pop(false);

              // Exibe mensagem de erro
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Erro'),
                    content: Text(
                      'Não foi possível ligar a bomba.\n\n$e',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text('Sim'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Não'),
        ),
      ],
    );
  }
}