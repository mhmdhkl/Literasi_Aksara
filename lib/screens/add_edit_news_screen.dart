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
  late String _title, _content, _author, _imageUrl;
  bool get isEditMode => widget.news != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _title = widget.news!.title!;
      _content = widget.news!.content!;
      _author = widget.news!.author!;
      _imageUrl = widget.news!.urlToImage!;
    } else {
      _title = '';
      _content = '';
      _author = '';
      _imageUrl = '';
    }
  }

  void _saveForm() async {
    print('--- Langkah 1: Tombol Simpan Ditekan ---');

    final isFormValid = _formKey.currentState!.validate();
    print('--- Langkah 2: Apakah form valid? -> $isFormValid ---');

    if (isFormValid) {
      _formKey.currentState!.save();
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);

      final newNews = News(
        id: isEditMode ? widget.news!.id : null,
        title: _title,
        content: _content,
        author: _author,
        urlToImage: _imageUrl,
        publishedAt: DateTime.now().toIso8601String(),
      );

      print('--- Langkah 3: Mengirim data ke provider -> Judul: $_title ---');

      bool success;
      if (isEditMode) {
        success = await newsProvider.updateNews(widget.news!.id!, newNews);
      } else {
        success = await newsProvider.addNews(newNews);
      }

      print('--- Langkah 4: Provider mengembalikan nilai -> $success ---');

      if (success && mounted) {
        print('--- Langkah 5: Sukses, kembali ke halaman sebelumnya ---');
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Berita' : 'Tambah Berita'),
        backgroundColor: Colors.black,
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
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Konten'),
                validator: (value) =>
                    value!.isEmpty ? 'Konten tidak boleh kosong' : null,
                onSaved: (value) => _content = value!,
              ),
              TextFormField(
                initialValue: _author,
                decoration: InputDecoration(labelText: 'Penulis'),
                validator: (value) =>
                    value!.isEmpty ? 'Penulis tidak boleh kosong' : null,
                onSaved: (value) => _author = value!,
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'URL Gambar'),
                validator: (value) =>
                    value!.isEmpty ? 'URL Gambar tidak boleh kosong' : null,
                onSaved: (value) => _imageUrl = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
