import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:destributed_tsp/ui/controllers/controller_tsp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsp_base/core.dart';

import 'page_tsp.dart';

class StartPage extends StatelessWidget {
  final SlavesService slavesService;

  const StartPage({
    Key? key,
    required this.slavesService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final port = TextEditingController(text: slavesService.port.toString());
    final nodes = TextEditingController(text: '20');
    return Scaffold(
      appBar: AppBar(
        title: const Text('TSP Config'),
      ),
      body: AnimatedBuilder(
          animation: slavesService,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: port,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration:
                              const InputDecoration(label: Text('Socket Port')),
                        ),
                      ),
                      if (!slavesService.started)
                        ElevatedButton(
                          child: const Text('Start Socket'),
                          onPressed: () => slavesService.start(
                              int.tryParse(port.text) ?? slavesService.port),
                        ),
                      if (slavesService.started)
                        ElevatedButton(
                          child: const Text('Stop Socket'),
                          onPressed: () => slavesService.stop(),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: slavesService.started
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Number of Connected Slaves:'
                      ' ${slavesService.salvesCount}'),
                  TextField(
                    controller: nodes,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration:
                        const InputDecoration(label: Text('Number of Nodes')),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    child: const Text('Start'),
                    onPressed: !slavesService.started ||
                            slavesService.salvesCount == 0
                        ? null
                        : () {
                            final systemsCount = slavesService.salvesCount;
                            final nodeCount = int.tryParse(nodes.text) ?? 20;
                            final controller = TspController(
                              dataset: Dataset.generate(nodeCount),
                              slaveService: slavesService,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TspPage(manager: controller);
                                },
                              ),
                            );
                          },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
