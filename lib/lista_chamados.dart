import 'package:app_glpi/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TicketListScreen extends StatefulWidget {
  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  List<dynamic> _tickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ticketData = await userProvider.getTicketData();
    if (ticketData != null) {
      setState(() {
        _tickets = ticketData['data'];
        _tickets.sort((a, b) {
          final aUis = _getUis(a);
          final bUis = _getUis(b);
          return bUis.compareTo(aUis);
        });
      });
    }
  }

  int _getUis(Map<String, dynamic> ticket) {
    final date = DateTime.parse(ticket['Ticket.date']);
    final days = DateTime.now().difference(date).inDays;
    return days;
  }

  Future<void> _refreshTickets() async {
    await _loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lista de Chamados',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(0, 165, 243, 1),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 165, 243, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Diogo Dias Fontoura',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '15857',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Lista de Chamados'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sair'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: _refreshTickets,
          child: _tickets.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                  itemCount: _tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _tickets[index];
                    final title = ticket['Ticket.name'];
                    final titleStyle = title.contains('#')
                        ? TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )
                        : const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          );
                    return Slidable(
                      key: ValueKey(index),
                      startActionPane: const ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: print,
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Deletar',
                          ),
                          SlidableAction(
                            onPressed: print,
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Editar',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              showEditTimeDialog(context, ticket['Ticket.id'],
                                  ticket['Ticket.name']);
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.timer,
                            label: 'Editar tempo',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          style: titleStyle,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket['Ticket.ITILCategory.completename'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(ticket['Ticket.date']),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.red[900],
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          'UIs: ${DateTime.now().difference(DateTime.parse(ticket['Ticket.date'])).inDays}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100, // Defina o tamanho desejado aqui
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: _getStatusColor(
                                        ticket['Ticket.status']),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      _getStatusText(ticket['Ticket.status']),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<int?> showEditTimeDialog(
      BuildContext context, int id, String name) async {
    final timeController = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tempo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Coloque as horas',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final time = int.tryParse(timeController.text);
                  if (time != null) {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    if (name.contains('#')) {
                      final index = name.indexOf('#');
                      name = '${name.substring(0, index + 1)}$time';
                    } else {
                      name = '$name #$time';
                    }
                    await userProvider.updateTicket(id, name);
                    await _loadTickets();
                    Navigator.of(context).pop(time);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 5:
        return Colors.green;
      case 3:
      case 2:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 5:
        return 'Solucionado';
      case 3:
      case 2:
        return 'Desenvolvendo';
      default:
        return 'Indefinido';
    }
  }
}
