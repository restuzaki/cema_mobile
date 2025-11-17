enum RiskType { berisiko, darurat, normal }

class Project {
  final String id;
  final String name;
  final String phase;
  final double cpi;
  final double spi;
  final RiskType riskType;

  Project({
    required this.id,
    required this.name,
    required this.phase,
    required this.cpi,
    required this.spi,
    required this.riskType,
  });
}
