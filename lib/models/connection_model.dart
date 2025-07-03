class Connection {
  final String? id;
  final String name;
  final String? mutualConnections;
  final bool isRequest;

  Connection({
    this.id,
    required this.name,
    this.mutualConnections,
    this.isRequest = false,
  });

  String get initials => name.split(' ').map((n) => n[0]).take(2).join();
}