part of 'ui.dart';

Future<UserCreate> fetchUserCreate(String name, String job) async {
  final response = await http.post(
    Uri.parse('https://reqres.in/api/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'job': job,
    }),
  );

  if (response.statusCode == 201) {
    return UserCreate.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class UserCreate {
  final String id;
  final String name;
  final String job;
  final String createdAt;

  UserCreate({
    required this.id,
    required this.name,
    required this.job,
    required this.createdAt,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) {
    return UserCreate(
      id: json['id'],
      name: json['name'],
      job: json['job'],
      createdAt: json['createdAt'],
    );
  }
}

class CreateView extends StatefulWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  _CreateViewState createState() {
    return _CreateViewState();
  }
}

class _CreateViewState extends State<CreateView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  Future<UserCreate>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Data Example'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter Name'),
        ),
        TextField(
          controller: _jobController,
          decoration: const InputDecoration(hintText: 'Enter Job'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum =
                  fetchUserCreate(_nameController.text, _jobController.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<UserCreate> buildFutureBuilder() {
    return FutureBuilder<UserCreate>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(snapshot.data!.id),
              Text(snapshot.data!.job),
              Text(snapshot.data!.name),
              Text(snapshot.data!.createdAt),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
