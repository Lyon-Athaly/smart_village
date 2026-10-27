import 'package:flutter/material.dart';

import 'ui_illustrations.dart';

void main() => runApp(const SmartVillageApp());

const blue = Color(0xFF0879ED);
const navy = Color(0xFF173154);
const muted = Color(0xFF748397);
const green = Color(0xFF22975A);
const purple = Color(0xFF7851BE);
const hospital = 'Rumah Sakit';
const healthCenter = 'Puskesmas';
const clinic = 'Klinik';

class SmartVillageApp extends StatelessWidget {
  const SmartVillageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Village',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        primaryColor: blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(primary: blue, secondary: green),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: navy, fontSize: 18, fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          hintStyle: const TextStyle(color: muted, fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5EBF1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: blue),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Seluruh identitas, jarak, alamat, dan ulasan berikut adalah data contoh.
// mapPoint adalah posisi relatif pada ilustrasi (0-1), bukan koordinat GPS.
class Facility {
  final String name;
  final String category;
  final String type;
  final double distance;
  final String address;
  final List<String> services;
  final Offset mapPoint;

  const Facility({
    required this.name,
    required this.category,
    required this.type,
    required this.distance,
    required this.address,
    required this.services,
    required this.mapPoint,
  });

  Color get color => category == hospital ? blue : category == clinic ? purple : green;
  String get distanceLabel => '${distance.toStringAsFixed(1).replaceAll('.', ',')} km';

  bool matches(String query) {
    final text = '$name $category $type $address ${services.join(' ')}';
    return text.toLowerCase().contains(query.trim().toLowerCase());
  }
}

const facilities = <Facility>[
  Facility(
    name: 'RSUD Kabupaten X', category: hospital, type: 'RS Umum', distance: 1.2,
    address: 'Jl. Raya Kabupaten X No. 10, Desa Sukamaju',
    services: ['IGD', 'Poliklinik', 'Rawat Inap', 'Laboratorium', 'Radiologi'],
    mapPoint: Offset(0.18, 0.08),
  ),
  Facility(
    name: 'RS Harapan Bunda', category: hospital, type: 'RS Umum', distance: 4.8,
    address: 'Jl. Melati No. 12, Kabupaten X',
    services: ['IGD', 'Poliklinik', 'Laboratorium'],
    mapPoint: Offset(0.04, 0.75),
  ),
  Facility(
    name: 'RS Sumber Sehat', category: hospital, type: 'RS Khusus', distance: 7.6,
    address: 'Jl. Sehat No. 8, Kabupaten X',
    services: ['Mata', 'Bedah', 'Rawat Inap'],
    mapPoint: Offset(0.85, 0.15),
  ),
  Facility(
    name: 'RS Mitra Keluarga', category: hospital, type: 'RS Umum', distance: 10.2,
    address: 'Jl. Merdeka No. 15, Kabupaten X',
    services: ['IGD', 'Poliklinik', 'Laboratorium'],
    mapPoint: Offset(0.88, 0.81),
  ),
  Facility(
    name: 'Puskesmas Sukamaju', category: healthCenter, type: healthCenter, distance: 0.8,
    address: 'Jl. Desa Sukamaju No. 3, Kabupaten X',
    services: ['Poli Umum', 'KIA', 'Imunisasi'],
    mapPoint: Offset(0.02, 0.34),
  ),
  Facility(
    name: 'Klinik Sehat Mandiri', category: clinic, type: clinic, distance: 1.9,
    address: 'Jl. Anggrek No. 5, Kabupaten X',
    services: ['Poli Umum', 'Poli Gigi', 'Farmasi'],
    mapPoint: Offset(0.91, 0.49),
  ),
];

void openScreen(BuildContext context, Widget page) {
  FocusManager.instance.primaryFocus?.unfocus();
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

IconData categoryIcon(String category) {
  if (category == healthCenter) return Icons.home_work_rounded;
  if (category == clinic) return Icons.medical_services_rounded;
  return Icons.local_hospital_rounded;
}

// 1. BERANDA
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void searchFacilities() {
    openScreen(context, FacilityListScreen(initialQuery: search.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            Container(
              height: 290,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFFC5EEFF), Color(0xFFF0FBFF)],
                ),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 0, right: 0, bottom: 0, height: 145,
                    child: CustomPaint(painter: VillagePainter()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(11),
                              decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add_location_alt_rounded,
                                  color: blue, size: 35),
                            ),
                            const SizedBox(width: 12),
                            const Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Smart Village', style: TextStyle(
                                    fontSize: 25, color: navy, fontWeight: FontWeight.w800,
                                  )),
                                  SizedBox(height: 5),
                                  Text('Sehat Bersama, Desa Maju',
                                      style: TextStyle(fontSize: 11, color: navy)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Cari lokasi Klinik, Puskesmas dan\nRumah Sakit terdekat di Kabupaten X',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: navy, fontSize: 12, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: SearchBox(
                controller: search,
                hint: 'Cari nama fasilitas kesehatan...',
                onSubmitted: (_) => searchFacilities(),
                suffix: IconButton(
                  tooltip: 'Cari fasilitas', onPressed: searchFacilities,
                  icon: const Icon(Icons.arrow_forward_rounded, color: blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 112,
                ),
                children: [
                  CategoryTile(label: hospital, icon: Icons.local_hospital_rounded,
                    color: blue, background: const Color(0xFFE2F3FF),
                    onTap: () => openScreen(context, const FacilityListScreen(category: hospital))),
                  CategoryTile(label: healthCenter, icon: Icons.home_work_rounded,
                    color: green, background: const Color(0xFFDFF7E7),
                    onTap: () => openScreen(context, const FacilityListScreen(category: healthCenter))),
                  CategoryTile(label: clinic, icon: Icons.medical_services_rounded,
                    color: purple, background: const Color(0xFFEEE7FC),
                    onTap: () => openScreen(context, const FacilityListScreen(category: clinic))),
                  CategoryTile(label: 'Peta Lokasi', icon: Icons.location_on_rounded,
                    color: const Color(0xFFB98A21), background: const Color(0xFFFFF4D5),
                    onTap: () => openScreen(context, const MapScreen())),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Desa Sukamaju · Kabupaten X · Data contoh',
                textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 11)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: blue,
        unselectedItemColor: muted,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 6,
        onTap: (index) {
          if (index == 1) openScreen(context, const MapScreen());
          if (index == 2) showInfoSheet(context, 'Profil Desa',
              'Desa Sukamaju\nKabupaten X\n\nSmart Village\nSehat Bersama, Desa Maju\n\nIdentitas desa merupakan data contoh.');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Peta'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}

// 2. DAFTAR FASILITAS: pencarian dan filter hanya memakai data di memori.
class FacilityListScreen extends StatefulWidget {
  final String? category;
  final String initialQuery;
  const FacilityListScreen({super.key, this.category, this.initialQuery = ''});

  @override
  State<FacilityListScreen> createState() => _FacilityListScreenState();
}

class _FacilityListScreenState extends State<FacilityListScreen> {
  late final TextEditingController search;
  String filter = 'Semua';

  @override
  void initState() {
    super.initState();
    search = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = widget.category == hospital
        ? ['Semua', 'RS Umum', 'RS Khusus']
        : widget.category == null ? ['Semua', hospital, healthCenter, clinic] : <String>[];
    final visible = facilities.where((item) {
      return (widget.category == null || item.category == widget.category) &&
          (filter == 'Semua' || item.type == filter || item.category == filter) &&
          item.matches(search.text);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.category ?? 'Fasilitas Kesehatan')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: SearchBox(
                controller: search,
                hint: 'Cari ${widget.category?.toLowerCase() ?? 'fasilitas'} di Kabupaten X...',
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (filters.isNotEmpty)
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) => ChoiceChip(
                    label: Text(filters[index]),
                    selected: filter == filters[index],
                    selectedColor: blue,
                    backgroundColor: const Color(0xFFF3F7FA),
                    labelStyle: TextStyle(fontSize: 11,
                        color: filter == filters[index] ? Colors.white : muted),
                    onSelected: (_) => setState(() => filter = filters[index]),
                  ),
                ),
              ),
            Expanded(
              child: visible.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 48, color: muted),
                            const SizedBox(height: 12),
                            const Text('Fasilitas tidak ditemukan.', style: TextStyle(color: navy)),
                            TextButton(
                              onPressed: () => setState(() { search.clear(); filter = 'Semua'; }),
                              child: const Text('Hapus pencarian dan filter'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const Divider(height: 24, color: Color(0xFFEDF0F4)),
                      itemBuilder: (_, index) => FacilityRow(facility: visible[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. PETA ILUSTRASI: pin dan lingkaran tidak menggunakan layanan lokasi.
class MapScreen extends StatefulWidget {
  final Facility? initialFacility;
  const MapScreen({super.key, this.initialFacility});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final search = TextEditingController();
  final visibleCategories = <String>{hospital, healthCenter, clinic};
  bool showGeofence = true;
  Facility? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialFacility;
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void toggleCategory(String category) {
    setState(() {
      if (!visibleCategories.remove(category)) visibleCategories.add(category);
      if (selected != null && !visibleCategories.contains(selected!.category)) selected = null;
    });
  }

  void resetMap() {
    setState(() {
      search.clear();
      visibleCategories.addAll([hospital, healthCenter, clinic]);
      selected = null;
      showGeofence = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pins = facilities.where((item) =>
        visibleCategories.contains(item.category) && item.matches(search.text)).toList();
    final current = selected;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Lokasi'),
        actions: [IconButton(onPressed: resetMap, tooltip: 'Tampilkan semua lokasi contoh',
            icon: const Icon(Icons.my_location_rounded, size: 22))],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
              child: SearchBox(controller: search, hint: 'Cari lokasi...',
                  onChanged: (_) => setState(() => selected = null)),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) {
                  return ClipRect(
                    child: Stack(
                      children: [
                        const Positioned.fill(child: CustomPaint(painter: MapPainter())),
                        Align(
                          alignment: const Alignment(0.1, 0.1),
                          child: Semantics(
                            label: 'Posisi pengguna contoh. Area geofencing berupa ilustrasi.',
                            child: Container(
                              width: 130, height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: showGeofence ? blue.withAlpha(25) : Colors.transparent,
                                border: showGeofence ? Border.all(color: blue.withAlpha(55)) : null,
                              ),
                              child: Center(
                                child: Container(
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(
                                    color: blue, shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [BoxShadow(color: blue.withAlpha(60), blurRadius: 12)],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        for (final item in pins)
                          Positioned(
                            left: (box.maxWidth - 116).clamp(0.0, double.infinity).toDouble() * item.mapPoint.dx,
                            top: 30 + (box.maxHeight - 140).clamp(0.0, double.infinity).toDouble() * item.mapPoint.dy,
                            width: 116,
                            child: MapPin(
                              facility: item,
                              selected: current == item,
                              onTap: () => setState(() => selected = item),
                            ),
                          ),
                        const Positioned(
                          left: 12, top: 10,
                          child: Pill('Peta ilustrasi · Data contoh', color: navy, background: Colors.white),
                        ),
                        if (pins.isEmpty)
                          const Center(child: Card(child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Tidak ada lokasi sesuai filter.', style: TextStyle(color: navy)),
                          ))),
                        if (current != null)
                          Positioned(
                            left: 14, right: 14, bottom: 14,
                            child: Material(
                              color: Colors.white,
                              elevation: 4,
                              borderRadius: BorderRadius.circular(16),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => openScreen(context, DetailScreen(facility: current)),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(children: [
                                    Icon(categoryIcon(current.category), color: current.color, size: 30),
                                    const SizedBox(width: 12),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(current.name, style: const TextStyle(color: navy, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 4),
                                        Text('${current.distanceLabel} · Lihat detail',
                                            style: const TextStyle(color: muted, fontSize: 12)),
                                      ],
                                    )),
                                    const Icon(Icons.chevron_right_rounded, color: blue),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE8EDF3))),
              ),
              child: Row(children: [
                LegendButton(label: hospital, icon: Icons.local_hospital_rounded, color: const Color(0xFFF25362),
                    selected: visibleCategories.contains(hospital), onTap: () => toggleCategory(hospital)),
                LegendButton(label: healthCenter, icon: Icons.home_work_rounded, color: green,
                    selected: visibleCategories.contains(healthCenter), onTap: () => toggleCategory(healthCenter)),
                LegendButton(label: clinic, icon: Icons.medical_services_rounded, color: purple,
                    selected: visibleCategories.contains(clinic), onTap: () => toggleCategory(clinic)),
                LegendButton(label: 'Area Geofencing', icon: Icons.radio_button_checked, color: blue,
                    selected: showGeofence, onTap: () => setState(() => showGeofence = !showGeofence)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. DETAIL FASILITAS
class DetailScreen extends StatelessWidget {
  final Facility facility;
  const DetailScreen({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Fasilitas'),
        actions: [IconButton(
          tooltip: 'Informasi untuk dibagikan',
          icon: const Icon(Icons.share_outlined, size: 21),
          onPressed: () => showInfoSheet(context, 'Bagikan Fasilitas',
              '${facility.name}\n${facility.address}\n\nPelayanan: ${facility.services.join(', ')}.\n\nData contoh untuk demonstrasi tampilan.'),
        )],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          SizedBox(height: 210,
              child: FacilityArtwork(color: facility.color, label: facility.name)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(facility.name, style: const TextStyle(
                    fontSize: 23, fontWeight: FontWeight.w800, color: navy)),
                const SizedBox(height: 9),
                Pill(facility.type, color: facility.category == hospital ? green : facility.color),
                const SizedBox(height: 12),
                const Row(children: [
                  Icon(Icons.star_rounded, color: Color(0xFFFFBC29), size: 20),
                  SizedBox(width: 5),
                  Flexible(child: Text('4,5 (120 ulasan contoh)', style: TextStyle(fontSize: 12, color: muted))),
                ]),
                const Divider(height: 32, color: Color(0xFFEDF0F4)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: InfoBlock(icon: Icons.location_on_rounded,
                        title: facility.distanceLabel, text: facility.address)),
                    const SizedBox(width: 12),
                    const Expanded(child: InfoBlock(icon: Icons.phone_rounded,
                        title: '(021) 0000 0000', text: 'Telepon contoh')),
                  ],
                ),
                const Divider(height: 32, color: Color(0xFFEDF0F4)),
                const Text('Jenis Pelayanan', style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: navy)),
                const SizedBox(height: 14),
                Wrap(spacing: 8, runSpacing: 10,
                    children: facility.services.map((service) => Pill(service)).toList()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
          child: ElevatedButton.icon(
            onPressed: () => openScreen(context, MapScreen(initialFacility: facility)),
            icon: const Icon(Icons.near_me_rounded, size: 19),
            label: const Text('Lihat di Peta'),
          ),
        ),
      ),
    );
  }
}

// WIDGET BERSAMA
class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  const SearchBox({super.key, required this.controller, required this.hint,
    this.onChanged, this.onSubmitted, this.suffix});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    textInputAction: TextInputAction.search,
    style: const TextStyle(color: navy, fontSize: 13),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search_rounded, color: muted, size: 21),
      suffixIcon: suffix,
    ),
  );
}

class CategoryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  const CategoryTile({super.key, required this.label, required this.icon,
    required this.color, required this.background, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: background,
    borderRadius: BorderRadius.circular(16),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 38),
          const SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center,
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ),
    ),
  );
}

class Pill extends StatelessWidget {
  final String text;
  final Color color;
  final Color? background;
  const Pill(this.text, {super.key, this.color = blue, this.background});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: background ?? color.withAlpha(20), borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
  );
}

class FacilityRow extends StatelessWidget {
  final Facility facility;
  const FacilityRow({super.key, required this.facility});

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () => openScreen(context, DetailScreen(facility: facility)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(width: 80, height: 88,
              child: FacilityArtwork(color: facility.color)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(facility.name, style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.location_on_rounded, color: muted, size: 14),
            const SizedBox(width: 4),
            Text(facility.distanceLabel, style: const TextStyle(color: muted, fontSize: 11)),
          ]),
          const SizedBox(height: 6),
          Pill(facility.type, color: facility.type == 'RS Umum' ? green : facility.color),
          const SizedBox(height: 7),
          Wrap(spacing: 4, runSpacing: 4, children: facility.services.take(3).map((s) => Pill(s)).toList()),
        ])),
        const Padding(padding: EdgeInsets.only(top: 32, left: 4),
            child: Icon(Icons.chevron_right_rounded, color: muted, size: 20)),
      ]),
    ),
  );
}

class FacilityArtwork extends StatelessWidget {
  final Color color;
  final String? label;
  const FacilityArtwork({super.key, required this.color, this.label});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Ilustrasi gedung fasilitas kesehatan',
    child: CustomPaint(painter: HospitalPainter(accent: color, label: label)),
  );
}

class MapPin extends StatelessWidget {
  final Facility facility;
  final bool selected;
  final VoidCallback onTap;
  const MapPin({super.key, required this.facility, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = facility.category == hospital ? const Color(0xFFF25362) : facility.color;
    return Semantics(
      button: true, selected: selected, label: facility.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color, shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: selected ? 4 : 2),
                boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 7)],
              ),
              child: Icon(categoryIcon(facility.category), size: 17, color: Colors.white),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withAlpha(235), borderRadius: BorderRadius.circular(5)),
              child: Text(facility.name, textAlign: TextAlign.center,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9, color: navy, fontWeight: selected ? FontWeight.w800 : FontWeight.w600)),
            ),
          ]),
        ),
      ),
    );
  }
}

class LegendButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const LegendButton({super.key, required this.label, required this.icon,
    required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      button: true, toggled: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: selected ? color : const Color(0xFFC1CAD4), size: 25),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: selected ? navy : muted)),
          ]),
        ),
      ),
    ),
  );
}

class InfoBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const InfoBlock({super.key, required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, color: blue, size: 19),
    const SizedBox(width: 7),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(text, style: const TextStyle(color: muted, fontSize: 11, height: 1.5)),
    ])),
  ]);
}

void showInfoSheet(BuildContext context, String title, String content) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w700, fontSize: 20)),
          const SizedBox(height: 18),
          SelectableText(content, style: const TextStyle(color: muted, height: 1.6)),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity,
              child: ElevatedButton(onPressed: () => Navigator.of(sheetContext).pop(), child: const Text('Tutup'))),
        ]),
      ),
    ),
  );
}
