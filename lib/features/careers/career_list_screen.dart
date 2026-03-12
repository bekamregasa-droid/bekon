import 'package:flutter/material.dart';

class CareerListScreen extends StatefulWidget {
  const CareerListScreen({super.key});

  @override
  State<CareerListScreen> createState() => _CareerListScreenState();
}

class _CareerListScreenState extends State<CareerListScreen> with AutomaticKeepAliveClientMixin {
  final List<Map<String, dynamic>> _careers = [
    {
      'id': 'software-engineer',
      'title': 'Software Engineer',
      'category': 'Technology',
      'match': 92,
      'salary': '\$80k - \$150k',
      'description': 'Design and develop software applications',
      'icon': Icons.code,
      'color': 0xFF2563EB,
    },
    {
      'id': 'data-scientist',
      'title': 'Data Scientist',
      'category': 'Technology',
      'match': 87,
      'salary': '\$90k - \$160k',
      'description': 'Analyze complex data to help organizations make decisions',
      'icon': Icons.analytics,
      'color': 0xFF7C3AED,
    },
    {
      'id': 'ux-designer',
      'title': 'UX Designer',
      'category': 'Creative',
      'match': 84,
      'salary': '\$70k - \$120k',
      'description': 'Create user-friendly digital experiences',
      'icon': Icons.design_services,
      'color': 0xFFDC2626,
    },
    {
      'id': 'product-manager',
      'title': 'Product Manager',
      'category': 'Business',
      'match': 79,
      'salary': '\$90k - \$160k',
      'description': 'Lead product development and strategy',
      'icon': Icons.business_center,
      'color': 0xFFEA580C,
    },
    {
      'id': 'doctor',
      'title': 'Physician',
      'category': 'Healthcare',
      'match': 76,
      'salary': '\$150k - \$300k',
      'description': 'Diagnose and treat medical conditions',
      'icon': Icons.local_hospital,
      'color': 0xFF059669,
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'Explore Careers',
          style: TextStyle(
            color: Color(0xFF2C3A2A),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF2C3A2A)),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search careers...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            
            // Category chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCategoryChip('All', true),
                  _buildCategoryChip('Technology', false),
                  _buildCategoryChip('Healthcare', false),
                  _buildCategoryChip('Creative', false),
                  _buildCategoryChip('Business', false),
                  _buildCategoryChip('Engineering', false),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Results count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '${_filteredCareers.length} careers found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Career list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredCareers.length,
                itemBuilder: (context, index) {
                  final career = _filteredCareers[index];
                  return _buildCareerListItem(career);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredCareers {
    return _careers.where((career) {
      final matchesSearch = _searchQuery.isEmpty ||
          career['title'].toLowerCase().contains(_searchQuery) ||
          career['description'].toLowerCase().contains(_searchQuery);
      
      final matchesCategory = _selectedCategory == 'All' ||
          career['category'] == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF2C3A2A),
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF2C3A2A),
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isSelected ? const Color(0xFF2C3A2A) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildCareerListItem(Map<String, dynamic> career) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(career['color']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              career['icon'],
              color: Color(career['color']),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        career['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3A2A),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3A2A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${career['match']}% match',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3A2A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  career['category'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  career['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      career['salary'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Navigate to career detail
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFF2C3A2A),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Careers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterSection('Industry', ['Technology', 'Healthcare', 'Creative', 'Business']),
              const SizedBox(height: 20),
              _buildFilterSection('Match Score', ['90%+', '80%+', '70%+', '60%+']),
              const SizedBox(height: 20),
              _buildFilterSection('Salary Range', ['\$0-\$50k', '\$50k-\$100k', '\$100k+']),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3A2A),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: false,
              onSelected: (selected) {},
              backgroundColor: Colors.grey.shade100,
              selectedColor: const Color(0xFF2C3A2A).withOpacity(0.2),
              checkmarkColor: const Color(0xFF2C3A2A),
              labelStyle: const TextStyle(color: Color(0xFF2C3A2A)),
            );
          }).toList(),
        ),
      ],
    );
  }
}