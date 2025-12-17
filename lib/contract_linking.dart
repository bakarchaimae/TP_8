import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  // Configuration réseau pour Windows / Ganache Desktop
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";

  // Clé privée Ganache (avec 0x)
  final String _privateKey =
      "0x670442baa9e046a674ff27310d960788278b98fb752c4cf34e452bf7ee7f26ed";

  late Web3Client _client;
  bool isLoading = true;

  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;

  late ContractFunction _yourName;
  late ContractFunction _setName;

  String deployedName = "";

  ContractLinking() {
    initialSetup();
  }

  // Initialisation
  Future<void> initialSetup() async {
    try {
      _client = Web3Client(
        _rpcUrl,
        Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(_wsUrl).cast<String>();
        },
      );

      await getAbi();
      await getCredentials();
      await getDeployedContract();
    } catch (e) {
      print("Erreur d'initialisation: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAbi() async {
    try {
      String abiStringFile =
          await rootBundle.loadString("src/artifacts/HelloWorld.json");
      var jsonAbi = jsonDecode(abiStringFile);

      _abiCode = jsonEncode(jsonAbi["abi"]);

      var networkId = jsonAbi["networks"].keys.first;
      _contractAddress =
          EthereumAddress.fromHex(jsonAbi["networks"][networkId]["address"]);

      print("Contrat déployé à: $_contractAddress");
    } catch (e) {
      print("Erreur ABI: $e");
      rethrow;
    }
  }

  Future<void> getCredentials() async {
    try {
      _credentials = EthPrivateKey.fromHex(_privateKey); // 0x inclus
    } catch (e) {
      print("Erreur credentials: $e");
      rethrow;
    }
  }

  Future<void> getDeployedContract() async {
    try {
      _contract =
          DeployedContract(ContractAbi.fromJson(_abiCode, "HelloWorld"), _contractAddress);

      _yourName = _contract.function("yourName");
      _setName = _contract.function("setName");

      await getName();
    } catch (e) {
      print("Erreur contrat: $e");
      rethrow;
    }
  }

  // Récupérer le nom
  Future<void> getName() async {
    try {
      var currentName =
          await _client.call(contract: _contract, function: _yourName, params: []);
      deployedName = currentName[0].toString(); // conversion explicite
      print("Nom récupéré depuis blockchain: $deployedName");

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Erreur getName: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  // Définir le nom
  Future<void> setName(String nameToSet) async {
    try {
      isLoading = true;
      notifyListeners();

      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _setName,
          parameters: [nameToSet],
        ),
        chainId: 1337,
        fetchChainIdFromNetworkId: true,
      );

      await getName(); // Mettre à jour l'affichage après confirmation
    } catch (e) {
      print("Erreur setName: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}
