import 'package:flutter/material.dart';
import '../models/physics_fact.dart';
import '../widgets/physics_fun_fact_widget.dart';

class PhysicsFactsScreen extends StatefulWidget {
  const PhysicsFactsScreen({super.key});

  @override
  State<PhysicsFactsScreen> createState() => _PhysicsFactsScreenState();
}

class _PhysicsFactsScreenState extends State<PhysicsFactsScreen> {
  String? selectedCategory;
  late PageController _pageController;
  int currentFactIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<PhysicsFact> getDisplayedFacts() {
    if (selectedCategory == null) {
      return PhysicsFactDatabase.facts;
    }
    return PhysicsFactDatabase.getFactsByCategory(selectedCategory!);
  }

  @override
  Widget build(BuildContext context) {
    final categories = PhysicsFactDatabase.getAllCategories().toList()..sort();
    final displayedFacts = getDisplayedFacts();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Physics Facts Library',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Category filter chips
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter by Category',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // All Facts chip
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              selected: selectedCategory == null,
                              onSelected: (_) {
                                setState(() {
                                  selectedCategory = null;
                                  currentFactIndex = 0;
                                });
                                _pageController.jumpToPage(0);
                              },
                              backgroundColor: Colors.transparent,
                              side: BorderSide(
                                color: selectedCategory == null
                                    ? const Color(0xFF3498DB)
                                    : Colors.white30,
                                width: 2,
                              ),
                              label: const Text(
                                'All Facts',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // Category chips
                          ...categories.map((category) {
                            final isSelected = selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() {
                                    selectedCategory = category;
                                    currentFactIndex = 0;
                                  });
                                  _pageController.jumpToPage(0);
                                },
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                  color: isSelected
                                      ? const Color(0xFF27AE60)
                                      : Colors.white30,
                                  width: 2,
                                ),
                                label: Text(
                                  category.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Facts counter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${currentFactIndex + 1} of ${displayedFacts.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Facts PageView
              Expanded(
                child: displayedFacts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white30,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No facts in this category',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentFactIndex = index;
                          });
                        },
                        itemCount: displayedFacts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: PhysicsFunFactWidget(
                              fact: displayedFacts[index],
                              onDismiss: () {
                                if (index < displayedFacts.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),

              // Navigation buttons
              if (displayedFacts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: currentFactIndex > 0
                            ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3498DB),
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                      Text(
                        '${currentFactIndex + 1}/${displayedFacts.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: currentFactIndex < displayedFacts.length - 1
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27AE60),
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
