part of 'ui.dart';

Future<UserRead> fetchUserRead() async {
  final response = await http.get(Uri.parse('https://reqres.in/api/users/2'));

  if (response.statusCode == 200) {
    return UserRead.fromJson(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Failed to load album');
  }
}

class UserRead {
  int id;
  String email;
  String name;

  UserRead({required this.id, required this.email, required this.name});

  factory UserRead.fromJson(Map<String, dynamic> json) {
    return UserRead(
      id: json['id'],
      email: json['email'],
      name: json['first_name'],
    );
  }
}

class ReadView extends StatefulWidget {
  const ReadView({Key? key}) : super(key: key);

  @override
  _ReadViewState createState() => _ReadViewState();
}

class _ReadViewState extends State<ReadView> {
  late Future<UserRead> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUserRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: FutureBuilder<UserRead>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(snapshot.data!.id.toString()),
                  Text(snapshot.data!.name),
                  Text(snapshot.data!.email),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
