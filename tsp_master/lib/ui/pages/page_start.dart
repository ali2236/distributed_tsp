import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:destributed_tsp/ui/controllers/controller_tsp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
    final nodes = TextEditingController(text: '200');
    return Scaffold(
      appBar: AppBar(
        title: const Text('TSP Master Config'),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: const [Spacer()]),
              const SizedBox(height: 64),
              AnimatedBuilder(
                  animation: slavesService,
                  builder: (context, _) {
                    return SizedBox(
                      width: 400,
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
                                  decoration: InputDecoration(
                                      label: const Text('Socket Port'),
                                      helperText: 'Number of Connected Slaves:'
                                          ' ${slavesService.salvesCount}'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (!slavesService.started)
                                ElevatedButton(
                                  child: const Text('Start Socket'),
                                  onPressed: () => slavesService.start(
                                      int.tryParse(port.text) ??
                                          slavesService.port),
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
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Splitter'),
                            subtitle: const Text('Node Splitting Algorithm'),
                            trailing: DropdownButton<Splitter>(
                              value: Get.find<Splitter>(),
                              onChanged: (t) {
                                if (t != null) {
                                  Get.put<Splitter>(t);
                                }
                              },
                              items: [
                                for (var e in splitters.entries)
                                DropdownMenuItem(
                                  value: splitterFactories[e.value]!(),
                                  child: Text(e.key),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Solver'),
                            subtitle: const Text('Slave TSP Algorithm'),
                            trailing: DropdownButton(
                              value: 'order',
                              onChanged: (t) {
                                if (t != null) {}
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: 'order',
                                  child: Text('By Order'),
                                ),
                                DropdownMenuItem(
                                  child: Text('Greedy'),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Connector'),
                            subtitle: const Text('TSP Connector Algorithm'),
                            trailing: DropdownButton<Connector>(
                              value: Get.find<Connector>(),
                              onChanged: (t) {
                                if (t != null) {
                                  Get.put<Connector>(t);
                                }
                              },
                              items: [
                                for (var e in connectors.entries)
                                  DropdownMenuItem(
                                    value: connectorFactories[e.value]!(),
                                    child: Text(e.key),
                                  ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: nodes,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                                label: Text('Number of Nodes')),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: !slavesService.started ||
                                    slavesService.salvesCount == 0
                                ? null
                                : () {
                                    final nodeCount =
                                        int.tryParse(nodes.text) ?? 20;
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
                            child: const Text('Start'),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
