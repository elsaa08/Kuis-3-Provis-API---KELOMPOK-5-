import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

class Umkm {
  String nama;
  String jenis;
  Umkm({required this.nama, required this.jenis});
}

class DataUmkm {
  List<Umkm> ListPop = <Umkm>[];

  DataUmkm(Map<String, dynamic> json) {
    var data = json["data"];
    for (var val in data) {
      var nama = val["nama"];
      var jenis = val["jenis"];
      ListPop.add(Umkm(nama: nama, jenis: jenis));
    }
  }

  factory DataUmkm.fromJson(Map<String, dynamic> json) {
    return DataUmkm(json);
  }
}

class UmkmCubit extends Cubit<List<Umkm>> {
  UmkmCubit() : super([]);
  Future<void> fetchUmkm() async {
    String url = "http://178.128.17.76:8000/daftar_umkm";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jenis = DataUmkm.fromJson(jsonDecode(response.body));
      emit(jenis.ListPop);
    } else {
      throw Exception('Gagal load');
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KUIS 2 FLUTTER',
      home: BlocProvider(
        create: (_) => UmkmCubit(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _tampilan createState() => _tampilan();
}

class _tampilan extends State<HomePage> {
  late final UmkmCubit _umkmCubit;

  @override
  void initState() {
    super.initState();
    _umkmCubit = context.read<UmkmCubit>();
    _umkmCubit.fetchUmkm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kuis Flutter'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              'nim 2108805, Elsa Nabiilah; nim 2105899 Azzahra Alika; Saya Berjanji tidak akan berbuat curang data atau membuat orang lain berbuat curang ',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //actionn
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyApp(),
                        ),
                      );
                    },
                    child: Text('Reload Daftar UMKM',
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: BlocBuilder<UmkmCubit, List<Umkm>>(
                builder: (context, listumkm) {
                  return ListView.builder(
                    //decoration: BoxDecoration(border: Border.all()
                    itemCount: listumkm.length,
                    itemBuilder: (context, count) {
                      return GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                              onTap: () {},
                              leading: Image.network(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                              trailing: const Icon(Icons.more_vert),
                              title: Text(listumkm[count].nama),
                              subtitle: Text(listumkm[count].jenis),
                              tileColor: Colors.white70),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Kuis 2 Flutter',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Kuiz 2 Pemrograman Visual'),
//         ),
//         body: Column(
//           children: [
//             Text(
//               'nim 2108805, Elsa Nabiilah; nim 2105899 Azzahra Alika; Saya Berjanji tidak akan berbuat curang data atau membuat orang lain berbuat curang ',
//               style: TextStyle(fontSize: 15),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 5, // Jumlah item dalam daftar
//                 itemBuilder: (context, index) {
//                   return Container(
//                     //decoration: BoxDecoration(border: Border.all()),
//                     padding: EdgeInsets.all(10),
//                     child: ListTile(
//                       onTap: () {},
//                       leading: Image.network(
//                           'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
//                       trailing: const Icon(Icons.more_vert),
//                       title: Text('Item $index'),
//                       subtitle: Text('Deskripsi item $index'),
//                       //  titleColor
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
