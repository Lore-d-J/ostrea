import 'package:flutter/material.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/services/local_data_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<DictionaryEntry> _allEntries = [];
  List<DictionaryEntry> _filteredEntries = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDictionaryEntries();
  }

  void _loadDictionaryEntries() async {
    final entries = await LocalDataService().getDictionaryEntries();
    setState(() {
      _allEntries = entries;
      _filteredEntries = entries;
      _isLoading = false;
    });
  }

  void _filterEntries() {
    setState(() {
      _filteredEntries = _allEntries.where((entry) {
        final matchesSearch =
            entry.term.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            entry.definition.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory =
            _selectedCategory == 'All' || entry.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  List<String> get _categories {
    final categories = _allEntries.map((e) => e.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'biology':
        return Colors.green[600]!;
      case 'farming':
        return Colors.blue[600]!;
      case 'environment':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'biology':
        return 'Biology';
      case 'farming':
        return 'Farming';
      case 'environment':
        return 'Environment';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F4F8,
      ), // Match learning modules background
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Diksyonaryo'),
        elevation: 2,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search and Filter Section
                Container(
                  color: Colors.grey[50],
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          _searchQuery = value;
                          _filterEntries();
                        },
                      ),
                      SizedBox(height: 12),
                      // Category Filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((category) {
                            final isSelected = _selectedCategory == category;
                            return Container(
                              margin: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  category == 'All'
                                      ? 'Lahat'
                                      : _getCategoryLabel(category),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : _getCategoryColor(category),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: _getCategoryColor(category),
                                checkmarkColor: Colors.white,
                                backgroundColor: Colors.white,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = selected
                                        ? category
                                        : 'All';
                                    _filterEntries();
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Results Count
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        '${_filteredEntries.length} resulta${_filteredEntries.length != 1 ? 's' : ''}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Dictionary Entries List
                Expanded(
                  child: _filteredEntries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Walang nakitang resulta',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: _filteredEntries.length,
                          itemBuilder: (context, index) {
                            final entry = _filteredEntries[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(
                                          entry.category,
                                        ).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getCategoryColor(
                                            entry.category,
                                          ).withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        _getCategoryLabel(entry.category),
                                        style: TextStyle(
                                          color: _getCategoryColor(
                                            entry.category,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.term,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (entry.imageAsset != null) ...[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Image.asset(
                                              entry.imageAsset!,
                                              width: double.infinity,
                                              height: 160,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          if (_imageSource(entry) != null) ...[
                                            const SizedBox(height: 8),
                                            _buildImageSource(
                                              context,
                                              _imageSource(entry)!,
                                            ),
                                          ],
                                          const SizedBox(height: 16),
                                        ],
                                        Text(
                                          'Kahulugan:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        _buildDefinition(entry),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildDefinition(DictionaryEntry entry) {
    const textStyle = TextStyle(fontSize: 14, height: 1.5);

    if (entry.term != 'Talaba') {
      return Text(entry.definition, style: textStyle);
    }

    return Text.rich(
      TextSpan(
        style: textStyle,
        children: const [
          TextSpan(
            text: 'Karaniwang tawag: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: 'Talaba\n'),
          TextSpan(
            text: 'Siyentipikong Pangalan: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Magallana bilineata',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          TextSpan(text: '\n'),
          TextSpan(
            text: 'Dating Pangalan: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Crassostrea iredalei',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          TextSpan(text: '\n'),
          TextSpan(
            text: 'Uri: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: 'Philippine cupped/slipper-shaped oyster\n'),
          TextSpan(
            text: 'Sa Pilipinas: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                'Ito ay isang mahalagang uri ng talaba na inaalagaan at pinapalaki sa Pilipinas.\n\n',
          ),
          TextSpan(
            text: 'Maikling paliwanag:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: 'Ang '),
          TextSpan(
            text: 'Magallana bilineata',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          TextSpan(
            text:
                ' ay isang uri ng talaba na makikita at inaalagaan sa Pilipinas.',
          ),
        ],
      ),
    );
  }

  ({String label, Uri url})? _imageSource(DictionaryEntry entry) {
    switch (entry.term) {
      case 'Espongha':
        return (
          label: 'Source: Oysters Etcetera (2013)',
          url: Uri.parse(
            'https://oystersetcetera.wordpress.com/2013/04/09/holes-in-old-oyster-shells-1-sponge-borings/',
          ),
        );
      case 'Hasang':
        return (
          label: 'Source: MD Sea Grant',
          url: Uri.parse(
            'https://www.mdseagrant.org/interactive_lessons/oysters/labs/internal_anatomy_lab.html',
          ),
        );
      case 'Red Tide':
        return (
          label: 'Source: Philstar.com (2019)',
          url: Uri.parse(
            'https://www.philstar.com/nation/2019/01/20/1886478/5-pangasinan-areas-red-tide-free',
          ),
        );
      default:
        return null;
    }
  }

  Widget _buildImageSource(
    BuildContext context,
    ({String label, Uri url}) source,
  ) {
    return InkWell(
      onTap: () => launchUrl(source.url),
      child: Text(
        source.label,
        softWrap: true,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
