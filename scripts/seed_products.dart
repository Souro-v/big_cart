import 'package:big_cart/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  await seedProducts();
  runApp(const SizedBox());
}

Future<void> seedProducts() async {
  final col = FirebaseFirestore.instance.collection('products');

  final products = [
    // ===== Vegetables (13) =====
    {'name': 'Fresh Broccoli',    'imageUrl': 'vegetables1',  'category': 'Vegetables', 'price': 2.50, 'unit': '1 kg',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Fresh and crispy broccoli florets rich in vitamins.'},
    {'name': 'Fresh Carrot',      'imageUrl': 'vegetables2',  'category': 'Vegetables', 'price': 1.99, 'unit': '500 g',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Organic carrots rich in vitamins and minerals.'},
    {'name': 'Fresh Tomato',      'imageUrl': 'vegetables3',  'category': 'Vegetables', 'price': 3.00, 'unit': '1 kg',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Juicy red tomatoes perfect for salads and cooking.'},
    {'name': 'Fresh Spinach',     'imageUrl': 'vegetables4',  'category': 'Vegetables', 'price': 2.25, 'unit': '250 g',  'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Fresh spinach leaves packed with iron and nutrients.'},
    {'name': 'Fresh Cucumber',    'imageUrl': 'vegetables5',  'category': 'Vegetables', 'price': 1.75, 'unit': '500 g',  'isNew': false, 'discount': 10, 'inStock': true, 'description': 'Cool and crispy fresh cucumbers, great for salads.'},
    {'name': 'Fresh Capsicum',    'imageUrl': 'vegetables6',  'category': 'Vegetables', 'price': 2.99, 'unit': '500 g',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Colorful capsicums full of vitamins and antioxidants.'},
    {'name': 'Fresh Onion',       'imageUrl': 'vegetables7',  'category': 'Vegetables', 'price': 1.50, 'unit': '1 kg',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Fresh onions essential for everyday cooking.'},
    {'name': 'Fresh Potato',      'imageUrl': 'vegetables8',  'category': 'Vegetables', 'price': 2.00, 'unit': '1 kg',   'isNew': false, 'discount': 5,  'inStock': true, 'description': 'Fresh potatoes, versatile and delicious for any dish.'},
    {'name': 'Fresh Ginger',      'imageUrl': 'vegetables9',  'category': 'Vegetables', 'price': 3.25, 'unit': '250 g',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Fresh ginger root with strong aroma and health benefits.'},
    {'name': 'Fresh Garlic',      'imageUrl': 'vegetables10', 'category': 'Vegetables', 'price': 2.75, 'unit': '250 g',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Fresh garlic cloves full of flavor and nutrition.'},
    {'name': 'Fresh Pumpkin',     'imageUrl': 'vegetables11', 'category': 'Vegetables', 'price': 3.50, 'unit': '1 kg',   'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Sweet and nutritious fresh pumpkin for soups and curries.'},
    {'name': 'Fresh Cauliflower', 'imageUrl': 'vegetables12', 'category': 'Vegetables', 'price': 2.50, 'unit': '500 g',  'isNew': false, 'discount': 15, 'inStock': true, 'description': 'Fresh cauliflower rich in nutrients and fiber.'},
    {'name': 'Fresh Cabbage',     'imageUrl': 'vegetables13', 'category': 'Vegetables', 'price': 1.99, 'unit': '1 kg',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Fresh cabbage perfect for cooking and salads.'},

    // ===== Beverages (9) =====
    {'name': 'Orange Juice',   'imageUrl': 'cold1', 'category': 'Beverages', 'price': 2.99, 'unit': '1 liter', 'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Freshly squeezed orange juice rich in Vitamin C.'},
    {'name': 'Apple Juice',    'imageUrl': 'cold2', 'category': 'Beverages', 'price': 3.50, 'unit': '1 liter', 'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Fresh apple juice packed with natural sweetness.'},
    {'name': 'Mango Juice',    'imageUrl': 'cold3', 'category': 'Beverages', 'price': 3.99, 'unit': '1 liter', 'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Delicious mango juice made from fresh ripe mangoes.'},
    {'name': 'Coconut Water',  'imageUrl': 'cold4', 'category': 'Beverages', 'price': 2.50, 'unit': '500 ml',  'isNew': false, 'discount': 10, 'inStock': true, 'description': 'Natural coconut water, refreshing and hydrating.'},
    {'name': 'Green Tea',      'imageUrl': 'cold5', 'category': 'Beverages', 'price': 5.99, 'unit': '20 bags', 'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Premium green tea with antioxidants for healthy lifestyle.'},
    {'name': 'Lemon Drink',    'imageUrl': 'cold6', 'category': 'Beverages', 'price': 1.99, 'unit': '500 ml',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Refreshing lemon drink with a perfect tangy taste.'},
    {'name': 'Grape Juice',    'imageUrl': 'cold7', 'category': 'Beverages', 'price': 4.50, 'unit': '1 liter', 'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Sweet grape juice made from fresh grapes.'},
    {'name': 'Strawberry Shake','imageUrl': 'cold8','category': 'Beverages', 'price': 3.99, 'unit': '500 ml',  'isNew': false, 'discount': 15, 'inStock': true, 'description': 'Creamy strawberry shake made with fresh strawberries.'},
    {'name': 'Pineapple Juice', 'imageUrl': 'cold9','category': 'Beverages', 'price': 3.25, 'unit': '1 liter', 'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Tropical pineapple juice with sweet and tangy flavor.'},

    // ===== Edible Oil (7) =====
    {'name': 'Olive Oil',       'imageUrl': 'edibleoil1', 'category': 'Edible oil', 'price': 12.99, 'unit': '750 ml',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Extra virgin olive oil cold pressed for maximum nutrition.'},
    {'name': 'Sunflower Oil',   'imageUrl': 'edibleoil2', 'category': 'Edible oil', 'price': 6.99,  'unit': '1 liter', 'isNew': false, 'discount': 10, 'inStock': true, 'description': 'Pure sunflower oil, light and ideal for cooking.'},
    {'name': 'Coconut Oil',     'imageUrl': 'edibleoil3', 'category': 'Edible oil', 'price': 9.99,  'unit': '500 ml',  'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Pure coconut oil perfect for cooking and skincare.'},
    {'name': 'Mustard Oil',     'imageUrl': 'edibleoil4', 'category': 'Edible oil', 'price': 5.99,  'unit': '1 liter', 'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Pure mustard oil with strong flavor for cooking.'},
    {'name': 'Soybean Oil',     'imageUrl': 'edibleoil5', 'category': 'Edible oil', 'price': 7.50,  'unit': '2 liter', 'isNew': false, 'discount': 15, 'inStock': true, 'description': 'Pure soybean oil rich in omega-3 fatty acids.'},
    {'name': 'Canola Oil',      'imageUrl': 'edibleoil6', 'category': 'Edible oil', 'price': 8.99,  'unit': '1 liter', 'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Light canola oil with low saturated fat content.'},
    {'name': 'Rice Bran Oil',   'imageUrl': 'edibleoil7', 'category': 'Edible oil', 'price': 10.99, 'unit': '1 liter', 'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Healthy rice bran oil perfect for high heat cooking.'},

    // ===== Grocery (10) =====
    {'name': 'Basmati Rice',  'imageUrl': 'grocery1',  'category': 'Grocery', 'price': 8.99,  'unit': '5 kg',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Premium quality basmati rice with long aromatic grains.'},
    {'name': 'Pasta',         'imageUrl': 'grocery2',  'category': 'Grocery', 'price': 2.99,  'unit': '500 g',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Italian style pasta made from durum wheat semolina.'},
    {'name': 'Whole Wheat Bread','imageUrl': 'grocery3','category': 'Grocery', 'price': 1.99, 'unit': '400 g',  'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Freshly baked whole wheat bread, soft and nutritious.'},
    {'name': 'Oats',          'imageUrl': 'grocery4',  'category': 'Grocery', 'price': 4.50,  'unit': '1 kg',   'isNew': false, 'discount': 10, 'inStock': true, 'description': 'Healthy oats rich in fiber and nutrients for breakfast.'},
    {'name': 'Sugar',         'imageUrl': 'grocery5',  'category': 'Grocery', 'price': 2.50,  'unit': '1 kg',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Pure refined white sugar for everyday use.'},
    {'name': 'Salt',          'imageUrl': 'grocery6',  'category': 'Grocery', 'price': 0.99,  'unit': '1 kg',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Pure iodized salt essential for cooking.'},
    {'name': 'Flour',         'imageUrl': 'grocery7',  'category': 'Grocery', 'price': 3.50,  'unit': '2 kg',   'isNew': false, 'discount': 5,  'inStock': true, 'description': 'Fine all purpose flour perfect for baking and cooking.'},
    {'name': 'Lentils',       'imageUrl': 'grocery8',  'category': 'Grocery', 'price': 5.99,  'unit': '1 kg',   'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Nutritious lentils high in protein and fiber.'},
    {'name': 'Chickpeas',     'imageUrl': 'grocery9',  'category': 'Grocery', 'price': 4.99,  'unit': '500 g',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Healthy chickpeas perfect for curries and salads.'},
    {'name': 'Honey',         'imageUrl': 'grocery10', 'category': 'Grocery', 'price': 7.99,  'unit': '500 g',  'isNew': false, 'discount': 20, 'inStock': true, 'description': 'Pure natural honey with amazing taste and health benefits.'},

    // ===== Household (16) =====
    {'name': 'Dish Soap',        'imageUrl': 'household1',  'category': 'Household', 'price': 2.99, 'unit': '500 ml',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Powerful dish soap that cuts through grease effectively.'},
    {'name': 'Hand Wash',        'imageUrl': 'household2',  'category': 'Household', 'price': 2.50, 'unit': '250 ml',  'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Gentle moisturizing hand wash with fresh fragrance.'},
    {'name': 'Shampoo',          'imageUrl': 'household3',  'category': 'Household', 'price': 5.99, 'unit': '400 ml',  'isNew': false, 'discount': 10, 'inStock': true, 'description': 'Nourishing shampoo for healthy and shiny hair.'},
    {'name': 'Conditioner',      'imageUrl': 'household4',  'category': 'Household', 'price': 6.50, 'unit': '400 ml',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Moisturizing conditioner for smooth and silky hair.'},
    {'name': 'Body Wash',        'imageUrl': 'household5',  'category': 'Household', 'price': 4.99, 'unit': '500 ml',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Refreshing body wash with natural ingredients.'},
    {'name': 'Toothpaste',       'imageUrl': 'household6',  'category': 'Household', 'price': 2.25, 'unit': '150 g',   'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Whitening toothpaste for strong and healthy teeth.'},
    {'name': 'Toilet Paper',     'imageUrl': 'household7',  'category': 'Household', 'price': 3.99, 'unit': '12 rolls','isNew': false, 'discount': 15, 'inStock': true, 'description': 'Soft and strong toilet paper for everyday use.'},
    {'name': 'Laundry Detergent','imageUrl': 'household8',  'category': 'Household', 'price': 7.99, 'unit': '1 kg',    'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Powerful laundry detergent for clean and fresh clothes.'},
    {'name': 'Floor Cleaner',    'imageUrl': 'household9',  'category': 'Household', 'price': 4.50, 'unit': '1 liter', 'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Effective floor cleaner with fresh fragrance.'},
    {'name': 'Glass Cleaner',    'imageUrl': 'household10', 'category': 'Household', 'price': 3.25, 'unit': '500 ml',  'isNew': false, 'discount': 20, 'inStock': true, 'description': 'Streak free glass cleaner for sparkling clean surfaces.'},
    {'name': 'Insect Repellent', 'imageUrl': 'household11', 'category': 'Household', 'price': 5.50, 'unit': '300 ml',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Effective insect repellent to keep bugs away.'},
    {'name': 'Air Freshener',    'imageUrl': 'household12', 'category': 'Household', 'price': 3.75, 'unit': '300 ml',  'isNew': true,  'discount': 0,  'inStock': true, 'description': 'Long lasting air freshener with pleasant fragrance.'},
    {'name': 'Tissue Paper',     'imageUrl': 'household13', 'category': 'Household', 'price': 2.99, 'unit': '200 pcs', 'isNew': false, 'discount': 10, 'inStock': true, 'description': 'Soft and gentle tissue paper for everyday use.'},
    {'name': 'Garbage Bags',     'imageUrl': 'household14', 'category': 'Household', 'price': 2.50, 'unit': '30 pcs',  'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Strong and durable garbage bags for waste disposal.'},
    {'name': 'Sponge',           'imageUrl': 'household15', 'category': 'Household', 'price': 1.99, 'unit': '3 pcs',   'isNew': false, 'discount': 5,  'inStock': true, 'description': 'Multi purpose cleaning sponge for kitchen and bathroom.'},
    {'name': 'Mop Refill',       'imageUrl': 'household16', 'category': 'Household', 'price': 6.99, 'unit': '1 pc',    'isNew': false, 'discount': 0,  'inStock': true, 'description': 'Durable mop refill for effective floor cleaning.'},
  ];

  int count = 0;
  for (final product in products) {
    await col.add(product);
    count++;
    print('✅ Added $count/${products.length}: ${product['name']}');
  }
  print('🎉 All $count products seeded successfully!');
}