import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Method หลักทีRun
void main() {
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 209, 57)),
        useMaterial3: true,
      ),
      home: ShowProduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class ShowProduct extends StatefulWidget {
  @override
  State<ShowProduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowProduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

// สร้าง referenceชื่อ dbRef ไปยังตารางชื่อ products
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];
  Future<void> fetchProducts() async {
    try {
//เติมบรรทัดที่ใช้ query ข้อมูล กรองสินค้า
      final query = dbRef.orderByChild('price').startAt(0);

// ดึงข้อมูลจาก Realtime Database
      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
// วนลูปเพื่อแปลงข้อมูลเป็ น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
// อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
// แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MMMM/yyyy').format(parsedDate);
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 239, 247),
        title: Text('แสดงข้อมูลสินค้า'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(
              255, 255, 209, 57), // ใส่สีพื้นหลัง (สามารถเปลี่ยนได้ตามต้องการ)
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // ถ้ามีรูปภาพพื้นหลัง
            fit: BoxFit.cover, // ทำให้ภาพขยายเต็มจอ
          ),
        ),
        child: products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: ListTile(
                      title: Text(
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 216, 176, 0)),
                          product['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('รายละเอียดสินค้า: ${product['description']}'),
                          Text(
                              'วันที่ผลิตสินค้า: ${formatDate(product['productionDate'])}'),
                        ],
                      ),
                      trailing: Text(
                          style: TextStyle(fontSize: 14),
                          'ราคา : ${product['price']} บาท'),
                      onTap: () {
                        //เมื่อกดที่แต่ละรายการจะเกิดอะไรขึ้น
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
