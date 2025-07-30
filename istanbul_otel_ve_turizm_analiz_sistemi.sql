-- istanbul otel ve turizm analiz sistemi
-- tam proje kodu - mysql

-- 1. veritabanı oluşturma
create database istanbul_turizm_analizi;
use istanbul_turizm_analizi;

-- 2. oteller tablosu
create table oteller (
    otel_id int primary key auto_increment,
    otel_adi varchar(100) not null,
    ilce varchar(50) not null,
    enlem decimal(10, 7) not null,
    boylam decimal(10, 7) not null,
    yildiz_sayisi enum('1', '2', '3', '4', '5') not null,
    oda_sayisi int not null,
    acilis_tarihi date,
    otel_tipi enum('butik', 'chain', 'resort', 'business') not null,
    wifi boolean default true,
    havuz boolean default false,
    spa boolean default false,
    ortalama_puan decimal(3,2) default 0.00
);

-- 3. oda tipleri tablosu
create table oda_tipleri (
    oda_tip_id int primary key auto_increment,
    otel_id int,
    oda_tipi varchar(50) not null,
    oda_sayisi int not null,
    temel_fiyat decimal(8,2) not null,
    max_kisi_sayisi int not null,
    alan_m2 int,
    manzara enum('deniz', 'şehir', 'bahçe', 'iç bahçe') default 'iç bahçe',
    foreign key (otel_id) references oteller(otel_id)
);

-- 4. müşteriler tablosu
create table musteriler (
    musteri_id int primary key auto_increment,
    ad varchar(50) not null,
    soyad varchar(50) not null,
    email varchar(100) unique not null,
    telefon varchar(20),
    dogum_tarihi date,
    ulke varchar(50) not null,
    sehir varchar(50),
    cinsiyet enum('erkek', 'kadın', 'belirtmek istemiyorum'),
    kayit_tarihi datetime default current_timestamp,
    vip_status boolean default false
);

-- 5. rezervasyonlar tablosu
create table rezervasyonlar (
    rezervasyon_id int primary key auto_increment,
    otel_id int,
    musteri_id int,
    oda_tip_id int,
    giris_tarihi date not null,
    cikis_tarihi date not null,
    gece_sayisi int as (datediff(cikis_tarihi, giris_tarihi)) stored,
    yetiskin_sayisi int default 1,
    cocuk_sayisi int default 0,
    rezervasyon_tarihi datetime default current_timestamp,
    durum enum('onaylandı', 'iptal', 'tamamlandı', 'no-show') default 'onaylandı',
    toplam_tutar decimal(10,2),
    odeme_durumu enum('ödendi', 'bekliyor', 'iade') default 'bekliyor',
    foreign key (otel_id) references oteller(otel_id),
    foreign key (musteri_id) references musteriler(musteri_id),
    foreign key (oda_tip_id) references oda_tipleri(oda_tip_id)
);

-- 6. değerlendirmeler tablosu
create table degerlendirmeler (
    degerlendirme_id int primary key auto_increment,
    rezervasyon_id int,
    musteri_id int,
    otel_id int,
    puan int check (puan between 1 and 10),
    temizlik_puan int check (temizlik_puan between 1 and 10),
    hizmet_puan int check (hizmet_puan between 1 and 10),
    lokasyon_puan int check (lokasyon_puan between 1 and 10),
    yorum text,
    degerlendirme_tarihi datetime default current_timestamp,
    foreign key (rezervasyon_id) references rezervasyonlar(rezervasyon_id),
    foreign key (musteri_id) references musteriler(musteri_id),
    foreign key (otel_id) references oteller(otel_id)
);

-- 7. turistik yerler tablosu
create table turistik_yerler (
    yer_id int primary key auto_increment,
    yer_adi varchar(100) not null,
    kategori enum('müze', 'cami', 'saray', 'park', 'alışveriş', 'eğlence') not null,
    enlem decimal(10, 7) not null,
    boylam decimal(10, 7) not null,
    ilce varchar(50) not null,
    giris_ucreti decimal(6,2) default 0.00,
    calisma_saatleri varchar(50),
    populerlik_skoru int check (populerlik_skoru between 1 and 100)
);

-- 8. oteller tablosuna veri ekleme
insert into oteller (otel_adi, ilce, enlem, boylam, yildiz_sayisi, oda_sayisi, acilis_tarihi, otel_tipi, wifi, havuz, spa, ortalama_puan) values
('four seasons bosphorus', 'beşiktaş', 41.0420, 29.0050, '5', 170, '2008-06-15', 'chain', true, true, true, 9.2),
('pera palace hotel', 'beyoğlu', 41.0290, 28.9750, '5', 115, '1892-09-01', 'butik', true, false, true, 8.8),
('swissotel the bosphorus', 'beşiktaş', 41.0460, 29.0070, '5', 566, '1991-03-20', 'chain', true, true, true, 8.5),
('sultanahmet palace hotel', 'fatih', 41.0058, 28.9784, '4', 45, '2005-05-10', 'butik', true, false, false, 8.1),
('hilton istanbul bosphorus', 'beşiktaş', 41.0425, 29.0082, '5', 500, '1988-04-12', 'chain', true, true, true, 8.3),
('marriott hotel sisli', 'şişli', 41.0620, 28.9890, '5', 390, '1995-11-08', 'chain', true, true, true, 8.0),
('boutique saint sophia', 'fatih', 41.0080, 28.9800, '3', 28, '2010-03-15', 'butik', true, false, false, 7.8),
('conrad istanbul bosphorus', 'beşiktaş', 41.0390, 29.0040, '5', 590, '2008-09-22', 'chain', true, true, true, 9.0),
('ritz carlton istanbul', 'şişli', 41.0580, 28.9920, '5', 244, '2001-07-30', 'chain', true, true, true, 9.1),
('ajia hotel', 'üsküdar', 40.9980, 29.0280, '5', 16, '2009-05-18', 'butik', true, false, true, 8.9);

-- 9. oda tipleri veri ekleme
insert into oda_tipleri (otel_id, oda_tipi, oda_sayisi, temel_fiyat, max_kisi_sayisi, alan_m2, manzara) values
-- four seasons bosphorus
(1, 'standart oda', 80, 1200.00, 2, 35, 'şehir'),
(1, 'boğaz manzaralı oda', 60, 1800.00, 2, 40, 'deniz'),
(1, 'suite', 30, 3500.00, 4, 80, 'deniz'),

-- pera palace hotel  
(2, 'klasik oda', 70, 800.00, 2, 30, 'şehir'),
(2, 'deluxe oda', 35, 1200.00, 2, 35, 'şehir'),
(2, 'agatha christie suite', 10, 2500.00, 3, 65, 'şehir'),

-- swissotel
(3, 'standart oda', 300, 900.00, 2, 32, 'şehir'),
(3, 'boğaz manzaralı', 200, 1400.00, 2, 38, 'deniz'),
(3, 'executive suite', 66, 2800.00, 4, 75, 'deniz'),

-- sultanahmet palace
(4, 'standart oda', 25, 450.00, 2, 25, 'iç bahçe'),
(4, 'tarihi manzaralı', 20, 650.00, 2, 28, 'şehir'),

-- hilton bosphorus
(5, 'standart oda', 250, 1000.00, 2, 33, 'şehir'),
(5, 'boğaz suite', 150, 1600.00, 3, 45, 'deniz'),
(5, 'presidential suite', 100, 4000.00, 6, 120, 'deniz');

-- 10. müşteriler veri ekleme
insert into musteriler (ad, soyad, email, telefon, dogum_tarihi, ulke, sehir, cinsiyet, vip_status) values
('john', 'smith', 'john.smith@email.com', '+1-555-0101', '1985-03-15', 'abd', 'new york', 'erkek', false),
('maria', 'garcia', 'maria.garcia@email.com', '+34-600-123456', '1990-07-22', 'ispanya', 'madrid', 'kadın', true),
('hans', 'mueller', 'hans.mueller@email.com', '+49-30-12345678', '1978-11-08', 'almanya', 'berlin', 'erkek', false),
('sophie', 'dubois', 'sophie.dubois@email.com', '+33-1-23456789', '1992-02-14', 'fransa', 'paris', 'kadın', false),
('hiroshi', 'tanaka', 'hiroshi.tanaka@email.com', '+81-3-12345678', '1980-09-30', 'japonya', 'tokyo', 'erkek', true),
('emma', 'johnson', 'emma.johnson@email.com', '+44-20-12345678', '1988-05-12', 'ingiltere', 'londra', 'kadın', false),
('ahmed', 'hassan', 'ahmed.hassan@email.com', '+971-4-1234567', '1975-12-03', 'bae', 'dubai', 'erkek', true),
('anna', 'petrov', 'anna.petrov@email.com', '+7-495-1234567', '1993-08-20', 'rusya', 'moskova', 'kadın', false),
('carlos', 'rodriguez', 'carlos.rodriguez@email.com', '+54-11-12345678', '1987-04-25', 'arjantin', 'buenos aires', 'erkek', false),
('lisa', 'anderson', 'lisa.anderson@email.com', '+61-2-12345678', '1991-10-18', 'avustralya', 'sydney', 'kadın', false),
('giuseppe', 'rossi', 'giuseppe.rossi@email.com', '+39-06-12345678', '1982-01-07', 'italya', 'roma', 'erkek', false),
('fatima', 'al-zahra', 'fatima.alzahra@email.com', '+966-11-1234567', '1989-06-15', 'suudi arabistan', 'riyad', 'kadın', false),
('pierre', 'martin', 'pierre.martin@email.com', '+33-4-12345678', '1979-03-28', 'fransa', 'lyon', 'erkek', true),
('yuki', 'sato', 'yuki.sato@email.com', '+81-6-12345678', '1994-11-11', 'japonya', 'osaka', 'kadın', false),
('david', 'cohen', 'david.cohen@email.com', '+972-3-1234567', '1986-08-05', 'israil', 'tel aviv', 'erkek', false);

-- 11. rezervasyonlar veri ekleme (2023-2024 dönemi)
insert into rezervasyonlar (otel_id, musteri_id, oda_tip_id, giris_tarihi, cikis_tarihi, yetiskin_sayisi, cocuk_sayisi, durum, toplam_tutar, odeme_durumu) values
-- 2023 yazı
(1, 1, 2, '2023-06-15', '2023-06-20', 2, 0, 'tamamlandı', 9000.00, 'ödendi'),
(2, 2, 5, '2023-07-10', '2023-07-15', 2, 1, 'tamamlandı', 6000.00, 'ödendi'),
(3, 3, 7, '2023-07-22', '2023-07-25', 2, 0, 'tamamlandı', 4200.00, 'ödendi'),
(1, 4, 3, '2023-08-05', '2023-08-12', 4, 2, 'tamamlandı', 24500.00, 'ödendi'),
(5, 5, 11, '2023-08-15', '2023-08-18', 3, 0, 'tamamlandı', 4800.00, 'ödendi'),

-- 2023 sonbahar
(4, 6, 9, '2023-09-20', '2023-09-23', 2, 0, 'tamamlandı', 1350.00, 'ödendi'),
(2, 7, 6, '2023-10-12', '2023-10-16', 3, 1, 'tamamlandı', 10000.00, 'ödendi'),
(3, 8, 8, '2023-11-08', '2023-11-12', 2, 0, 'tamamlandı', 5600.00, 'ödendi'),

-- 2023 kış
(1, 9, 1, '2023-12-20', '2023-12-25', 2, 0, 'tamamlandı', 6000.00, 'ödendi'),
(5, 10, 12, '2023-12-28', '2024-01-02', 6, 0, 'tamamlandı', 20000.00, 'ödendi'),

-- 2024 bahar
(2, 11, 4, '2024-03-15', '2024-03-18', 2, 0, 'tamamlandı', 2400.00, 'ödendi'),
(4, 12, 10, '2024-04-10', '2024-04-13', 2, 0, 'tamamlandı', 1950.00, 'ödendi'),
(3, 13, 7, '2024-04-25', '2024-04-28', 2, 0, 'tamamlandı', 4200.00, 'ödendi'),

-- 2024 yaz
(1, 14, 2, '2024-06-08', '2024-06-12', 2, 0, 'tamamlandı', 7200.00, 'ödendi'),
(5, 15, 11, '2024-07-18', '2024-07-22', 3, 1, 'tamamlandı', 6400.00, 'ödendi'),
(2, 1, 5, '2024-08-10', '2024-08-14', 2, 0, 'tamamlandı', 4800.00, 'ödendi'),

-- gelecekteki rezervasyonlar
(1, 3, 3, '2024-09-15', '2024-09-20', 4, 0, 'onaylandı', 17500.00, 'ödendi'),
(3, 5, 8, '2024-10-12', '2024-10-15', 2, 0, 'onaylandı', 4200.00, 'bekliyor'),
(4, 8, 9, '2024-11-20', '2024-11-23', 2, 0, 'onaylandı', 1350.00, 'bekliyor'),

-- iptal olan rezervasyonlar
(2, 2, 6, '2024-05-15', '2024-05-20', 3, 2, 'iptal', 12500.00, 'iade'),
(5, 7, 12, '2024-06-20', '2024-06-25', 6, 0, 'iptal', 20000.00, 'iade');

-- 12. değerlendirmeler veri ekleme
insert into degerlendirmeler (rezervasyon_id, musteri_id, otel_id, puan, temizlik_puan, hizmet_puan, lokasyon_puan, yorum) values
(1, 1, 1, 9, 9, 9, 10, 'mükemmel boğaz manzarası ve hizmet kalitesi. kesinlikle tekrar geleceğim.'),
(2, 2, 2, 8, 8, 9, 9, 'tarihi atmosfer harika. kahvaltı çok lezzetliydi.'),
(3, 3, 3, 7, 8, 7, 8, 'iyi bir otel ama biraz pahalı. personel güler yüzlü.'),
(4, 4, 1, 10, 10, 10, 10, 'ailecek harika vakit geçirdik. çocuklar için aktiviteler mükemmeldi.'),
(5, 5, 5, 8, 9, 8, 7, 'temiz ve konforlu. boğaz manzarası çok güzel.'),
(6, 6, 4, 8, 7, 8, 10, 'sultanahmet e çok yakın. tarihi yerlere yürüyerek gidilir.'),
(7, 7, 2, 9, 9, 9, 9, 'lüks ve konforlu. personel çok ilgili.'),
(8, 8, 3, 6, 7, 6, 8, 'ortalama bir deneyim. beklentilerim daha yüksekti.'),
(9, 9, 1, 9, 9, 10, 10, 'yılbaşı kutlaması unutulmazdı. mükemmel organizasyon.'),
(10, 10, 5, 8, 8, 8, 7, 'büyük aile odası çok rahattı. hizmet kalitesi iyi.'),
(11, 11, 2, 8, 8, 8, 9, 'tarihi doku çok etkileyici. kahvaltı zengin ve lezzetli.'),
(12, 12, 4, 7, 7, 7, 10, 'fiyat performans açısından iyi. lokasyon mükemmel.'),
(13, 13, 3, 8, 8, 8, 8, 'standart bir otel deneyimi. şikayetim yok.'),
(14, 14, 1, 9, 9, 9, 10, 'boğazda gün batımı izlemek paha biçilmez.'),
(15, 15, 5, 8, 8, 9, 7, 'havuz alanı çok güzeldi. çocuklar çok eğlendi.');

-- 13. turistik yerler veri ekleme
insert into turistik_yerler (yer_adi, kategori, enlem, boylam, ilce, giris_ucreti, calisma_saatleri, populerlik_skoru) values
('ayasofya müzesi', 'müze', 41.0086, 28.9802, 'fatih', 100.00, '09:00-19:00', 100),
('topkapı sarayı', 'saray', 41.0115, 28.9833, 'fatih', 100.00, '09:00-18:00', 95),
('sultanahmet camii', 'cami', 41.0054, 28.9768, 'fatih', 0.00, '24 saat', 98),
('kapalı çarşı', 'alışveriş', 41.0106, 28.9683, 'fatih', 0.00, '09:00-19:00', 90),
('galata kulesi', 'müze', 41.0256, 28.9744, 'beyoğlu', 100.00, '08:30-22:00', 88),
('dolmabahçe sarayı', 'saray', 41.0391, 29.0000, 'beşiktaş', 60.00, '09:00-16:00', 85),
('beylerbeyi sarayı', 'saray', 41.0414, 29.0436, 'üsküdar', 40.00, '09:00-17:00', 70),
('gülhane parkı', 'park', 41.0130, 28.9820, 'fatih', 0.00, '24 saat', 75),
('emirgan korusu', 'park', 41.1086, 29.0533, 'sarıyer', 0.00, '24 saat', 65),
('istinye park', 'alışveriş', 41.1144, 29.0225, 'sarıyer', 0.00, '10:00-22:00', 80);

-- 14. mesafe hesaplama fonksiyonu
delimiter //
create function mesafe_hesapla_turizm(
    enlem1 decimal(10,7), 
    boylam1 decimal(10,7), 
    enlem2 decimal(10,7), 
    boylam2 decimal(10,7)
) returns decimal(10,3)
reads sql data
deterministic
begin
    declare r decimal(10,3) default 6371;
    declare dlat decimal(10,7);
    declare dlon decimal(10,7);
    declare a decimal(10,7);
    declare c decimal(10,7);
    declare mesafe decimal(10,3);
    
    set dlat = radians(enlem2 - enlem1);
    set dlon = radians(boylam2 - boylam1);
    set a = sin(dlat/2) * sin(dlat/2) + cos(radians(enlem1)) * cos(radians(enlem2)) * sin(dlon/2) * sin(dlon/2);
    set c = 2 * atan2(sqrt(a), sqrt(1-a));
    set mesafe = r * c;
    
    return mesafe;
end//
delimiter ;

-- 15. sezon belirleme fonksiyonu
delimiter //
create function sezon_belirle(tarih date) returns varchar(20)
reads sql data
deterministic
begin
    declare ay int;
    declare sezon varchar(20);
    
    set ay = month(tarih);
    
    case 
        when ay in (12, 1, 2) then set sezon = 'kış';
        when ay in (3, 4, 5) then set sezon = 'bahar';
        when ay in (6, 7, 8) then set sezon = 'yaz';
        when ay in (9, 10, 11) then set sezon = 'sonbahar';
    end case;
    
    return sezon;
end//
delimiter ;

-- 16. otel puan güncelleme trigger'ı
delimiter //
create trigger puan_guncelle_trigger
after insert on degerlendirmeler
for each row
begin
    update oteller 
    set ortalama_puan = (
        select round(avg(puan), 2)
        from degerlendirmeler 
        where otel_id = new.otel_id
    )
    where otel_id = new.otel_id;
end//
delimiter ;

-- 17. temel analiz sorguları

-- otel performans özeti
select 
    o.otel_adi,
    o.yildiz_sayisi,
    o.ortalama_puan,
    count(r.rezervasyon_id) as toplam_rezervasyon,
    sum(case when r.durum = 'tamamlandı' then r.toplam_tutar else 0 end) as toplam_gelir,
    round(avg(case when r.durum = 'tamamlandı' then r.toplam_tutar else null end), 2) as ortalama_rezervasyon_tutari
from oteller o
left join rezervasyonlar r on o.otel_id = r.otel_id
group by o.otel_id, o.otel_adi, o.yildiz_sayisi, o.ortalama_puan
order by toplam_gelir desc;

-- aylık rezervasyon trendi
select 
    year(giris_tarihi) as yil,
    month(giris_tarihi) as ay,
    monthname(giris_tarihi) as ay_adi,
    count(*) as rezervasyon_sayisi,
    sum(toplam_tutar) as toplam_gelir,
    round(avg(toplam_tutar), 2) as ortalama_tutar
from rezervasyonlar
where durum = 'tamamlandı'
group by year(giris_tarihi), month(giris_tarihi)
order by yil, ay;

-- müşteri analizi - hangi ülkeden kaç turist
select 
    m.ulke,
    count(distinct m.musteri_id) as benzersiz_musteri,
    count(r.rezervasyon_id) as toplam_rezervasyon,
    sum(r.toplam_tutar) as toplam_harcama,
    round(avg(r.toplam_tutar), 2) as ortalama_harcama,
    round(sum(r.toplam_tutar) / count(distinct m.musteri_id), 2) as kisi_basi_harcama
from musteriler m
join rezervasyonlar r on m.musteri_id = r.musteri_id
where r.durum = 'tamamlandı'
group by m.musteri_id, m.ad, m.soyad, m.ulke
having rezervasyon_sayisi > 1
order by toplam_harcama desc;

-- otel lokasyon analizi - turistik yerlere yakınlık
select 
    o.otel_adi,
    ty.yer_adi,
    mesafe_hesapla_turizm(o.enlem, o.boylam, ty.enlem, ty.boylam) as mesafe_km,
    ty.populerlik_skoru
from oteller o
cross join turistik_yerler ty
where mesafe_hesapla_turizm(o.enlem, o.boylam, ty.enlem, ty.boylam) < 3
order by o.otel_adi, mesafe_km;

-- en iyi performans gösteren oteller (çoklu metrik)
select 
    o.otel_adi,
    o.ortalama_puan,
    count(r.rezervasyon_id) as rezervasyon_sayisi,
    sum(r.toplam_tutar) as toplam_gelir,
    round(avg(d.puan), 2) as ortalama_degerlendirme,
    round((count(r.rezervasyon_id) * 0.3 + 
           o.ortalama_puan * 0.4 + 
           (sum(r.toplam_tutar)/10000) * 0.3), 2) as performans_skoru
from oteller o
left join rezervasyonlar r on o.otel_id = r.otel_id and r.durum = 'tamamlandı'
left join degerlendirmeler d on o.otel_id = d.otel_id
group by o.otel_id, o.otel_adi, o.ortalama_puan
order by performans_skoru desc;

-- gelir optimizasyon analizi - hangi oda tipi daha karlı
select 
    o.otel_adi,
    ot.oda_tipi,
    ot.temel_fiyat,
    count(r.rezervasyon_id) as rezervasyon_sayisi,
    round(avg(r.toplam_tutar / r.gece_sayisi), 2) as gerceklesn_gecelik_fiyat,
    round(((avg(r.toplam_tutar / r.gece_sayisi) / ot.temel_fiyat) - 1) * 100, 2) as fiyat_artis_yuzdesi,
    sum(r.toplam_tutar) as toplam_gelir
from oteller o
join oda_tipleri ot on o.otel_id = ot.otel_id
join rezervasyonlar r on ot.oda_tip_id = r.oda_tip_id
where r.durum = 'tamamlandı'
group by o.otel_id, o.otel_adi, ot.oda_tip_id, ot.oda_tipi, ot.temel_fiyat
order by fiyat_artis_yuzdesi desc;

-- window functions ile ranking
select 
    otel_adi,
    ortalama_puan,
    rank() over (order by ortalama_puan desc) as puan_sirasi,
    row_number() over (order by ortalama_puan desc) as sira_numarasi,
    lag(ortalama_puan) over (order by ortalama_puan desc) as bir_onceki_puan,
    ortalama_puan - lag(ortalama_puan) over (order by ortalama_puan desc) as puan_farki
from oteller
order by ortalama_puan desc;

-- 18. stored procedure - aylık rapor
delimiter //
create procedure aylik_rapor(in rapor_yil int, in rapor_ay int)
begin
    declare rapor_basligi varchar(100);
    set rapor_basligi = concat(rapor_yil, ' yılı ', rapor_ay, '. ay turizm raporu');
    
    select rapor_basligi as rapor_adi;
    
    -- genel özet
    select 
        count(*) as toplam_rezervasyon,
        count(distinct musteri_id) as benzersiz_musteri,
        sum(toplam_tutar) as toplam_gelir,
        round(avg(toplam_tutar), 2) as ortalama_rezervasyon_tutari,
        round(avg(gece_sayisi), 1) as ortalama_konaklama_suresi
    from rezervasyonlar
    where year(giris_tarihi) = rapor_yil 
    and month(giris_tarihi) = rapor_ay
    and durum = 'tamamlandı';
    
    -- otel bazında performans
    select 
        o.otel_adi,
        count(r.rezervasyon_id) as rezervasyon_sayisi,
        sum(r.toplam_tutar) as gelir,
        round(avg(r.toplam_tutar), 2) as ortalama_tutar
    from oteller o
    join rezervasyonlar r on o.otel_id = r.otel_id
    where year(r.giris_tarihi) = rapor_yil 
    and month(r.giris_tarihi) = rapor_ay
    and r.durum = 'tamamlandı'
    group by o.otel_id, o.otel_adi
    order by gelir desc;
    
    -- ülke bazında turist sayısı
    select 
        m.ulke,
        count(distinct m.musteri_id) as turist_sayisi,
        sum(r.toplam_tutar) as toplam_harcama
    from musteriler m
    join rezervasyonlar r on m.musteri_id = r.musteri_id
    where year(r.giris_tarihi) = rapor_yil 
    and month(r.giris_tarihi) = rapor_ay
    and r.durum = 'tamamlandı'
    group by m.ulke
    order by toplam_harcama desc;
end//
delimiter ;

-- 19. view'lar - sık kullanılan sorgular
create view otel_performans_ozeti as
select 
    o.otel_id,
    o.otel_adi,
    o.yildiz_sayisi,
    o.ortalama_puan,
    count(r.rezervasyon_id) as toplam_rezervasyon,
    sum(case when r.durum = 'tamamlandı' then r.toplam_tutar else 0 end) as toplam_gelir,
    round(avg(case when r.durum = 'tamamlandı' then r.toplam_tutar else null end), 2) as ortalama_rezervasyon_tutari,
    count(case when r.durum = 'iptal' then 1 else null end) as iptal_sayisi,
    round((count(case when r.durum = 'iptal' then 1 else null end) / count(r.rezervasyon_id)) * 100, 2) as iptal_orani
from oteller o
left join rezervasyonlar r on o.otel_id = r.otel_id
group by o.otel_id, o.otel_adi, o.yildiz_sayisi, o.ortalama_puan;

create view musteri_profili as
select 
    m.musteri_id,
    m.ad,
    m.soyad,
    m.ulke,
    m.vip_status,
    count(r.rezervasyon_id) as rezervasyon_sayisi,
    sum(r.toplam_tutar) as toplam_harcama,
    round(avg(r.toplam_tutar), 2) as ortalama_harcama,
    min(r.giris_tarihi) as ilk_konaklama,
    max(r.giris_tarihi) as son_konaklama,
    round(avg(d.puan), 2) as ortalama_degerlendirme_puani
from musteriler m
left join rezervasyonlar r on m.musteri_id = r.musteri_id
left join degerlendirmeler d on m.musteri_id = d.musteri_id
group by m.musteri_id, m.ad, m.soyad, m.ulke, m.vip_status;

-- 20. faydalı kontrol ve analiz sorguları

-- güncel durum özeti
select 
    (select count(*) from oteller) as toplam_otel,
    (select count(*) from musteriler) as toplam_musteri,
    (select count(*) from rezervasyonlar) as toplam_rezervasyon,
    (select count(*) from rezervasyonlar where durum = 'tamamlandı') as tamamlanan_rezervasyon,
    (select sum(toplam_tutar) from rezervasyonlar where durum = 'tamamlandı') as toplam_gelir;

-- boş oda analizi (örnek hesaplama)
select 
    o.otel_adi,
    sum(ot.oda_sayisi) as toplam_oda,
    count(r.rezervasyon_id) as dolu_oda_rezervasyon,
    round((count(r.rezervasyon_id) / sum(ot.oda_sayisi)) * 100, 2) as doluluk_orani_tahmini
from oteller o
join oda_tipleri ot on o.otel_id = ot.otel_id
left join rezervasyonlar r on ot.oda_tip_id = r.oda_tip_id 
    and r.durum in ('onaylandı', 'tamamlandı')
    and curdate() between r.giris_tarihi and r.cikis_tarihi
group by o.otel_id, o.otel_adi
order by doluluk_orani_tahmini desc;

-- gelecekteki rezervasyonlar
select 
    r.rezervasyon_id,
    o.otel_adi,
    m.ad,
    m.soyad,
    r.giris_tarihi,
    r.cikis_tarihi,
    r.toplam_tutar,
    r.odeme_durumu
from rezervasyonlar r
join oteller o on r.otel_id = o.otel_id
join musteriler m on r.musteri_id = m.musteri_id
where r.giris_tarihi > curdate()
and r.durum = 'onaylandı'
order by r.giris_tarihi;

-- stored procedure çağırma örneği
-- call aylik_rapor(2024, 7);

-- view kullanma örnekleri
select * from otel_performans_ozeti order by toplam_gelir desc limit 5;
select * from musteri_profili where vip_status = true order by toplam_harcama desc;
join rezervasyonlar r on m.musteri_id = r.musteri_id
where r.durum = 'tamamlandı'
group by m.ulke
order by toplam_harcama desc;

-- sezonluk analiz
select 
    sezon_belirle(giris_tarihi) as sezon,
    count(*) as rezervasyon_sayisi,
    sum(toplam_tutar) as toplam_gelir,
    round(avg(toplam_tutar), 2) as ortalama_tutar,
    round(avg(gece_sayisi), 1) as ortalama_konaklama_suresi
from rezervasyonlar
where durum = 'tamamlandı'
group by sezon_belirle(giris_tarihi)
order by toplam_gelir desc;

-- en popüler oda tipleri
select 
    ot.oda_tipi,
    count(r.rezervasyon_id) as rezervasyon_sayisi,
    sum(r.toplam_tutar) as toplam_gelir,
    round(avg(r.toplam_tutar), 2) as ortalama_fiyat,
    round((sum(r.toplam_tutar) / sum(r.gece_sayisi)), 2) as gecelik_ortalama
from oda_tipleri ot
join rezervasyonlar r on ot.oda_tip_id = r.oda_tip_id
where r.durum = 'tamamlandı'
group by ot.oda_tipi
order by toplam_gelir desc;

-- müşteri sadakat analizi
select 
    m.ad,
    m.soyad,
    m.ulke,
    count(r.rezervasyon_id) as rezervasyon_sayisi,
    sum(r.toplam_tutar) as toplam_harcama,
    min(r.giris_tarihi) as ilk_konaklama,
    max(r.giris_tarihi) as son_konaklama,
    datediff(max(r.giris_tarihi), min(r.giris_tarihi)) as sadakat_gun_sayisi
from musteriler m