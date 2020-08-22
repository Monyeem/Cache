import 'package:flutter/material.dart';
import 'package:future_builder_app/api/ApiServiceProvider.dart';
import 'package:future_builder_app/pojo/Data.dart';
import 'package:future_builder_app/pojo/Response.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiServiceProvider _apiServiceProvider = new ApiServiceProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User List"),
        ),
        body: FutureBuilder<Response>(
          future: _apiServiceProvider.getUser('3'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Data> list = snapshot.data.data;
              print(list.length);
              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    Data user = list[index];
                    return ListTile(
                      title: Text('${user.name}'),
                      subtitle: Text(user.id),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.image),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
