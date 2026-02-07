import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class DashboardPageWidget extends StatefulWidget {
  const DashboardPageWidget({super.key});

  @override
  State<DashboardPageWidget> createState() => _DashboardPageWidgetState();
}

class _DashboardPageWidgetState extends State<DashboardPageWidget> {
  int _selectedIndex = 0;
  bool _hasData = false; // State to simulate empty vs populated

  void _onDestinationSelected(int index) {
    if (index == 1) {
      // Simulation
      _showSimulationDialog();
    } else if (index == 2) {
      // Exit
      _handleExit();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showSimulationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Run Simulation'),
        content: const Text('Simulation running...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _hasData = true; // Simulate data load after simulation
              });
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleExit() {
    // Placeholder for exit logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exiting...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: _onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.play_arrow),
          label: 'Run Simulation',
        ),
        NavigationDestination(
          icon: Icon(Icons.exit_to_app),
          label: 'Exit',
        ),
      ],
      body: (_) => _buildBody(),
      smallBody: (_) => _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return Center(
        child: _hasData
            ? const Text('Revenue Chart')
            : const Text('Empty State'),
      );
    }
    return const SizedBox.shrink();
  }
}
