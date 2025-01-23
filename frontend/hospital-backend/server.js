const express = require('express');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
const PORT = process.env.PORT || 3000;

// อ่าน Google API Key จากไฟล์ .env
const GOOGLE_API_KEY = process.env.GOOGLE_API_KEY;

// Endpoint สำหรับค้นหาโรงพยาบาลใกล้ตำแหน่งปัจจุบัน
app.get('/nearby-hospitals', async (req, res) => {
  const { lat, lng } = req.query;
  // ตรวจสอบว่ามีการส่ง lat และ lng หรือไม่
  if (!lat || !lng) {
    return res.status(400).json({ error: 'Missing required parameters: lat and lng' });
  }

  try {
    // เรียก Google Places API เพื่อค้นหาโรงพยาบาลใกล้เคียง
    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/place/nearbysearch/json`,
      {
        params: {
          location: `${lat},${lng}`,
          radius: 100000, // เพิ่มรัศมีการค้นหาเป็น 10,000 เมตร (10 กิโลเมตร)
          type: 'hospital', // ประเภทสถานที่เป็นโรงพยาบาล
          key: GOOGLE_API_KEY, // API Key
        },
      }
    );

    console.log('Google Places API Response:', response.data); // แสดงข้อมูลที่ได้รับจาก API

    // ตรวจสอบว่ามีผลลัพธ์หรือไม่
    if (response.data.status === 'ZERO_RESULTS') {
      return res.status(404).json({ error: 'No nearby hospitals found' });
    }

    // ดึงข้อมูลเฉพาะโรงพยาบาล 3 แห่งแรก
    const hospitals = response.data.results.slice(0, 3).map((hospital) => ({
      name: hospital.name,
      address: hospital.vicinity,
      location: hospital.geometry.location,
      rating: hospital.rating || 'N/A', // คะแนน (ถ้ามี)
    }));

    // ส่งผลลัพธ์กลับไปยัง client
    res.status(200).json(hospitals);
  } catch (error) {
    console.error('Error fetching hospitals:', error);
    res.status(500).json({ error: 'Failed to fetch nearby hospitals' });
  }
});

// เริ่มต้นเซิร์ฟเวอร์
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
