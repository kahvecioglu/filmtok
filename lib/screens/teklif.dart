import 'dart:ui'; // Bulanıklaştırma (blur) için
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeklifSayfasi extends StatelessWidget {
  const TeklifSayfasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1) Arka planı bulanıklaştıran katman
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.3), // Arka planı hafif karart
              ),
            ),
          ),
        ),

        // 2) İçerik: DraggableScrollableSheet ile sürüklenebilir alt pencere
        DraggableScrollableSheet(
          initialChildSize: 0.75, // Ekranın %75'i kadar açılır
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      // Üstteki tutma çubuğu
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sınırlı Teklif Başlık
                      const Text(
                        "Sınırlı Teklif",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Açıklama
                      const Text(
                        "Jeton paketinizi seçerek bonus kazanın ve\nyeni bölümlerin kilidini açın!",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // "Alacağınız Bonuslar" kutusu
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Alacağınız Bonuslar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _bonusElemaniOlustur(
                                  FontAwesomeIcons.gem,
                                  "Premium\nHesap",
                                ),
                                _bonusElemaniOlustur(
                                  FontAwesomeIcons.heart,
                                  "Daha Fazla\nEşleşme",
                                ),
                                _bonusElemaniOlustur(
                                  FontAwesomeIcons.moon,
                                  "Gece\nModu",
                                ),
                                _bonusElemaniOlustur(
                                  FontAwesomeIcons.thumbsUp,
                                  "Daha Fazla\nBeğeni",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Bilgilendirici yazı
                      const Text(
                        "Kilidi açmak için bir jeton paketi seçin",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Jeton Paket Kartları (yan yana)
                      _teklifKartlariSatir(),

                      const SizedBox(height: 20),

                      // Tüm Jetonları Gör butonu
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              17,
                              0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Tüm Jetonları Gör tıklandığında
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Tüm Jetonları Gör",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Bonus Elemanı (ikon + açıklama)
  Widget _bonusElemaniOlustur(IconData ikon, String yazi) {
    return Column(
      children: [
        FaIcon(ikon, color: Colors.pinkAccent, size: 28),
        const SizedBox(height: 6),
        Text(
          yazi,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 3 adet teklif kartını yan yana gösteren satır
  Widget _teklifKartlariSatir() {
    return Row(
      children: [
        Expanded(
          child: _teklifKartiOlustur(
            eskiJeton: "200",
            yeniJeton: "330",
            indirim: "+10%",
            fiyat: "₺99,99\nBaşına haftalık",
            gradyanRenkler: [
              const Color.fromARGB(255, 82, 7, 2),
              const Color.fromARGB(255, 233, 11, 11),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _teklifKartiOlustur(
            eskiJeton: "2.375",
            yeniJeton: "3.375",
            indirim: "+70%",
            fiyat: "₺799,99\nBaşına haftalık",
            gradyanRenkler: [
              const Color.fromARGB(255, 49, 28, 186),
              const Color.fromARGB(255, 228, 5, 5),
            ],
            vurgulu: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _teklifKartiOlustur(
            eskiJeton: "1.000",
            yeniJeton: "1.350",
            indirim: "+35%",
            fiyat: "₺399,99\nBaşına haftalık",
            gradyanRenkler: [
              const Color.fromARGB(255, 82, 7, 2),
              const Color.fromARGB(255, 233, 11, 11),
            ],
          ),
        ),
      ],
    );
  }

  // Tek bir teklif kartı (eski jeton üstü çizili, altında yeni jeton)
  Widget _teklifKartiOlustur({
    required String eskiJeton,
    required String yeniJeton,
    required String indirim,
    required String fiyat,
    required List<Color> gradyanRenkler,
    bool vurgulu = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Kartın ana arka planı (gradient)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradyanRenkler,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: vurgulu ? Border.all(color: Colors.white, width: 2) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Eski jeton (üstü çizili) + Yeni jeton
              Column(
                children: [
                  Text(
                    eskiJeton,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough, // Üstü çizili
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    yeniJeton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Jeton",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                fiyat,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // % indirimi ayrı bir kapsayıcıda, üstte gösterelim
        Positioned(
          top: -15,
          left: 35,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              indirim,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
