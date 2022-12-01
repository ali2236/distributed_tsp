import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:destributed_tsp/ui/controllers/controller_tsp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsp_base/core.dart';

import 'page_tsp.dart';

class StartPage extends StatefulWidget {
  final SlavesService slavesService;

  const StartPage({
    Key? key,
    required this.slavesService,
  }) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final TextEditingController port;
  final nodes = TextEditingController(text: '200');
  var splitter = splitterFactories.values.first();
  var solverId = solvers.keys.first;
  var connector = connectorFactories.values.first();

  @override
  void initState() {
    super.initState();
    port = TextEditingController(text: widget.slavesService.port.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                  animation: widget.slavesService,
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
                                          ' ${widget.slavesService.salvesCount}'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (!widget.slavesService.started)
                                ElevatedButton(
                                  child: const Text('Start Socket'),
                                  onPressed: () => widget.slavesService.start(
                                      int.tryParse(port.text) ??
                                          widget.slavesService.port),
                                ),
                              if (widget.slavesService.started)
                                ElevatedButton(
                                  child: const Text('Stop Socket'),
                                  onPressed: () => widget.slavesService.stop(),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.slavesService.started
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
                              value: splitter,
                              onChanged: (t) {
                                if (t != null) {
                                  setState(() {
                                    splitter = t;
                                  });
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
                            trailing: DropdownButton<String>(
                              value: solverId,
                              onChanged: (t) {
                                if (t != null) {
                                  setState(() {
                                    solverId = t;
                                  });
                                }
                              },
                              items: [
                                for (var e in solvers.entries)
                                  DropdownMenuItem(
                                    value: e.key,
                                    child: Text(e.key),
                                  ),
                              ],
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Connector'),
                            subtitle: const Text('TSP Connector Algorithm'),
                            trailing: DropdownButton<Connector>(
                              value: connector,
                              onChanged: (t) {
                                if (t != null) {
                                  setState(() {
                                    connector = t;
                                  });
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
                            onPressed: !widget.slavesService.started ||
                                    widget.slavesService.salvesCount == 0
                                ? null
                                : () {
                                    final nodeCount =
                                        int.tryParse(nodes.text) ?? 20;
                                    final controller = TspController(
                                      dataset: Dataset.generate(nodeCount),
                                      slaveService: widget.slavesService,
                                      splitter: splitter,
                                      solverId: solverId,
                                      connector: connector,
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
