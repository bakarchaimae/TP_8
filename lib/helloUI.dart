import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';

class HelloUI extends StatelessWidget {
  const HelloUI({super.key});

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);
    final TextEditingController yourNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello World DApp"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blueGrey.shade800,
              Colors.blueGrey.shade900,
            ],
          ),
        ),
        child: Center(
          child: contractLink.isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.tealAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Connexion à la blockchain...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Affichage du nom
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade700.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.tealAccent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Hello ",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              contractLink.deployedName,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Champ de saisie
                      TextFormField(
                        controller: yourNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey.shade700.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.tealAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.tealAccent, width: 2),
                          ),
                          labelText: "Votre nom",
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: "Entrez votre nom...",
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.person, color: Colors.tealAccent),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Bouton
                      ElevatedButton(
                        onPressed: () {
                          if (yourNameController.text.isNotEmpty) {
                            contractLink.setName(yourNameController.text);
                            yourNameController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Nom envoyé à la blockchain !"),
                                backgroundColor: Colors.teal.shade700,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Définir le nom',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
