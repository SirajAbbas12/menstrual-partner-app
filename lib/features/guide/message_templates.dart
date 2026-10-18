class Template {
  final String tag;
  final String text;
  const Template(this.tag, this.text);
}

const templates = <Template>[
  Template('Subah',
      'Good morning. Aaj tumhare liye chai ya coffee bana dun? Aaram se uthna.'),
  Template('Dard ya cramps',
      'Dard kaisa hai aaj? Garam paani ki bottle laun? Tum bas aaram karo.'),
  Template('Mood low hai',
      'Aaj kuch bhaari lag raha hai? Baat karni ho to main yahin hun. Na karni ho to bhi theek hai.'),
  Template('Thaki hui hai',
      'Aaj ka kaam mujhpar chhod do. Tum bas aaram karo.'),
  Template('Bahas ke baad',
      'Maaf karna agar maine tumhe hurt kiya. Thodi der baad aaram se baat karein?'),
  Template('Tareef',
      'Tum jitna karti ho, wo sab mujhe dikhta hai. Thank you.'),
  Template('Cravings',
      'Kuch meetha ya teekha khana hai? Bata do, kya mangwa dun?'),
  Template('Raat ko',
      'Aaj tumne bahut kiya. Ab aaram karo. Good night, main tumhare saath hun.'),
];
