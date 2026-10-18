class Situation {
  final String title;
  final String why;
  final String say;
  final String dont;
  final String doIt;
  const Situation(this.title, this.why, this.say, this.dont, this.doIt);
}

const situations = <Situation>[
  Situation(
    'Wo chidchida rahi hai',
    'Cycle ke kuch dino mein hormones badalte hain, aur chhoti baat bhi zyada chubh sakti hai.',
    'Lagta hai aaj din bhaari hai. Kuch madad karun?',
    '"Itna react kyun kar rahi ho?" ya "Phir se mood kharab?"',
    'Thodi jagah do, shaant raho, aur ek chhota kaam apne upar le lo.',
  ),
  Situation(
    'Wo ro rahi hai ya bahut emotional hai',
    'Hormones aur thakaan se emotions tez ho sakte hain. Zaroori nahi ki koi badi wajah ho.',
    'Main yahin hun. Tum jo bhi feel kar rahi ho, theek hai.',
    '"Ro mat" ya "Itni si baat par?"',
    'Paas baitho ya gale lagao. Hal batane ki jaldi mat karo, bas suno.',
  ),
  Situation(
    'Cramps ya dard hai',
    'Period mein uterus ke sikudne se dard hota hai.',
    'Garam paani ki bottle laun? Tum aaram karo, baaki mujhpar chhod do.',
    '"Ye to sabko hota hai" ya "Itna dard normal hai"',
    'Heating pad, garam chai, halka khana. Dard bahut zyada ya anokha ho to doctor ko dikhao.',
  ),
  Situation(
    'Wo chup hai ya door-door hai',
    'Thakaan ya low mood mein kuch log akele rehna chahte hain.',
    'Mujhe tumhari parwah hai. Jab baat karni ho, bata dena.',
    '"Kya hua? Bolo na!" baar-baar poochhna',
    'Paas rehkar chhota support do: paani, khana, ek pyara message.',
  ),
  Situation(
    'Wo bahut thaki hui hai',
    'Period ke dauran ya pehle energy kam ho sakti hai.',
    'Aaj koi plan nahi. Tum aaram karo.',
    '"Itni der se so rahi ho?" ya "Aalas mat karo"',
    'Ghar ke kaam baant lo, aur achhi neend ka mauka do.',
  ),
  Situation(
    'Bahas ho gayi',
    'Mood sensitive ho to bahas jaldi bhadakti hai.',
    'Maaf karna. Main sunne ko taiyar hun. Thodi der baad aaram se baat karein?',
    '"Tum hamesha aisa karti ho"',
    'Pehle shaant ho jao, phir baat karo, aur apni galti maan lo.',
  ),
];
