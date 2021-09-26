part of 'ui.dart';

Future<Restaurant> fetchRestaurant() async {
  final response = await http.get(
    Uri.parse(
        'http://192.168.0.7/project/BangOrder-Backend/public/api/menu-category?restaurant_id=1'),
  );

  if (response.statusCode == 200) {
    return Restaurant.fromJson(jsonDecode(response.body)['data'][0]);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<Restaurant> updateRestaurant(String name) async {
  final response = await http.put(
    Uri.parse(
        'http://192.168.0.7/project/BangOrder-Backend/public/api/menu-category'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, dynamic>{"id": 1, "restaurant_id": 1, "name": name}),
  );

  if (response.statusCode == 200) {
    return Restaurant.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update album.');
  }
}

class Restaurant {
  final int id = 6;
  final String name;

  Restaurant({required this.name});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
    );
  }
}

class UpdateView extends StatefulWidget {
  const UpdateView({Key? key}) : super(key: key);

  @override
  _UpdateViewState createState() {
    return _UpdateViewState();
  }
}

class _UpdateViewState extends State<UpdateView> {
  final TextEditingController _controller = TextEditingController();
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
        title: const Text('Update Data Example'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Restaurant>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data!.name),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Name',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureAlbum = updateRestaurant(_controller.text);
                        });
                      },
                      child: const Text('Update Data'),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
