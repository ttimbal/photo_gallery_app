import 'package:flutter/material.dart';
import 'package:photo_gallery_app/api/photos_api.dart';
class MyPhotos extends StatefulWidget {
  const MyPhotos({Key? key}) : super(key: key);

  @override
  _MyPhotosState createState() => _MyPhotosState();
}

class _MyPhotosState extends State<MyPhotos> {
  final Future<List<String>> urls=PhotosApi().yourPhotos();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<List<String>>(
          future: urls, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  String url = snapshot.data![index];
                  return Column(
                    children: <Widget>[
                      Image.network(url),
                      SizedBox(height: 10),
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
                  child: Text('Cargando imagenes...'),
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
