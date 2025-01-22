import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 209, 57)),
        useMaterial3: true,
      ),
      home: const ShowProductGrid(),
    );
  }
}

class ShowProductGrid extends StatefulWidget {
  const ShowProductGrid({super.key});

  @override
  State<ShowProductGrid> createState() => _ShowProductGridState();
}

class _ShowProductGridState extends State<ShowProductGrid> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final query = dbRef.orderByChild('price').startAt(0);
      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;
          loadedProducts.add(product);
        });
        // เรียงสินค้าตามราคา จากน้อยไปมาก
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
        setState(() {
          products = loadedProducts;
        });
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
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
    fetchProducts();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  //ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
            //ปุ่มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
            //ปุ่มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
                //ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                  ),
                );
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

//ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(
      Map<String, dynamic> product, BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
    String selectedCategory = categories.contains(product['category'])
        ? product['category']
        : categories.first;
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController quaController =
        TextEditingController(text: product['quantity'].toString());
    TextEditingController dateController =
        TextEditingController(text: product['productionDate']);

    void _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(dateController.text),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != DateTime.parse(dateController.text)) {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: 'ประเภท'),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    }
                  },
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: quaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(labelText: 'วันที่ผลิต'),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_today),
                      tooltip: 'เลือกวันที่',
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'category': selectedCategory,
                  'quantity': int.parse(quaController.text),
                  'price': int.parse(priceController.text),
                  'productionDate': dateController.text,
                };

                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });

                Navigator.of(dialogContext).pop();
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 239, 247),
        title: const Text('แสดงข้อมูลสินค้า'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // ถ้ามีรูปภาพพื้นหลัง
            fit: BoxFit.cover, // ทำให้ภาพขยายเต็มจอ
          ),
        ),
        child: products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // จำนวนคอลัมน์
                  crossAxisSpacing: 5, // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 5, // ระยะห่างระหว่างแถว
                  childAspectRatio: 3 / 3, // อัตราส่วนความกว้าง/ความสูง
                ),
                padding: const EdgeInsets.all(8.0),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 3,
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // สีพื้นหลังของการ์ด
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 5), // ลดระยะห่าง
                    child: Padding(
                      padding:
                          const EdgeInsets.all(10.0), // เพิ่มระยะห่างภายในการ์ด
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              product['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 216, 176, 0),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 8), // เว้นระยะห่างระหว่างข้อความ
                          Text(
                            'รายละเอียด: ${product['description']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                              height: 8), // เว้นระยะห่างระหว่างข้อความ
                          Text(
                            'ราคา: ${product['price']} บาท',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          Align(
                            alignment: Alignment
                                .bottomCenter, // จัดให้อยู่กึ่งกลางด้านล่าง
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // จัดปุ่มให้อยู่ตรงกลาง
                              children: [
                                // ปุ่มลบ
                                Container(
                                  width: 50, // กำหนดความกว้าง
                                  height: 50, // กำหนดความสูง
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10), // ระยะห่างระหว่างปุ่ม
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255), // พื้นหลังสีขาว
                                    shape: BoxShape.circle, // รูปทรงวงกลม
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showDeleteConfirmationDialog(
                                          product['key'], context);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114), // สีของไอคอน
                                    iconSize: 24,
                                    tooltip: 'ลบสินค้า',
                                  ),
                                ),
                                // ปุ่มแก้ไข
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showEditProductDialog(product, context);
                                    },
                                    icon: const Icon(Icons.edit),
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114),
                                    iconSize: 24,
                                    tooltip: 'แก้ไขสินค้า',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

extension on TextEditingController {
  toIso8601String() {}
}
