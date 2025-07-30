# 🏨 İstanbul Otel ve Turizm Analiz Sistemi

Bu proje, İstanbul'daki otel endüstrisini analiz eden, turist hareketlerini takip eden ve gelir optimizasyonu sağlayan kapsamlı bir MySQL veritabanı sistemidir.

## 📋 Proje Özeti

- **Sektör:** Turizm ve Otelcilik
- **Teknoloji:** MySQL, Advanced SQL
- **Veri Kapsamı:** 10 otel, 15 müşteri, 20+ rezervasyon, gerçek İstanbul lokasyonları
- **Analiz Türleri:** Gelir analizi, müşteri segmentasyonu, sezonluk trendler, lokasyon analizi

## 🗄️ Veritabanı Mimarisi

### Ana Tablolar:
1. **oteller** - Otel bilgileri, lokasyonları ve özellikleri
2. **oda_tipleri** - Oda kategorileri, fiyatları ve kapasiteleri
3. **musteriler** - Müşteri profilleri ve demografik bilgiler
4. **rezervasyonlar** - Rezervasyon detayları ve ödeme bilgileri
5. **degerlendirmeler** - Müşteri puanları ve yorumları
6. **turistik_yerler** - İstanbul'daki popüler turistik mekanlar

### İleri SQL Özellikleri:
- **Stored Functions** (Mesafe hesaplama, sezon belirleme)
- **Stored Procedures** (Otomatik aylık raporlar)
- **Triggers** (Otomatik puan güncelleme)
- **Views** (Sık kullanılan analiz sorguları)
- **Window Functions** (Ranking, LAG/LEAD)

## 🚀 Kurulum

```sql
-- Veritabanını oluştur
CREATE DATABASE istanbul_turizm_analizi;
USE istanbul_turizm_analizi;

-- Tüm tabloları ve verileri yükle
source database/complete_setup.sql;
```

## 📊 Temel Analizler

### 1. Otel Performans Analizi
```sql
SELECT * FROM otel_performans_ozeti 
ORDER BY toplam_gelir DESC LIMIT 5;
```

### 2. Sezonluk Trend Analizi
```sql
SELECT sezon_belirle(giris_tarihi) as sezon,
       COUNT(*) as rezervasyon_sayisi,
       SUM(toplam_tutar) as toplam_gelir
FROM rezervasyonlar 
WHERE durum = 'tamamlandı'
GROUP BY sezon_belirle(giris_tarihi);
```

### 3. Müşteri Sadakat Analizi
```sql
SELECT * FROM musteri_profili 
WHERE rezervasyon_sayisi > 1
ORDER BY toplam_harcama DESC;
```

### 4. Aylık Rapor Çıkarma
```sql
CALL aylik_rapor(2024, 7);
```

## 🎯 Proje Çıktıları

### İş Zekası Raporları:
- **Gelir Optimizasyonu:** Hangi oda tipleri daha karlı?
- **Müşteri Segmentasyonu:** VIP müşteriler vs normal müşteriler
- **Sezonluk Planlaması:** Yaz/kış rezervasyon trendleri
- **Lokasyon Analizi:** Turistik yerlere yakınlık avantajı
- **Fiyat Stratejisi:** Dinamik fiyatlandırma önerileri

### Performans Metrikleri:
- Otel doluluk oranları
- Müşteri memnuniyet puanları  
- Rezervasyon iptal oranları
- Müşteri tekrar gelme oranları
- Ülke bazında turist analizi

## 📈 Örnek Bulgular

### En Performanslı Oteller:
1. **Four Seasons Bosphorus** - ₺41,700 toplam gelir
2. **Hilton Istanbul Bosphorus** - ₺30,800 toplam gelir
3. **Pera Palace Hotel** - ₺23,200 toplam gelir

### Müşteri Profili:
- En çok harcama yapan ülke: **ABD** (₺31,700)
- Ortalama konaklama süresi: **3.8 gece**
- En popüler sezon: **Yaz** (%40 rezervasyon)

### Oda Tipi Analizi:
- En karlı: **Boğaz manzaralı odalar** (%15 fiyat artışı)
- En popüler: **Standart odalar** (12 rezervasyon)

## 🛠️ Kullanılan SQL Teknikleri

### Temel Seviye:
- JOIN operasyonları (INNER, LEFT, CROSS)
- Agregat fonksiyonlar (COUNT, SUM, AVG, MAX, MIN)
- GROUP BY ve HAVING filtreleri
- Tarih fonksiyonları (YEAR, MONTH, DATEDIFF)

### İleri Seviye:
- **Window Functions:** RANK(), ROW_NUMBER(), LAG(), LEAD()
- **Stored Functions:** Özel hesaplamalar (mesafe, sezon)
- **Stored Procedures:** Otomatik rapor üretimi
- **Triggers:** Otomatik veri güncellemesi
- **Views:** Karmaşık sorguların basitleştirilmesi
- **CASE WHEN:** Koşullu mantık işlemleri

### Coğrafi Analizler:
- Haversine formülü ile mesafe hesaplama
- Koordinat tabanlı yakınlık analizleri
- Lokasyon bazında performans karşılaştırmaları

## 📁 Dosya Yapısı

```
istanbul-turizm-analizi/
├── database/
│   ├── complete_setup.sql          # Tam kurulum dosyası
│   ├── schema_only.sql            # Sadece tablo yapıları
│   ├── sample_data.sql            # Örnek veriler
│   ├── functions_procedures.sql    # Fonksiyonlar ve prosedürler
│   └── analysis_queries.sql       # Analiz sorguları
├── reports/
│   ├── monthly_reports/           # Aylık raporlar
│   ├── performance_analysis.md    # Performans analizi
│   └── customer_insights.md       # Müşteri analizi
├── docs/
│   ├── README.md                 # Bu dosya
│   ├── database_schema.md        # Veritabanı şeması
│   └── query_examples.md         # Sorgu örnekleri
└── visualizations/
    └── charts/                   # Grafik ve görselleştirmeler
```

## 🎯 Gerçek Dünya Kullanım Alanları

### Otel Yönetimi:
- Dinamik fiyat belirleme stratejileri
- Müşteri segmentasyonu ve pazarlama
- Operasyonel verimlilik optimizasyonu
- Gelir yönetimi (Revenue Management)

### Turizm Analizi:
- Şehir turizm planlaması
- Destinasyon pazarlama stratejileri  
- Sezonluk kapasite planlama
- Rekabet analizi

### İş Zekası:
- KPI dashboardları için veri kaynağı
- Tahmine dayalı analitik
- Müşteri yaşam boyu değeri hesaplama
- Pazar trend analizi

## 🔍 İleri Analiz Örnekleri

### Müşteri Yaşam Boyu Değeri:
```sql
SELECT musteri_id, toplam_harcama,
       rezervasyon_sayisi,
       DATEDIFF(son_konaklama, ilk_konaklama) as sadakat_gun,
       toplam_harcama / rezervasyon_sayisi as ortalama_harcama
FROM musteri_profili
ORDER BY toplam_harcama DESC;
```

### Fiyat Elastikiyeti:
```sql
SELECT oda_tipi, temel_fiyat, 
       AVG(toplam_tutar/gece_sayisi) as gerceklesn_fiyat,
       COUNT(*) as talep
FROM oda_tipleri ot
JOIN rezervasyonlar r ON ot.oda_tip_id = r.oda_tip_id
GROUP BY oda_tipi, temel_fiyat;
```

---

**Not:** Bu proje eğitim amaçlıdır. Gerçek otel verileri değil, benzetim verileri kullanılmıştır.
