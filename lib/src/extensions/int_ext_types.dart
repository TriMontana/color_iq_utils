import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/foundation/constants.dart';

// Extension type for 8-bit unsigned int that can invoke all members of 'int',
extension type UI8._(int value) implements int {
  /// Constant constructor.
  const UI8(final int val, {final String? msg})
      : assert(
          val >= 0 && val <= 255,
          '$errorMsg0to255-"$val"--${msg ?? //
              'Error: 0 to 255'}',
        ),
        value = val;

  UI8 addWithClam(final UI8 other) => UI8((value + other.value).clamp0to255);

  bool get isEven => true;
  // Method:
  bool isValid() => !isNegative;

  // Wraps the 'int' type's '<' operator:
  bool operator <(final UI8 other) => value < other.value;
  bool operator >(final UI8 other) => value > other.value;

  static const UI8 zero = UI8(0);

  static const UI8 one = UI8(1);
  static const UI8 min = UI8(0);
  static const UI8 max = UI8(255);
  static const UI8 v0 = UI8.zero;
  static const UI8 v38 = UI8(38);
  static const UI8 v43 = UI8(43);
  static const UI8 v44 = UI8(44);
  static const UI8 v45 = UI8(45);
  static const UI8 v46 = UI8(46);
  static const UI8 v47 = UI8(47);
  static const UI8 v48 = UI8(48);
  static const UI8 v50 = UI8(50);
  static const UI8 v55 = UI8(55);
  static const UI8 v60 = UI8(60);
  static const UI8 v70 = UI8(70);
  static const UI8 v80 = UI8(80);
  static const UI8 v85 = UI8(85);
  static const UI8 v86 = UI8(86);
  static const UI8 v87 = UI8(87);
  static const UI8 v90 = UI8(90);
  static const UI8 v100 = UI8(100);
  static const UI8 v105 = UI8(105);
  static const UI8 v106 = UI8(106);
  static const UI8 v107 = UI8(107);
  static const UI8 v108 = UI8(108);
  static const UI8 v110 = UI8(110);
  static const UI8 v115 = UI8(115);
  static const UI8 v119 = UI8(119);
  static const UI8 v120 = UI8(120);
  static const UI8 v121 = UI8(121);
  static const UI8 v122 = UI8(122);
  static const UI8 v127 = UI8(127);
  static const UI8 v128 = UI8(128);
  static const UI8 v129 = UI8(129);
  static const UI8 v130 = UI8(130);
  static const UI8 v131 = UI8(131);
  static const UI8 v132 = UI8(132);
  static const UI8 v133 = UI8(133);
  static const UI8 v134 = UI8(134);
  static const UI8 v135 = UI8(135);
  static const UI8 v136 = UI8(136);
  static const UI8 v137 = UI8(137);
  static const UI8 v138 = UI8(138);
  static const UI8 v139 = UI8(139);
  static const UI8 v140 = UI8(140);
  static const UI8 v141 = UI8(141);
  static const UI8 v142 = UI8(142);
  static const UI8 v143 = UI8(143);
  static const UI8 v144 = UI8(144);
  static const UI8 v145 = UI8(145);
  static const UI8 v146 = UI8(146);
  static const UI8 v147 = UI8(147);
  static const UI8 v148 = UI8(148);
  static const UI8 v149 = UI8(149);
  static const UI8 v150 = UI8(150);
  static const UI8 v160 = UI8(160);
  static const UI8 v165 = UI8(165);
  static const UI8 v166 = UI8(166);
  static const UI8 v167 = UI8(167);
  static const UI8 v168 = UI8(168);
  static const UI8 v169 = UI8(169);
  static const UI8 v170 = UI8(170);
  static const UI8 v180 = UI8(180);
  static const UI8 v190 = UI8(190);
  static const UI8 v200 = UI8(200);
  static const UI8 v201 = UI8(201);
  static const UI8 v212 = UI8(212);
  static const UI8 v213 = UI8(213);
  static const UI8 v214 = UI8(214);
  static const UI8 v215 = UI8(215);
  static const UI8 v216 = UI8(216);
  static const UI8 v217 = UI8(217);
  static const UI8 v218 = UI8(218);
  static const UI8 v219 = UI8(219);
  static const UI8 v220 = UI8(220);
  static const UI8 v221 = UI8(221);
  static const UI8 v222 = UI8(222);
  static const UI8 v223 = UI8(223);
  static const UI8 v224 = UI8(224);
  static const UI8 v225 = UI8(225);
  static const UI8 v226 = UI8(226);
  static const UI8 v227 = UI8(227);
  static const UI8 v228 = UI8(228);
  static const UI8 v229 = UI8(229);
  static const UI8 v230 = UI8(230);
  static const UI8 v231 = UI8(231);
  static const UI8 v232 = UI8(232);
  static const UI8 v233 = UI8(233);
  static const UI8 v234 = UI8(234);
  static const UI8 v235 = UI8(235);
  static const UI8 v236 = UI8(236);
  static const UI8 v237 = UI8(237);
  static const UI8 v238 = UI8(238);
  static const UI8 v239 = UI8(239);
  static const UI8 v240 = UI8(240);
  static const UI8 v241 = UI8(241);
  static const UI8 v242 = UI8(242);
  static const UI8 v243 = UI8(243);
  static const UI8 v244 = UI8(244);
  static const UI8 v245 = UI8(245);
  static const UI8 v246 = UI8(246);
  static const UI8 v247 = UI8(247);
  static const UI8 v248 = UI8(248);
  static const UI8 v249 = UI8(249);
  static const UI8 v250 = UI8(250);
  static const UI8 v251 = UI8(251);
  static const UI8 v252 = UI8(252);
  static const UI8 v253 = UI8(253);
  static const UI8 v254 = UI8(254);
  static const UI8 v255 = UI8(255);
}

// This provides the user-friendly interface for the 32-bit integer.
extension type const ColorId(int value) {
  int get alpha => (value >> 24) & 0xFF;
  int get red => (value >> 16) & 0xFF;
  int get green => (value >> 8) & 0xFF;
  int get blue => (value & 0xFF);
}
