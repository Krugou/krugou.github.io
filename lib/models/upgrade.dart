enum UpgradeType {
  farm,
  house,
  school,
  hospital,
  port,
  workshop,
}

class Upgrade {
  final UpgradeType type;
  final String name;
  final String description;
  final String icon;
  final double baseCost;
  final double costMultiplier;
  
  const Upgrade({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.baseCost,
    this.costMultiplier = 1.15,
  });
  
  // Calculate cost based on current count
  double getCost(int currentCount) {
    return baseCost * (costMultiplier * currentCount);
  }
  
  // Get benefit description
  String getBenefit() {
    switch (type) {
      case UpgradeType.farm:
        return '+2 food/sec';
      case UpgradeType.house:
        return '+1.5 housing/sec';
      case UpgradeType.school:
        return '+5 happiness';
      case UpgradeType.hospital:
        return '-10% resource consumption';
      case UpgradeType.port:
        return '+20% immigration rate';
      case UpgradeType.workshop:
        return '+50% manual food gathering';
    }
  }
  
  static const List<Upgrade> allUpgrades = [
    Upgrade(
      type: UpgradeType.farm,
      name: 'Community Farm',
      description: 'Grows food to feed the growing population',
      icon: '🌾',
      baseCost: 50.0,
    ),
    Upgrade(
      type: UpgradeType.house,
      name: 'Housing Complex',
      description: 'Provides shelter for immigrant families',
      icon: '🏠',
      baseCost: 100.0,
    ),
    Upgrade(
      type: UpgradeType.school,
      name: 'Community School',
      description: 'Educates children and improves community happiness',
      icon: '🏫',
      baseCost: 200.0,
    ),
    Upgrade(
      type: UpgradeType.hospital,
      name: 'Health Clinic',
      description: 'Provides healthcare, reducing resource consumption',
      icon: '🏥',
      baseCost: 500.0,
    ),
    Upgrade(
      type: UpgradeType.port,
      name: 'Welcome Center',
      description: 'Helps more immigrants find your community',
      icon: '🏛️',
      baseCost: 1000.0,
    ),
    Upgrade(
      type: UpgradeType.workshop,
      name: 'Community Workshop',
      description: 'Improves efficiency of manual labor',
      icon: '🔧',
      baseCost: 300.0,
    ),
  ];
}