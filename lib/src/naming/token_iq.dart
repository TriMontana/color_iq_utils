class TIQ {
  final String eng;
  final String? esp; // spanish
  final String? fra; // french
  final String? ger; // german
  final String? rus; // russian
  const TIQ(this.eng, this.esp, {this.fra, this.ger, this.rus});
  const TIQ.eng(this.eng, {this.esp, this.fra, this.ger, this.rus});
}
