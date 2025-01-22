import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onlinedb_promporn/showProduct.dart';
import 'showProduct.dart';

//Method หลักทีRun
void main() {
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 57, 199, 255)),
        useMaterial3: true,
      ),
      home: addproduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<addproduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
//ส่วนการออกแบบหน้าจอ
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quaController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

//ประกาศตัวแปรDDL
  final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  String? selectedCategory;

//ประกาศตัวแปรเก็บค่าการเลือกวันที่
  DateTime? productionDate;

//สร้างฟังก์ชันให้เลือกวันที่
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;

        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  //ประกาศตัวแปรส่วนลด
  int? selectedQuantity;

  // ฟังก์ชันเคลียร์ข้อมูลทั้งหมด
  void _clearForm() {
    // เคลียร์ข้อมูลใน TextFormField
    nameController.clear();
    desController.clear();
    priceController.clear();
    quaController.clear();
    dateController.clear();

    // เคลียร์การเลือกใน DropdownButton
    setState(() {
      selectedCategory = null;
      productionDate = null;
    });

    // เคลียร์การเลือกใน RadioButton
    setState(() {
      selectedQuantity = null;
    });
  }

  Future<void> saveProductToDatabase() async {
    try {
// สร้าง reference ไปยัง Firebase Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//ข้อมูลสินค้าที่จะจัดเก็บในรูปแบบ Map
      //ชื่อตัวแปรที่รับค่าที่ผู้ใช้ป้อนจากฟอร์มต้องตรงกับชื่อตัวแปรที่ตั้งตอนสร้างฟอร์มเพื่อรับค่า
      Map<String, dynamic> productData = {
        'name': nameController.text,
        'description': desController.text,
        'category': selectedCategory,
        'productionDate': productionDate?.toIso8601String(),
        'price': double.parse(priceController.text),
        'quantity': int.parse(quaController.text),
        'discount': selectedQuantity,
      };
//ใช้คําสั่ง push() เพื่อสร้าง key อัตโนมัติสําหรับสินค้าใหม่
      await dbRef.push().set(productData);
//แจ้งเตือนเมื่อบันทึกสําเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสําเร็จ')),
      );

// นําทางไปยังหน้า ShowProduct
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowProduct()),
      );

// รีเซ็ตฟอร์ม
      _formKey.currentState?.reset();
      nameController.clear();
      desController.clear();
      priceController.clear();
      quaController.clear();
      dateController.clear();
      setState(() {
        selectedCategory = null;
        productionDate = null;
        selectedQuantity = null;
      });
    } catch (e) {
//แจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 239, 247),
        title: Text('Product'),
      ),
      body: Container(
        width: double.infinity, // ครอบคลุมเต็มความกว้างของหน้าจอ
        height:
            MediaQuery.of(context).size.height, // ครอบคลุมเต็มความสูงของหน้าจอ
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // ใส่ไฟล์ภาพพื้นหลังที่ต้องการ
            fit: BoxFit.cover, // ให้ภาพขยายครอบคลุมเต็มพื้นที่
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft, // ทำให้ข้อความชิดซ้าย
                      child: Text(
                        'บันทึกข้อมูลสินค้า',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black, // ปรับสีได้ตามต้องการ
                        ),
                      ),
                    ),
                  ),

                  //สินค้า
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อสินค้า';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //รายละเอียด
                  TextFormField(
                    controller: desController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียดสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อรายละเอียดสินค้า';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //ประเภท
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'ประเภทสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                    ),
                    items: categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกประเภทสินค้า';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //วันที่
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'วันที่ผลิตสินค้า',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => pickProductionDate(context),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกวันที่ผลิตสินค้า';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //ราคา
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'ราคาสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกราคาสินค้า';
                      }
                      if (int.tryParse(value) == null) {
                        return 'กรุณากรอกราคาสินค้าเป็นตัวเลข';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //จำนวน
                  TextFormField(
                    controller: quaController,
                    decoration: InputDecoration(
                      labelText: 'จำนวนสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกจำนวนสินค้า';
                      }
                      if (int.tryParse(value) == null) {
                        return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //ส่วนลด
                  FormField<int>(
                    initialValue: selectedQuantity, // ค่าที่เลือกโดยเริ่มต้น
                    validator: (value) {
                      if (value == null) {
                        return 'กรุณาเลือกส่วนลด';
                      }
                      return null;
                    },
                    builder: (FormFieldState<int> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ส่วนลด',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Radio<int>(
                                value: 1,
                                groupValue: state
                                    .value, // ใช้ state.value แทน selectedQuantity
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedQuantity = value!;
                                  });
                                  state.didChange(
                                      value); // อัปเดตสถานะใน FormField
                                },
                                activeColor: Color.fromARGB(255, 255, 244, 200),
                              ),
                              Text('ไม่ให้ส่วนลด'),
                              Radio<int>(
                                value: 2,
                                groupValue: state
                                    .value, // ใช้ state.value แทน selectedQuantity
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedQuantity = value!;
                                  });
                                  state.didChange(
                                      value); // อัปเดตสถานะใน FormField
                                },
                                activeColor: Color.fromARGB(255, 255, 244, 200),
                              ),
                              Text('ให้ส่วนลด'),
                            ],
                          ),
                          if (state.hasError)
                            Text(
                              state.errorText ?? '',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  // ปุ่มบันทึกและปุ่มเคลียร์ข้อมูล
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 150, // ขนาดความกว้างของปุ่ม
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // ดำเนินการเมื่อฟอร์มผ่านการตรวจสอบ
                              saveProductToDatabase();
                            }
                          },
                          child: Text(
                            'บันทึกสินค้า',
                            style: TextStyle(
                              color: Colors.black, // เปลี่ยนสีตัวหนังสือ
                              fontSize: 16, // ขนาดตัวหนังสือ
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 255, 244, 200), // เปลี่ยนสีพื้นหลังของปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // ขอบมนของปุ่ม
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20), // การตั้งค่าระยะห่างภายในปุ่ม
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150, // ขนาดความกว้างของปุ่ม
                        child: ElevatedButton(
                          onPressed: _clearForm,
                          child: Text(
                            'เคลียร์ข้อมูล',
                            style: TextStyle(
                              color: Colors.black, // เปลี่ยนสีตัวหนังสือ
                              fontSize: 16, // ขนาดตัวหนังสือ
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 255, 244, 200), // เปลี่ยนสีพื้นหลังของปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // ขอบมนของปุ่ม
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20), // การตั้งค่าระยะห่างภายในปุ่ม
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
