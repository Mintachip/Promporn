import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onlinedb_promporn/productdetail.dart';

class ShowFilterType extends StatefulWidget {
  final String category;

  ShowFilterType({required this.category});

  @override
  _ShowFilterTypeState createState() => _ShowFilterTypeState();
}

class _ShowFilterTypeState extends State<ShowFilterType> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  // ดึงข้อมูลสินค้าโดยกรองตามประเภท
  Future<void> fetchProducts() async {
    try {
      // Query ข้อมูลที่มีประเภทตรงกับ category
      final query = dbRef.orderByChild('category').equalTo(widget.category);

      // ดึงข้อมูลจาก Firebase
      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key; // เก็บ key สำหรับอ้างอิง
          loadedProducts.add(product);
        });
        setState(() {
          products = loadedProducts;
        });
      } else {
        print("ไม่พบสินค้าในหมวดหมู่ ${widget.category}");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // ดึงข้อมูลสินค้าเมื่อหน้าโหลด
  }

  // แปลงวันที่ให้อยู่ในรูปแบบที่อ่านง่าย
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 218, 239, 247),
          title: Text('แสดงข้อมูล'),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 209,
                57), // ใส่สีพื้นหลัง (สามารถเปลี่ยนได้ตามต้องการ)
            image: DecorationImage(
              image: AssetImage('assets/bg.png'), // ถ้ามีรูปภาพพื้นหลัง
              fit: BoxFit.cover, // ทำให้ภาพขยายเต็มจอ
            ),
          ),
          child: products.isEmpty
              ? Center(
                  child: Text(
                    'ไม่มีข้อมูลสินค้าในหมวดหมู่ "${widget.category}"',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                product:
                                    product, // ส่งข้อมูลสินค้าไปยังหน้า ProductDetail
                              ),
                            ),
                          );
                        },
                        title: Text(
                          product['name'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 216, 176, 0)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'รายละเอียดสินค้า: ${product['description']} ประเภท: ${product['category']}'),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'วันที่ผลิต: ${formatDate(product['productionDate'])}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'จำนวน: ${product['quantity']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text(
                          'ราคา: ${product['price']} บาท',
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}
