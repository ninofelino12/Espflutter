import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const FavoriteSitesApp());
}

class FavoriteSitesApp extends StatelessWidget {
  const FavoriteSitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF6750A4);

    return MaterialApp(
      title: 'Favorit Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF7F5FA),
      ),
      home: const FavoriteSitesPage(),
    );
  }
}

class FavoriteSite {
  const FavoriteSite({required this.name, required this.url});

  final String name;
  final String url;

  Map<String, String> toJson() => {'name': name, 'url': url};

  factory FavoriteSite.fromJson(Map<String, dynamic> json) {
    return FavoriteSite(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}

const _defaultSites = [
  FavoriteSite(
    name: 'ninofelino12.github.io',
    url: 'https://ninofelino12.github.io',
  ),
  FavoriteSite(
    name: 'ninofelino.github.io',
    url: 'https://ninofelino.github.io',
  ),
  FavoriteSite(name: 'Docker Hub', url: 'https://hub.docker.com'),
];

class FavoriteSitesPage extends StatefulWidget {
  const FavoriteSitesPage({super.key});

  @override
  State<FavoriteSitesPage> createState() => _FavoriteSitesPageState();
}

class _FavoriteSitesPageState extends State<FavoriteSitesPage> {
  static const _storageKey = 'favorite_sites';

  List<FavoriteSite> _sites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedSites = preferences.getString(_storageKey);
      final sites = savedSites == null
          ? _defaultSites
          : (jsonDecode(savedSites) as List<dynamic>)
              .map((item) =>
                  FavoriteSite.fromJson(item as Map<String, dynamic>))
              .toList();

      if (!mounted) return;
      setState(() {
        _sites = sites;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('Favorit tidak dapat dimuat: $error');
    }
  }

  Future<void> _saveSites(List<FavoriteSite> sites) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(
        _storageKey,
        jsonEncode(sites.map((site) => site.toJson()).toList()),
      );
      if (!saved) throw StateError('Penyimpanan lokal gagal.');

      if (!mounted) return;
      setState(() => _sites = sites);
    } catch (error) {
      _showMessage('Perubahan tidak dapat disimpan: $error');
    }
  }

  Future<void> _addSite() async {
    final site = await _showSiteDialog();
    if (site == null) return;
    await _saveSites([..._sites, site]);
  }

  Future<void> _editSite(int index) async {
    final site = await _showSiteDialog(site: _sites[index]);
    if (site == null) return;

    final updatedSites = [..._sites];
    updatedSites[index] = site;
    await _saveSites(updatedSites);
  }

  Future<void> _deleteSite(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus favorit?'),
        content: Text('“${_sites[index].name}” akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;
    final updatedSites = [..._sites]..removeAt(index);
    await _saveSites(updatedSites);
  }

  Future<FavoriteSite?> _showSiteDialog({FavoriteSite? site}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: site?.name ?? '');
    final urlController = TextEditingController(text: site?.url ?? '');

    final result = await showDialog<FavoriteSite>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(site == null ? 'Tambah favorit' : 'Edit favorit'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nama situs',
                  hintText: 'Contoh: Portofolio',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama situs wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://contoh.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  final url = _normalizeUrl(value ?? '');
                  return url == null ? 'Masukkan URL yang valid' : null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(
                context,
                FavoriteSite(
                  name: nameController.text.trim(),
                  url: _normalizeUrl(urlController.text)!,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    nameController.dispose();
    urlController.dispose();
    return result;
  }

  String? _normalizeUrl(String value) {
    final input = value.trim();
    if (input.isEmpty || input.contains(RegExp(r'\s'))) return null;

    final candidate = input.contains('://') ? input : 'https://$input';
    final uri = Uri.tryParse(candidate);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        !const ['http', 'https'].contains(uri.scheme.toLowerCase())) {
      return null;
    }
    return uri.toString();
  }

  Future<void> _openSite(FavoriteSite site) async {
    final uri = Uri.parse(site.url);
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) _showMessage('Situs tidak dapat dibuka.');
    } catch (error) {
      _showMessage('Situs tidak dapat dibuka: $error');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorit Web',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSite,
        icon: const Icon(Icons.add),
        label: const Text('Tambah favorit'),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Situs favoritmu',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Simpan dan buka situs web pilihanmu dengan mudah.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_rounded,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_sites.length} situs tersimpan',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_sites.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyState(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSiteCard(index),
                childCount: _sites.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSiteCard(int index) {
    final site = _sites[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openSite(site),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      site.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      site.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit favorit',
                onPressed: () => _editSite(index),
                icon: const Icon(Icons.edit_outlined),
              ),
              PopupMenuButton<String>(
                tooltip: 'Pilihan favorit',
                onSelected: (value) {
                  if (value == 'delete') _deleteSite(index);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.delete_outline),
                      title: Text('Hapus'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_add_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada favorit',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan situs favoritmu dengan tombol di bawah.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
