import "dart:convert";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spending_app/screens/welcome.dart";

class Depense {
  String categorie;
  double montant;
  DateTime date;
  Depense(this.categorie, this.montant, this.date);

  Map<String, dynamic> toJson() {
    return {
      "categorie": categorie,
      "montant": montant,
      "date": date.toString(),
    };
  }

  factory Depense.fromJson(Map<String, dynamic> data) {
    return Depense(
      data["categorie"],
      data["montant"],
      DateTime.parse(data["date"]),
    );
  }
}

class CorePage extends StatefulWidget {
  @override
  _CorePageState createState() => _CorePageState();
}

class _CorePageState extends State<CorePage> {
  List<Depense> depenses = [];

  @override
  void initState() {
    super.initState();
    chargerDepenses();
  }

  Future<void> chargerDepenses() async {
    final prefs = await SharedPreferences.getInstance();
    final sauvegarde = prefs.getStringList("depenses") ?? [];
    setState(() {
      depenses =
          sauvegarde.map((e) => Depense.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> enregistrerDepenses() async {
    final prefs = await SharedPreferences.getInstance();
    final donnees = depenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList("depenses", donnees);
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var d in depenses) {
      total += d.montant;
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyWelcomePage()),
                  );
                },
                child: Text("Déconnexion"),
              ),
            ),
            SizedBox(height: 20),
            Text("Résumé des dépenses", style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),
            Text("Total des dépenses : ${total.toString()} €"),
            Text("Nombre de dépenses : ${depenses.length}"),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: depenses.length,
                itemBuilder: (context, index) {
                  final d = depenses[index];
                  return ListTile(
                    title: Text("${d.categorie} - ${d.montant.toString()} €"),
                    subtitle: Text(
                      "Date : ${d.date.toLocal().toString().split(" ")[0]}",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => supprimerDepense(index),
                    ),
                    onTap: () => voirDetails(index),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: ajouterDepense,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ajouterDepense() {
    String categorie = "";
    double? montant;
    DateTime? date;
    final controler = TextEditingController();
    final montantControler = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: Text("Nouvelle dépense"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: montantControler,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Montant"),
                      onChanged: (val) {
                        montant = double.tryParse(val);
                      },
                    ),
                    TextField(
                      controller: controler,
                      decoration: InputDecoration(labelText: "Catégorie"),
                      onChanged: (val) {
                        categorie = val;
                      },
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () async {
                        final choisi = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (choisi != null) {
                          setStateDialog(() {
                            date = choisi;
                          });
                        }
                      },
                      child: Text(
                        date == null
                            ? "Choisir une date"
                            : date!.toLocal().toString().split(" ")[0],
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (categorie.isNotEmpty &&
                          montant != null &&
                          date != null) {
                        setState(() {
                          depenses.add(Depense(categorie, montant!, date!));
                        });
                        enregistrerDepenses();
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Ajouter"),
                  ),
                ],
              );
            },
          ),
    );
  }

  void voirDetails(int index) {
    final d = depenses[index];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Détail"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Catégorie : ${d.categorie}"),
                Text("Montant : ${d.montant.toString()} €"),
                Text("Date : ${d.date.toLocal().toString().split(" ")[0]}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  modifierDepense(index);
                },
                child: Text("Modifier"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Fermer"),
              ),
            ],
          ),
    );
  }

  void modifierDepense(int index) {
    String categr = depenses[index].categorie;
    double? montant = depenses[index].montant;
    DateTime? date = depenses[index].date;

    final controler = TextEditingController(text: categr);
    final montantControler = TextEditingController(text: montant.toString());

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: Text("Modifier dépense"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: montantControler,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Montant"),
                        onChanged: (val) {
                          montant = double.tryParse(val.replaceAll(",", "."));
                        },
                      ),
                      TextField(
                        controller: controler,
                        decoration: InputDecoration(labelText: "Catégorie"),
                        onChanged: (val) {
                          categr = val;
                        },
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          final choisi = await showDatePicker(
                            context: context,
                            initialDate: date ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (choisi != null) {
                            setStateDialog(() {
                              date = choisi;
                            });
                          }
                        },
                        child: Text(
                          date == null
                              ? "Choisir une date"
                              : date!.toLocal().toString().split(" ")[0],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        if (categr.isNotEmpty &&
                            montant != null &&
                            date != null) {
                          setState(() {
                            depenses[index] = Depense(categr, montant!, date!);
                          });
                          enregistrerDepenses();
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Valider"),
                    ),
                  ],
                ),
          ),
    );
  }

  void supprimerDepense(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Supprimer"),
            content: Text("Voulez vous supprimer cette dépense ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Non"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    depenses.removeAt(index);
                  });
                  enregistrerDepenses();
                  Navigator.pop(context);
                },
                child: Text("Oui", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
