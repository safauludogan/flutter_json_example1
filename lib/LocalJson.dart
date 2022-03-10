import 'dart:convert';

import 'package:flutter/material.dart';

import 'model/cars_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({Key? key}) : super(key: key);

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  String _title='Local Json İşlemleri';
  late final Future<List<Cars>> _fillList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fillList = readCarsJson();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        setState(() {
          _title='Buton tıklandı';
        });
      },
      ),
      body: FutureBuilder<List<Cars>>(
        future: _fillList,
        initialData: [Cars(carsName: 'aaa', country: 'TR', kYear: 2020, model:  [Model(modelAdi: 'a', fiyat: 31, benzinli: true)])],//Datalar çekilirken gösterilecek veriler
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Cars> carList = snapshot.data!;

            return ListView.builder(
                itemCount: carList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(carList[index].carsName),
                    subtitle: Text(carList[index].country),
                    leading: CircleAvatar(child: Text(carList[index].model[0].fiyat.toString()),),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Cars>> readCarsJson() async {
    try{
      //Veriler çekilene kadar bekle ve asenkron çalış
      String readingString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/cars.json');
      var jsonObject = jsonDecode(readingString);

      /* List carList = jsonObject;
    debugPrint(carList[0]['model'][0]['fiyat'].toString());*/

      List<Cars> allCars =
      (jsonObject as List).map((carMap) => Cars.fromMap(carMap)).toList();
      debugPrint(allCars[1].carsName);

      return allCars;
    }catch(e){
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }
}
