import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/screens/views/add_plant_page.dart';
import 'package:seeds/screens/views/edit_plant_page.dart';

import '../plant.dart';

class FeuillePlantPage extends StatefulWidget {
  const FeuillePlantPage({super.key});

  @override
  State<FeuillePlantPage> createState() => _FeuillePlantPage();
}

class _FeuillePlantPage extends State<FeuillePlantPage> {
  Stream<List<Plant>> getRootPlants() => FirebaseFirestore.instance
      .collection('plants')
      .where("categorie", isEqualTo: "feuille")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Plant.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Plantes Feuille'),
        ),
        body: StreamBuilder<List<Plant>>(
          stream: getRootPlants(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final plants = snapshot.data!;
              return ListView(
                children: plants.map((plant) => buildPlant(plant)).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPlantPage(),
                ));
          },
        ),
      );
  Widget buildPlant(Plant plant) => ListTile(
        onTap: () {
          Navigator.pushNamed(context, EditPlantPage.routeName,
              arguments: Plant(
                  id: plant.id,
                  name: plant.name,
                  categorie: plant.categorie,
                  date: plant.date));
        },
        title: Text(plant.name),
        subtitle: Text(plant.categorie),
      );
}