import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlinedb_promporn/addproduct.dart';
import 'package:onlinedb_promporn/showProduct.dart';
import 'package:onlinedb_promporn/showfiltertype.dart';
import 'package:onlinedb_promporn/showproductgrid.dart';
import 'package:onlinedb_promporn/showproducttype.dart';

// Method หลักที Run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDuAs1-6_MwEolPEMCKCy03uU2_qTO8cA8",
            authDomain: "eventsfirebase-d79f8.firebaseapp.com",
            databaseURL:
                "https://eventsfirebase-d79f8-default-rtdb.firebaseio.com",
            projectId: "eventsfirebase-d79f8",
            storageBucket: "eventsfirebase-d79f8.firebasestorage.app",
            messagingSenderId: "574003272790",
            appId: "1:574003272790:web:a6dcf4f92449e56d54aff7",
            measurementId: "G-CM6CLECJZD"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

// Class stateless สั่งแสดงผลหน้าจอ
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
      home: Main(),
    );
  }
}

// Class stateful เรียกใช้การทำงานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 239, 247),
        title: Text('Homepage'),
      ),
      body: Container(
        // เพิ่ม Container เพื่อใส่พื้นหลัง
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // ถ้ามีรูปภาพพื้นหลัง
            fit: BoxFit.cover, // ทำให้ภาพขยายเต็มจอ
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // จัดข้อความให้ชิดกลาง
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft, // ทำให้ข้อความชิดซ้าย
                ),
              ),
              // เพิ่มรูปด้านบนปุ่ม
              Image.asset(
                'assets/logo.png', // ใส่ชื่อไฟล์รูปภาพที่อยู่ใน assets
                height: 180, // ปรับขนาดรูปภาพ
                width: 180, // ปรับขนาดรูปภาพ
              ),
              SizedBox(
                height: 15,
              ),
              //ปุ่ม1
              ElevatedButton(
                onPressed: () {
                  // เปิดหน้า AddProductPage เมื่อกดปุ่ม
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => addproduct()),
                  );
                },
                child: Text(
                  'บันทึกข้อมูลสินค้า', // ข้อความของปุ่ม
                  style: TextStyle(
                    color: Colors.black, // เปลี่ยนสีตัวหนังสือ
                    fontSize: 16, // ขนาดตัวหนังสือ
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 255, 244, 200), // เปลี่ยนสีพื้นหลังของปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // ขอบมนของปุ่ม
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 50), // การตั้งค่าระยะห่างภายในปุ่ม
                ),
              ),
              //ปุ่ม2
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  // เปิดหน้า AddProductPage เมื่อกดปุ่ม
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowProductGrid()),
                  );
                },
                child: Text(
                  'แสดงข้อมูลสินค้า', // ข้อความของปุ่ม
                  style: TextStyle(
                    color: Colors.black, // เปลี่ยนสีตัวหนังสือ
                    fontSize: 16, // ขนาดตัวหนังสือ
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 255, 244, 200), // เปลี่ยนสีพื้นหลังของปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // ขอบมนของปุ่ม
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 50), // การตั้งค่าระยะห่างภายในปุ่ม
                ),
              ),
              //ปุ่ม3
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  // เปิดหน้า AddProductPage เมื่อกดปุ่ม
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductProductType()),
                  );
                },
                child: Text(
                  'ประเภทสินค้า', // ข้อความของปุ่ม
                  style: TextStyle(
                    color: Colors.black, // เปลี่ยนสีตัวหนังสือ
                    fontSize: 16, // ขนาดตัวหนังสือ
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 255, 244, 200), // เปลี่ยนสีพื้นหลังของปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // ขอบมนของปุ่ม
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 63), // การตั้งค่าระยะห่างภายในปุ่ม
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
