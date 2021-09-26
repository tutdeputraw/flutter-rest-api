part of 'ui.dart';

Future deleteRestaurant(String id) async {
  await http.delete(
    Uri.parse(
        'http://192.168.0.7/project/BangOrder-Backend/public/api/menu-category?id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

class DeleteView extends StatefulWidget {
  const DeleteView({Key? key}) : super(key: key);

  @override
  _DeleteViewState createState() {
    return _DeleteViewState();
  }
}

class _DeleteViewState extends State<DeleteView> {
  late Future<Restaurant> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Data Example'),
      ),
      body: Center(
        child: FutureBuilder<Restaurant>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data?.name ?? 'Deleted'),
                    ElevatedButton(
                      child: const Text('Delete Data'),
                      onPressed: () {
                        setState(() {
                          deleteRestaurant(snapshot.data!.id.toString());
                        });
                      },
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
