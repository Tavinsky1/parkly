import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class SpotService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> shareCurrentLocation({String note = ''}) async {
    final pos = await Geolocator.getCurrentPosition();
    await _firestore.collection('spots').add({
      'lat': pos.latitude,
      'lng': pos.longitude,
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<List<Spot>> getLiveSpots() async {
    final snapshot = await _firestore
        .collection('spots')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    return snapshot.docs.map((doc) => Spot.fromFirestore(doc)).toList();
  }
}

class Spot {
  final String id;
  final double lat;
  final double lng;
  final String note;

  Spot({required this.id, required this.lat, required this.lng, required this.note});

  factory Spot.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Spot(
      id: doc.id,
      lat: data['lat'],
      lng: data['lng'],
      note: data['note'] ?? '',
    );
  }
}
