class Attempt {
  Attempt({
    required this.date,
    required this.year,
    required this.subjects,
    required this.score,
    required this.total,
  });

  final DateTime date;
  final String year;
  final List<String> subjects;
  final int score;
  final int total;

  int get percent => total == 0 ? 0 : (score * 100 / total).round();

  Map<String, dynamic> toJson() => {
    'date': date.millisecondsSinceEpoch,
    'year': year,
    'subjects': subjects,
    'score': score,
    'total': total,
  };

  factory Attempt.fromJson(Map<String, dynamic> j) => Attempt(
    date: DateTime.fromMillisecondsSinceEpoch(j['date'] as int),
    year: j['year'] as String,
    subjects: List<String>.from(j['subjects'] as List),
    score: j['score'] as int,
    total: j['total'] as int,
  );
}

class User {
  User({
    required this.username,
    required this.name,
    required this.email,
    required this.salt,
    required this.hash,
    required this.joined,
    List<Attempt>? attempts,
  }) : attempts = attempts ?? [];

  final String username;
  final String name;
  final String email;
  final String salt;
  final String hash;
  final DateTime joined;
  final List<Attempt> attempts;

  int get highScore =>
      attempts.fold(0, (m, a) => a.percent > m ? a.percent : m);

  int bestForYear(String year) => attempts
      .where((a) => a.year == year)
      .fold(0, (m, a) => a.percent > m ? a.percent : m);

  int get average => attempts.isEmpty
      ? 0
      : (attempts.fold<int>(0, (s, a) => s + a.percent) / attempts.length)
            .round();

  Map<String, dynamic> toJson() => {
    'username': username,
    'name': name,
    'email': email,
    'salt': salt,
    'hash': hash,
    'joined': joined.millisecondsSinceEpoch,
    'attempts': attempts.map((a) => a.toJson()).toList(),
  };

  factory User.fromJson(Map<String, dynamic> j) => User(
    username: j['username'] as String,
    name: j['name'] as String,
    email: j['email'] as String,
    salt: j['salt'] as String,
    hash: j['hash'] as String,
    joined: DateTime.fromMillisecondsSinceEpoch(j['joined'] as int),
    attempts: (j['attempts'] as List)
        .map((a) => Attempt.fromJson(a as Map<String, dynamic>))
        .toList(),
  );
}
