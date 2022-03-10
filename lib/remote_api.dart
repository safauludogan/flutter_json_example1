import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json/model/user_model.dart';

class RemoteApi extends StatefulWidget {
  const RemoteApi({Key? key}) : super(key: key);

  @override
  State<RemoteApi> createState() => _RemoteApiState();
}

class _RemoteApiState extends State<RemoteApi> {
  Future<List<UserModel>> _getUserList() async {
    try {
      var response =
          await Dio().get('https://jsonplaceholder.typicode.com/users');
      List<UserModel> _userList = [];
      if (response.statusCode == 200) {
        //HTTP dünyasında bu işlemin başarılı olduğu anlamına geliyor.
        _userList =
            (response.data as List).map((e) => UserModel.fromMap(e)).toList();
      }
      return _userList;
    } on DioError catch (e) {
      debugPrint(e.toString());
      return Future.error(e.message);
    }
  }

  //Bu yapı sayesinde, bu future bir kerelik yeni future'a atanıyor
  //Build tekrar tekrar çalışsa bile internetten veriler getirilmeyecek.
  late final Future<List<UserModel>> _userList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userList = _getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Api with Dio'),
      ),
      body: Center(
        child: FutureBuilder<List<UserModel>>(
            future: _userList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var userList = snapshot.data!;
                return ListView.builder(
                    itemBuilder: (context, index) {
                      var user = userList[index];
                      return ListTile(
                        title: Text(user.email),
                        subtitle: Text(user.address.toString()),
                        leading: Text(user.id.toString()),
                      );
                    },
                    itemCount: userList.length);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
