import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Db {
  static Future<SharedPreferences> connect() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> checkLogin() async {
    var cn = await connect();
    bool? r = cn.getBool('login');
    return r ?? false;
  }

  static Future setLogin({required LoginModel model}) async {
    var cn = await connect();
    cn.setString('email', model.email ?? "");
    cn.setString('password', model.password ?? "");
    cn.setString('name', model.name ?? "");
    cn.setString('phone', model.phone ?? "");
    cn.setString('dob', model.dob ?? "");
    cn.setString('gender', model.gender ?? "");
    cn.setString('role', model.role ?? "");
    cn.setString('id', model.id ?? "");
    cn.setString('userId', model.userId ?? "");
    cn.setString('imageUrl', model.imageUrl ?? "");
    cn.setBool('login', true);
  }

  static Future<Map<String, String>?> getData() async {
    var cn = await connect();
    final String? email = cn.getString('email');
    final String? name = cn.getString('name');
    final String? phone = cn.getString('phone');
    final String? dob = cn.getString('dob');
    final String? gender = cn.getString('gender');
    final String? role = cn.getString('role');
    final String? id = cn.getString('id');
    final String? userId = cn.getString('userId');
    final String? imageUrl = cn.getString('imageUrl');

    if (email != null &&
        name != null &&
        phone != null &&
        id != null &&
        userId != null &&
        gender != null &&
        dob != null &&
        role != null) {
      return {
        'email': email,
        'name': name,
        'phone': phone,
        'id': id,
        'userId': userId,
        'gender': gender,
        'role': role,
        'dob': dob,
        'imageUrl': imageUrl ?? "",
      };
    } else {
      return null;
    }
  }

  static Future<bool> clearDb() async {
    var cn = await connect();
    return cn.clear();
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chat")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getchatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chat")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future deleteMessage(String chatRoomId, String messageId) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chat")
        .doc(messageId)
        .delete();
  }

  static Future<Map<String, String>?> getProductData() async {
    var cn = await connect();
    final String? id = cn.getString('product_id');

    if (id != null) {
      return {
        'product_id': id,
      };
    } else {
      return null;
    }
  }

  static Future setProductId({required String model}) async {
    var cn = await connect();
    cn.setString('product_id', model);
  }
}

class LoginModel {
  String? id;
  String? userId;
  String? email;
  String? phone;
  String? dob;
  String? gender;
  String? password;
  String? name;
  String? role;
  String? imageUrl;
  LoginModel({
    this.id,
    this.userId,
    this.email,
    this.password,
    this.phone,
    this.name,
    this.dob,
    this.gender,
    this.role,
    this.imageUrl,
  });
}

class UserModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String role;
  final String imageUrl;
  final String gender;
  final String password;

  UserModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.role,
    required this.imageUrl,
    required this.gender,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      password: json['password'] ?? '',
    );
  }
  @override
  String toString() {
    return 'UserModel(userId: $userId, name: $name, email: $email, phone: $phone,  dob: $dob,  gender: $gender, password: $password, role: $role, imageUrl: $imageUrl)';
  }
}

class ProductModel {
  // ignore: non_constant_identifier_names
  final String product_id;
  final String name;
  final String color;
  final String image;
  final String rate;

  ProductModel({
    // ignore: non_constant_identifier_names
    required this.product_id,
    required this.name,
    required this.rate,
    required this.color,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      product_id: json['product_id'] ?? '',
      name: json['name'] ?? '',
      rate: json['rate'] ?? '',
      color: json['color'] ?? '',
      image: json['image'] ?? '',
    );
  }
  @override
  String toString() {
    return 'ProductModel(product_id: $product_id, name: $name, rate: $rate, color: $color, image: $image)';
  }
}
