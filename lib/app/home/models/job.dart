class Job {
  final String name;
  final int ratePerHour;
  final String id;

  Job({
    required this.name,
    required this.ratePerHour,
    required this.id,
  });

  factory Job.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      //Rather than returning null we have to throw an error in factory methods
      throw ArgumentError('Unexpected type for data');
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
