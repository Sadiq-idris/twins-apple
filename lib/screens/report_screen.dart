import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final DbCloud _cloud = DbCloud();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: StreamBuilder(
          stream: _cloud.getReports(),
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              final data = snapshots.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final report = data[index].data();
                  return GestureDetector(
                    onLongPress: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              child: InkWell(
                                  onTap: () {
                                    _cloud.deleteReport(data[index].id);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Deleted successfully"),
                                    ));
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                  )),
                            );
                          });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report["aboutReport"],
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(report["report"])
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
