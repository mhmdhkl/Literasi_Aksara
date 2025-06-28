import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Aksara_Literasi/models/news_model.dart';
import 'package:Aksara_Literasi/providers/news_provider.dart';

class AddEditNewsScreen extends StatefulWidget {
  final News? news;

  const AddEditNewsScreen({Key? key, this.news}) : super(key: key);

  @override
  _AddEditNewsScreenState createState() => _AddEditNewsScreenState();
}

class _AddEditNewsScreenState extends State<AddEditNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title, _content, _imageUrl, _summary;

  String? _category;
  bool get isEditMode => widget.news != null;

  // MODIFIKASI: Menggunakan Map untuk memisahkan nilai API (key) dan nilai tampilan (value)
  final Map<String, String> _categoryOptions = {
    'Business': 'Bisnis',
    'Technology': 'Teknologi',
    'Health': 'Kesehatan',
    'Sports': 'Olahraga',
    'General': 'Umum'
  };

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _title = widget.news!.title ?? '';
      _content = widget.news!.content ?? '';
      _imageUrl = widget.news!.featuredImageUrl ?? '';
      _summary = widget.news!.summary ?? '';
      _category = widget.news!.category;
    } else {
      _title = '';
      _content = '';
      _imageUrl = '';
      _summary = '';
      _category = null;
    }
  }

  void _saveForm() async {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) {
      return;
    }
    _formKey.currentState!.save();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    final newNews = News(
      id: isEditMode ? widget.news!.id : null,
      title: _title,
      content: _content,
      summary: _summary,
      featuredImageUrl: _imageUrl,
      category: _category,
    );

    bool success;
    if (isEditMode) {
      success = await newsProvider.updateNews(widget.news!.id!, newNews);
    } else {
      success = await newsProvider.addNews(newNews);
    }

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Berita' : 'Tambah Berita',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value!.isEmpty ? 'Judul tidak boleh kosong' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _summary,
                decoration: InputDecoration(labelText: 'Ringkasan (Summary)'),
                onSaved: (value) => _summary = value!,
              ),

              // MODIFIKASI: Dropdown sekarang dibuat dari Map
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: 'Kategori'),
                hint: Text('Pilih Kategori'),
                items: _categoryOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key, // Nilai internal (English)
                    child:
                        Text(entry.value), // Teks yang ditampilkan (Indonesia)
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Kategori harus dipilih' : null,
                onSaved: (value) => _category = value,
              ),

              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Konten'),
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Konten tidak boleh kosong';
                  }
                  if (value.length < 10) {
                    return 'Konten harus memiliki minimal 10 karakter';
                  }
                  return null;
                },
                onSaved: (value) => _content = value!,
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'URL Gambar Unggulan'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'URL Gambar tidak boleh kosong';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.isAbsolute) {
                    return 'Format URL tidak valid (contoh: https://...)';
                  }
                  return null;
                },
                onSaved: (value) => _imageUrl = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Simpan', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
