import 'package:flutter/material.dart';
import 'package:photo_gallery_app/api/events_api.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final Future<List<Map<String,dynamic>>> urls=EventsApi().yourEvents();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<List<Map<String,dynamic>>>(
          future: urls, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Map<String,dynamic>>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Map<String,dynamic> data = snapshot.data![index];
                  return Column(
                    children: <Widget>[
                      Text(data['name'].toString().toUpperCase(),style: TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['date']),
                          Text(data['status'])
                        ],
                      ),
                      Image.network(data['url']),
                      Text(data['description'],style: TextStyle(color: Colors.grey.shade500,fontSize: 17)),
                      SizedBox(height: 20),

                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Cargando eventos...'),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}
