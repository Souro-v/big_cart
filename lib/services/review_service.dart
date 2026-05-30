import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Review save
  Future<void> addReview(ReviewModel review) async {
    await _db.collection('reviews').add(review.toMap());

    // Product  average rating update
    await _updateProductRating(review.productId);
  }

  // Product  average rating calculate
  Future<void> _updateProductRating(String productId) async {
    final snap = await _db
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();

    if (snap.docs.isEmpty) return;

    final total = snap.docs.fold<int>(
      0,
      (sum, doc) => sum + (doc.data()['rating'] as int),
    );
    final avg = total / snap.docs.length;

    await _db.collection('products').doc(productId).update({
      'rating': avg,
      'reviewCount': snap.docs.length,
    });
  }

  // Product reviews
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final snap = await _db
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs
        .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
