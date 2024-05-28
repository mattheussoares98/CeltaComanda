import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/cache/cache.dart';

class FirebaseAdapter implements FirebaseStorage {
  final FirebaseFirestore firestore;

  FirebaseAdapter({required this.firestore});

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    required String fieldToSearch,
    required String valueToSearch,
  }) async {
    return await firestore
        .collection(collection)
        .where(fieldToSearch, isEqualTo: valueToSearch)
        .get();
  }

  @override
  Future<void> addNewPrintRequest() async {
// Obtém a instância do Firestore
    var firestore = FirebaseFirestore.instance;

    // Obtém a data atual
    var agora = DateTime.now();
    var mesAnoAtual = '${agora.month}/${agora.year}';

    // Referência para o documento do mês e ano atual na coleção "minhaColecao"
    var docRef = firestore.collection('printRequests').doc(mesAnoAtual);

    // Incrementa o contador usando FieldValue.increment()
    var incremento = FieldValue.increment(1);

    // Adiciona a data atual à lista de datas, se ainda não estiver presente
    var dataAtual = agora.toIso8601String();
    var adicionarData = FieldValue.arrayUnion([dataAtual]);

    // Atualiza o documento
    await docRef.set({
      'requests': {
        EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName: {
          'contador': incremento,
          'datas': adicionarData
        }
      }
    }, SetOptions(merge: true));
  }
}
