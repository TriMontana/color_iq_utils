// ignore_for_file: constant_identifier_names

import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/extensions/float_ext_type.dart';
import 'package:color_iq_utils/src/extensions/int_ext_types.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';

enum Iq255 {
  v0(
    UI8(0x00),
    norm: Percent.v0,
    lin: LinRGB.v0,
    shortHex: "0x00",
  ),
  v1(
    UI8(0x01),
    norm: Percent(0.00392156862745098),
    lin: LinRGB(0.0003035269835488375),
    shortHex: "0x01",
  ),
  v2(
    UI8(0x02),
    norm: Percent(0.00784313725490196),
    lin: LinRGB(0.000607053967097675),
    shortHex: "0x02",
  ),
  v3(
    UI8(0x03),
    norm: Percent(0.011764705882352941),
    lin: LinRGB(0.0009105809506465125),
    shortHex: "0x03",
  ),
  v4(
    UI8(0x04),
    norm: Percent(0.01568627450980392),
    lin: LinRGB(0.00121410793419535),
    shortHex: "0x04",
  ),
  v5(
    UI8(0x05),
    norm: Percent(0.0196078431372549),
    lin: LinRGB(0.0015176349177441874),
    shortHex: "0x05",
  ),
  v6(
    UI8(0x06),
    norm: Percent(0.023529411764705882),
    lin: LinRGB(0.001821161901293025),
    shortHex: "0x06",
  ),
  v7(
    UI8(0x07),
    norm: Percent(0.027450980392156862),
    lin: LinRGB(0.0021246888848418626),
    shortHex: "0x07",
  ),
  v8(
    UI8(0x08),
    norm: Percent(0.03137254901960784),
    lin: LinRGB(0.0024282158683907),
    shortHex: "0x08",
  ),
  v9(
    UI8(0x09),
    norm: Percent(0.03529411764705882),
    lin: LinRGB(0.0027317428519395373),
    shortHex: "0x09",
  ),
  v10(
    UI8(0x0A),
    norm: Percent(0.0392156862745098),
    lin: LinRGB(0.003035269835488375),
    shortHex: "0x0A",
  ),
  v11(
    UI8(0x0B),
    norm: Percent(0.043137254901960784),
    lin: LinRGB(0.003346535763899161),
    shortHex: "0x0B",
  ),
  v12(
    UI8(0x0C),
    norm: Percent(0.047058823529411764),
    lin: LinRGB(0.003676507324047436),
    shortHex: "0x0C",
  ),
  v13(
    UI8(0x0D),
    norm: Percent(0.050980392156862744),
    lin: LinRGB(0.004024717018496307),
    shortHex: "0x0D",
  ),
  v14(
    UI8(0x0E),
    norm: Percent(0.054901960784313725),
    lin: LinRGB(0.004391442037410293),
    shortHex: "0x0E",
  ),
  v15(
    UI8(0x0F),
    norm: Percent(0.058823529411764705),
    lin: LinRGB(0.004776953480693729),
    shortHex: "0x0F",
  ),
  v16(
    UI8(0x10),
    norm: Percent(0.06274509803921569),
    lin: LinRGB(0.005181516702338386),
    shortHex: "0x10",
  ),
  v17(
    UI8(0x11),
    norm: Percent(0.06666666666666667),
    lin: LinRGB(0.005605391624202723),
    shortHex: "0x11",
  ),
  v18(
    UI8(0x12),
    norm: Percent(0.07058823529411765),
    lin: LinRGB(0.006048833022857054),
    shortHex: "0x12",
  ),
  v19(
    UI8(0x13),
    norm: Percent(0.07450980392156863),
    lin: LinRGB(0.006512090792594475),
    shortHex: "0x13",
  ),
  v20(
    UI8(0x14),
    norm: Percent(0.0784313725490196),
    lin: LinRGB(0.006995410187265387),
    shortHex: "0x14",
  ),
  v21(
    UI8(0x15),
    norm: Percent(0.08235294117647059),
    lin: LinRGB(0.007499032043226175),
    shortHex: "0x15",
  ),
  v22(
    UI8(0x16),
    norm: Percent(0.08627450980392157),
    lin: LinRGB(0.008023192985384994),
    shortHex: "0x16",
  ),
  v23(
    UI8(0x17),
    norm: Percent(0.09019607843137255),
    lin: LinRGB(0.008568125618069307),
    shortHex: "0x17",
  ),
  v24(
    UI8(0x18),
    norm: Percent(0.09411764705882353),
    lin: LinRGB(0.009134058702220787),
    shortHex: "0x18",
  ),
  v25(
    UI8(0x19),
    norm: Percent(0.09803921568627451),
    lin: LinRGB(0.00972121732023785),
    shortHex: "0x19",
  ),
  v26(
    UI8(0x1A),
    norm: Percent(0.10196078431372549),
    lin: LinRGB(0.010329823029626936),
    shortHex: "0x1A",
  ),
  v27(
    UI8(0x1B),
    norm: Percent(0.10588235294117647),
    lin: LinRGB(0.010960094006488246),
    shortHex: "0x1B",
  ),
  v28(
    UI8(0x1C),
    norm: Percent(0.10980392156862745),
    lin: LinRGB(0.011612245179743885),
    shortHex: "0x1C",
  ),
  v29(
    UI8(0x1D),
    norm: Percent(0.11372549019607843),
    lin: LinRGB(0.012286488356915872),
    shortHex: "0x1D",
  ),
  v30(
    UI8(0x1E),
    norm: Percent(0.11764705882352941),
    lin: LinRGB(0.012983032342173012),
    shortHex: "0x1E",
  ),
  v31(
    UI8(0x1F),
    norm: Percent(0.12156862745098039),
    lin: LinRGB(0.013702083047289686),
    shortHex: "0x1F",
  ),
  v32(
    UI8(0x20),
    norm: Percent(0.12549019607843137),
    lin: LinRGB(0.014443843596092545),
    shortHex: "0x20",
  ),
  v33(
    UI8(0x21),
    norm: Percent(0.12941176470588237),
    lin: LinRGB(0.01520851442291271),
    shortHex: "0x21",
  ),
  v34(
    UI8(0x22),
    norm: Percent(0.13333333333333333),
    lin: LinRGB(0.01599629336550963),
    shortHex: "0x22",
  ),
  v35(
    UI8(0x23),
    norm: Percent(0.13725490196078433),
    lin: LinRGB(0.016807375752887384),
    shortHex: "0x23",
  ),
  v36(
    UI8(0x24),
    norm: Percent(0.1411764705882353),
    lin: LinRGB(0.017641954488384078),
    shortHex: "0x24",
  ),
  v37(
    UI8(0x25),
    norm: Percent(0.1450980392156863),
    lin: LinRGB(0.018500220128379697),
    shortHex: "0x25",
  ),
  v38(
    UI8(0x26),
    norm: Percent(0.14901960784313725),
    lin: LinRGB(0.019382360956935723),
    shortHex: "0x26",
  ),
  v39(
    UI8(0x27),
    norm: Percent(0.15294117647058825),
    lin: LinRGB(0.0202885630566524),
    shortHex: "0x27",
  ),
  v40(
    UI8(0x28),
    norm: Percent(0.1568627450980392),
    lin: LinRGB(0.021219010376003555),
    shortHex: "0x28",
  ),
  v41(
    UI8(0x29),
    norm: Percent(0.1607843137254902),
    lin: LinRGB(0.022173884793387385),
    shortHex: "0x29",
  ),
  v42(
    UI8(0x2A),
    norm: Percent(0.16470588235294117),
    lin: LinRGB(0.02315336617811041),
    shortHex: "0x2A",
  ),
  v43(
    UI8(0x2B),
    norm: Percent(0.16862745098039217),
    lin: LinRGB(0.024157632448504756),
    shortHex: "0x2B",
  ),
  v44(
    UI8(0x2C),
    norm: Percent(0.17254901960784313),
    lin: LinRGB(0.02518685962736163),
    shortHex: "0x2C",
  ),
  v45(
    UI8(0x2D),
    norm: Percent(0.17647058823529413),
    lin: LinRGB(0.026241221894849898),
    shortHex: "0x2D",
  ),
  v46(
    UI8(0x2E),
    norm: Percent(0.1803921568627451),
    lin: LinRGB(0.027320891639074894),
    shortHex: "0x2E",
  ),
  v47(
    UI8(0x2F),
    norm: Percent(0.1843137254901961),
    lin: LinRGB(0.028426039504420793),
    shortHex: "0x2F",
  ),
  v48(
    UI8(0x30),
    norm: Percent(0.18823529411764706),
    lin: LinRGB(0.0295568344378088),
    shortHex: "0x30",
  ),
  v49(
    UI8(0x31),
    norm: Percent(0.19215686274509805),
    lin: LinRGB(0.030713443732993635),
    shortHex: "0x31",
  ),
  v50(
    UI8(0x32),
    norm: Percent(0.19607843137254902),
    lin: LinRGB(0.03189603307301153),
    shortHex: "0x32",
  ),
  v51(
    UI8(0x33),
    norm: Percent(0.2),
    lin: LinRGB(0.033104766570885055),
    shortHex: "0x33",
  ),
  v52(
    UI8(0x34),
    norm: Percent(0.20392156862745098),
    lin: LinRGB(0.03433980680868217),
    shortHex: "0x34",
  ),
  v53(
    UI8(0x35),
    norm: Percent(0.20784313725490197),
    lin: LinRGB(0.03560131487502034),
    shortHex: "0x35",
  ),
  v54(
    UI8(0x36),
    norm: Percent(0.21176470588235294),
    lin: LinRGB(0.03688945040110004),
    shortHex: "0x36",
  ),
  v55(
    UI8(0x37),
    norm: Percent(0.21568627450980393),
    lin: LinRGB(0.0382043715953465),
    shortHex: "0x37",
  ),
  v56(
    UI8(0x38),
    norm: Percent(0.2196078431372549),
    lin: LinRGB(0.03954623527673284),
    shortHex: "0x38",
  ),
  v57(
    UI8(0x39),
    norm: Percent(0.2235294117647059),
    lin: LinRGB(0.04091519690685319),
    shortHex: "0x39",
  ),
  v58(
    UI8(0x3A),
    norm: Percent(0.22745098039215686),
    lin: LinRGB(0.042311410620809675),
    shortHex: "0x3A",
  ),
  v59(
    UI8(0x3B),
    norm: Percent(0.23137254901960785),
    lin: LinRGB(0.043735029256973465),
    shortHex: "0x3B",
  ),
  v60(
    UI8(0x3C),
    norm: Percent(0.23529411764705882),
    lin: LinRGB(0.04518620438567554),
    shortHex: "0x3C",
  ),
  v61(
    UI8(0x3D),
    norm: Percent(0.23921568627450981),
    lin: LinRGB(0.046665086336880095),
    shortHex: "0x3D",
  ),
  v62(
    UI8(0x3E),
    norm: Percent(0.24313725490196078),
    lin: LinRGB(0.04817182422688942),
    shortHex: "0x3E",
  ),
  v63(
    UI8(0x3F),
    norm: Percent(0.24705882352941178),
    lin: LinRGB(0.04970656598412723),
    shortHex: "0x3F",
  ),
  v64(
    UI8(0x40),
    norm: Percent(0.25098039215686274),
    lin: LinRGB(0.05126945837404324),
    shortHex: "0x40",
  ),
  v65(
    UI8(0x41),
    norm: Percent(0.2549019607843137),
    lin: LinRGB(0.052860647023180246),
    shortHex: "0x41",
  ),
  v66(
    UI8(0x42),
    norm: Percent(0.25882352941176473),
    lin: LinRGB(0.05448027644244237),
    shortHex: "0x42",
  ),
  v67(
    UI8(0x43),
    norm: Percent(0.2627450980392157),
    lin: LinRGB(0.05612849004960009),
    shortHex: "0x43",
  ),
  v68(
    UI8(0x44),
    norm: Percent(0.26666666666666666),
    lin: LinRGB(0.05780543019106723),
    shortHex: "0x44",
  ),
  v69(
    UI8(0x45),
    norm: Percent(0.27058823529411763),
    lin: LinRGB(0.0595112381629812),
    shortHex: "0x45",
  ),
  v70(
    UI8(0x46),
    norm: Percent(0.27450980392156865),
    lin: LinRGB(0.06124605423161761),
    shortHex: "0x46",
  ),
  v71(
    UI8(0x47),
    norm: Percent(0.2784313725490196),
    lin: LinRGB(0.06301001765316767),
    shortHex: "0x47",
  ),
  v72(
    UI8(0x48),
    norm: Percent(0.2823529411764706),
    lin: LinRGB(0.06480326669290577),
    shortHex: "0x48",
  ),
  v73(
    UI8(0x49),
    norm: Percent(0.28627450980392155),
    lin: LinRGB(0.06662593864377289),
    shortHex: "0x49",
  ),
  v74(
    UI8(0x4A),
    norm: Percent(0.2901960784313726),
    lin: LinRGB(0.06847816984440017),
    shortHex: "0x4A",
  ),
  v75(
    UI8(0x4B),
    norm: Percent(0.29411764705882354),
    lin: LinRGB(0.07036009569659588),
    shortHex: "0x4B",
  ),
  v76(
    UI8(0x4C),
    norm: Percent(0.2980392156862745),
    lin: LinRGB(0.07227185068231748),
    shortHex: "0x4C",
  ),
  v77(
    UI8(0x4D),
    norm: Percent(0.30196078431372547),
    lin: LinRGB(0.07421356838014963),
    shortHex: "0x4D",
  ),
  v78(
    UI8(0x4E),
    norm: Percent(0.3058823529411765),
    lin: LinRGB(0.07618538148130785),
    shortHex: "0x4E",
  ),
  v79(
    UI8(0x4F),
    norm: Percent(0.30980392156862746),
    lin: LinRGB(0.07818742180518633),
    shortHex: "0x4F",
  ),
  v80(
    UI8(0x50),
    norm: Percent(0.3137254901960784),
    lin: LinRGB(0.08021982031446832),
    shortHex: "0x50",
  ),
  v81(
    UI8(0x51),
    norm: Percent(0.3176470588235294),
    lin: LinRGB(0.0822827071298148),
    shortHex: "0x51",
  ),
  v82(
    UI8(0x52),
    norm: Percent(0.3215686274509804),
    lin: LinRGB(0.08437621154414882),
    shortHex: "0x52",
  ),
  v83(
    UI8(0x53),
    norm: Percent(0.3254901960784314),
    lin: LinRGB(0.08650046203654976),
    shortHex: "0x53",
  ),
  v84(
    UI8(0x54),
    norm: Percent(0.32941176470588235),
    lin: LinRGB(0.08865558628577294),
    shortHex: "0x54",
  ),
  v85(
    UI8(0x55),
    norm: Percent(0.3333333333333333),
    lin: LinRGB(0.09084171118340768),
    shortHex: "0x55",
  ),
  v86(
    UI8(0x56),
    norm: Percent(0.33725490196078434),
    lin: LinRGB(0.09305896284668745),
    shortHex: "0x56",
  ),
  v87(
    UI8(0x57),
    norm: Percent(0.3411764705882353),
    lin: LinRGB(0.0953074666309647),
    shortHex: "0x57",
  ),
  v88(
    UI8(0x58),
    norm: Percent(0.34509803921568627),
    lin: LinRGB(0.09758734714186246),
    shortHex: "0x58",
  ),
  v89(
    UI8(0x59),
    norm: Percent(0.34901960784313724),
    lin: LinRGB(0.09989872824711389),
    shortHex: "0x59",
  ),
  v90(
    UI8(0x5A),
    norm: Percent(0.35294117647058826),
    lin: LinRGB(0.10224173308810132),
    shortHex: "0x5A",
  ),
  v91(
    UI8(0x5B),
    norm: Percent(0.3568627450980392),
    lin: LinRGB(0.10461648409110419),
    shortHex: "0x5B",
  ),
  v92(
    UI8(0x5C),
    norm: Percent(0.3607843137254902),
    lin: LinRGB(0.10702310297826761),
    shortHex: "0x5C",
  ),
  v93(
    UI8(0x5D),
    norm: Percent(0.36470588235294116),
    lin: LinRGB(0.10946171077829933),
    shortHex: "0x5D",
  ),
  v94(
    UI8(0x5E),
    norm: Percent(0.3686274509803922),
    lin: LinRGB(0.1119324278369056),
    shortHex: "0x5E",
  ),
  v95(
    UI8(0x5F),
    norm: Percent(0.37254901960784315),
    lin: LinRGB(0.11443537382697373),
    shortHex: "0x5F",
  ),
  v96(
    UI8(0x60),
    norm: Percent(0.3764705882352941),
    lin: LinRGB(0.11697066775851084),
    shortHex: "0x60",
  ),
  v97(
    UI8(0x61),
    norm: Percent(0.3803921568627451),
    lin: LinRGB(0.11953842798834562),
    shortHex: "0x61",
  ),
  v98(
    UI8(0x62),
    norm: Percent(0.3843137254901961),
    lin: LinRGB(0.12213877222960187),
    shortHex: "0x62",
  ),
  v99(
    UI8(0x63),
    norm: Percent(0.38823529411764707),
    lin: LinRGB(0.12477181756095049),
    shortHex: "0x63",
  ),
  v100(
    UI8(0x64),
    norm: Percent(0.39215686274509803),
    lin: LinRGB(0.12743768043564743),
    shortHex: "0x64",
  ),
  v101(
    UI8(0x65),
    norm: Percent(0.396078431372549),
    lin: LinRGB(0.1301364766903643),
    shortHex: "0x65",
  ),
  v102(
    UI8(0x66),
    norm: Percent(0.4),
    lin: LinRGB(0.13286832155381798),
    shortHex: "0x66",
  ),
  v103(
    UI8(0x67),
    norm: Percent(0.403921568627451),
    lin: LinRGB(0.13563332965520566),
    shortHex: "0x67",
  ),
  v104(
    UI8(0x68),
    norm: Percent(0.40784313725490196),
    lin: LinRGB(0.13843161503245183),
    shortHex: "0x68",
  ),
  v105(
    UI8(0x69),
    norm: Percent(0.4117647058823529),
    lin: LinRGB(0.14126329114027164),
    shortHex: "0x69",
  ),
  v106(
    UI8(0x6A),
    norm: Percent(0.41568627450980394),
    lin: LinRGB(0.14412847085805777),
    shortHex: "0x6A",
  ),
  v107(
    UI8(0x6B),
    norm: Percent(0.4196078431372549),
    lin: LinRGB(0.14702726649759498),
    shortHex: "0x6B",
  ),
  v108(
    UI8(0x6C),
    norm: Percent(0.4235294117647059),
    lin: LinRGB(0.14995978981060856),
    shortHex: "0x6C",
  ),
  v109(
    UI8(0x6D),
    norm: Percent(0.42745098039215684),
    lin: LinRGB(0.15292615199615017),
    shortHex: "0x6D",
  ),
  v110(
    UI8(0x6E),
    norm: Percent(0.43137254901960786),
    lin: LinRGB(0.1559264637078274),
    shortHex: "0x6E",
  ),
  v111(
    UI8(0x6F),
    norm: Percent(0.43529411764705883),
    lin: LinRGB(0.1589608350608804),
    shortHex: "0x6F",
  ),
  v112(
    UI8(0x70),
    norm: Percent(0.4392156862745098),
    lin: LinRGB(0.162029375639111),
    shortHex: "0x70",
  ),
  v113(
    UI8(0x71),
    norm: Percent(0.44313725490196076),
    lin: LinRGB(0.1651321945016676),
    shortHex: "0x71",
  ),
  v114(
    UI8(0x72),
    norm: Percent(0.4470588235294118),
    lin: LinRGB(0.16826940018969075),
    shortHex: "0x72",
  ),
  v115(
    UI8(0x73),
    norm: Percent(0.45098039215686275),
    lin: LinRGB(0.1714411007328226),
    shortHex: "0x73",
  ),
  v116(
    UI8(0x74),
    norm: Percent(0.4549019607843137),
    lin: LinRGB(0.17464740365558504),
    shortHex: "0x74",
  ),
  v117(
    UI8(0x75),
    norm: Percent(0.4588235294117647),
    lin: LinRGB(0.17788841598362912),
    shortHex: "0x75",
  ),
  v118(
    UI8(0x76),
    norm: Percent(0.4627450980392157),
    lin: LinRGB(0.18116424424986022),
    shortHex: "0x76",
  ),
  v119(
    UI8(0x77),
    norm: Percent(0.4666666666666667),
    lin: LinRGB(0.184474994500441),
    shortHex: "0x77",
  ),
  v120(
    UI8(0x78),
    norm: Percent(0.47058823529411764),
    lin: LinRGB(0.18782077230067787),
    shortHex: "0x78",
  ),
  v121(
    UI8(0x79),
    norm: Percent(0.4745098039215686),
    lin: LinRGB(0.19120168274079138),
    shortHex: "0x79",
  ),
  v122(
    UI8(0x7A),
    norm: Percent(0.47843137254901963),
    lin: LinRGB(0.1946178304415758),
    shortHex: "0x7A",
  ),
  v123(
    UI8(0x7B),
    norm: Percent(0.4823529411764706),
    lin: LinRGB(0.19806931955994886),
    shortHex: "0x7B",
  ),
  v124(
    UI8(0x7C),
    norm: Percent(0.48627450980392156),
    lin: LinRGB(0.20155625379439707),
    shortHex: "0x7C",
  ),
  v125(
    UI8(0x7D),
    norm: Percent(0.49019607843137253),
    lin: LinRGB(0.20507873639031693),
    shortHex: "0x7D",
  ),
  v126(
    UI8(0x7E),
    norm: Percent(0.49411764705882355),
    lin: LinRGB(0.20863687014525575),
    shortHex: "0x7E",
  ),
  v127(
    UI8(0x7F),
    norm: Percent(0.4980392156862745),
    lin: LinRGB(0.21223075741405523),
    shortHex: "0x7F",
  ),
  v128(
    UI8(0x80),
    norm: Percent(0.5019607843137255),
    lin: LinRGB(0.21586050011389926),
    shortHex: "0x80",
  ),
  v129(
    UI8(0x81),
    norm: Percent(0.5058823529411764),
    lin: LinRGB(0.2195261997292692),
    shortHex: "0x81",
  ),
  v130(
    UI8(0x82),
    norm: Percent(0.5098039215686274),
    lin: LinRGB(0.2232279573168085),
    shortHex: "0x82",
  ),
  v131(
    UI8(0x83),
    norm: Percent(0.5137254901960784),
    lin: LinRGB(0.22696587351009836),
    shortHex: "0x83",
  ),
  v132(
    UI8(0x84),
    norm: Percent(0.5176470588235295),
    lin: LinRGB(0.23074004852434915),
    shortHex: "0x84",
  ),
  v133(
    UI8(0x85),
    norm: Percent(0.5215686274509804),
    lin: LinRGB(0.23455058216100522),
    shortHex: "0x85",
  ),
  v134(
    UI8(0x86),
    norm: Percent(0.5254901960784314),
    lin: LinRGB(0.238397573812271),
    shortHex: "0x86",
  ),
  v135(
    UI8(0x87),
    norm: Percent(0.5294117647058824),
    lin: LinRGB(0.24228112246555486),
    shortHex: "0x87",
  ),
  v136(
    UI8(0x88),
    norm: Percent(0.5333333333333333),
    lin: LinRGB(0.24620132670783548),
    shortHex: "0x88",
  ),
  v137(
    UI8(0x89),
    norm: Percent(0.5372549019607843),
    lin: LinRGB(0.25015828472995344),
    shortHex: "0x89",
  ),
  v138(
    UI8(0x8A),
    norm: Percent(0.5411764705882353),
    lin: LinRGB(0.25415209433082675),
    shortHex: "0x8A",
  ),
  v139(
    UI8(0x8B),
    norm: Percent(0.5450980392156862),
    lin: LinRGB(0.2581828529215958),
    shortHex: "0x8B",
  ),
  v140(
    UI8(0x8C),
    norm: Percent(0.5490196078431373),
    lin: LinRGB(0.26225065752969623),
    shortHex: "0x8C",
  ),
  v141(
    UI8(0x8D),
    norm: Percent(0.5529411764705883),
    lin: LinRGB(0.26635560480286247),
    shortHex: "0x8D",
  ),
  v142(
    UI8(0x8E),
    norm: Percent(0.5568627450980392),
    lin: LinRGB(0.2704977910130658),
    shortHex: "0x8E",
  ),
  v143(
    UI8(0x8F),
    norm: Percent(0.5607843137254902),
    lin: LinRGB(0.27467731206038465),
    shortHex: "0x8F",
  ),
  v144(
    UI8(0x90),
    norm: Percent(0.5647058823529412),
    lin: LinRGB(0.2788942634768104),
    shortHex: "0x90",
  ),
  v145(
    UI8(0x91),
    norm: Percent(0.5686274509803921),
    lin: LinRGB(0.2831487404299921),
    shortHex: "0x91",
  ),
  v146(
    UI8(0x92),
    norm: Percent(0.5725490196078431),
    lin: LinRGB(0.2874408377269175),
    shortHex: "0x92",
  ),
  v147(
    UI8(0x93),
    norm: Percent(0.5764705882352941),
    lin: LinRGB(0.29177064981753587),
    shortHex: "0x93",
  ),
  v148(
    UI8(0x94),
    norm: Percent(0.5803921568627451),
    lin: LinRGB(0.2961382707983211),
    shortHex: "0x94",
  ),
  v149(
    UI8(0x95),
    norm: Percent(0.5843137254901961),
    lin: LinRGB(0.3005437944157765),
    shortHex: "0x95",
  ),
  v150(
    UI8(0x96),
    norm: Percent(0.5882352941176471),
    lin: LinRGB(0.3049873140698863),
    shortHex: "0x96",
  ),
  v151(
    UI8(0x97),
    norm: Percent(0.592156862745098),
    lin: LinRGB(0.30946892281750854),
    shortHex: "0x97",
  ),
  v152(
    UI8(0x98),
    norm: Percent(0.596078431372549),
    lin: LinRGB(0.31398871337571754),
    shortHex: "0x98",
  ),
  v153(
    UI8(0x99),
    norm: Percent(0.6),
    lin: LinRGB(0.31854677812509186),
    shortHex: "0x99",
  ),
  v154(
    UI8(0x9A),
    norm: Percent(0.6039215686274509),
    lin: LinRGB(0.32314320911295075),
    shortHex: "0x9A",
  ),
  v155(
    UI8(0x9B),
    norm: Percent(0.6078431372549019),
    lin: LinRGB(0.3277780980565422),
    shortHex: "0x9B",
  ),
  v156(
    UI8(0x9C),
    norm: Percent(0.611764705882353),
    lin: LinRGB(0.33245153634617935),
    shortHex: "0x9C",
  ),
  v157(
    UI8(0x9D),
    norm: Percent(0.615686274509804),
    lin: LinRGB(0.33716361504833037),
    shortHex: "0x9D",
  ),
  v158(
    UI8(0x9E),
    norm: Percent(0.6196078431372549),
    lin: LinRGB(0.3419144249086609),
    shortHex: "0x9E",
  ),
  v159(
    UI8(0x9F),
    norm: Percent(0.6235294117647059),
    lin: LinRGB(0.3467040563550296),
    shortHex: "0x9F",
  ),
  v160(
    UI8(0xA0),
    norm: Percent(0.6274509803921569),
    lin: LinRGB(0.35153259950043936),
    shortHex: "0xA0",
  ),
  v161(
    UI8(0xA1),
    norm: Percent(0.6313725490196078),
    lin: LinRGB(0.3564001441459435),
    shortHex: "0xA1",
  ),
  v162(
    UI8(0xA2),
    norm: Percent(0.6352941176470588),
    lin: LinRGB(0.3613067797835095),
    shortHex: "0xA2",
  ),
  v163(
    UI8(0xA3),
    norm: Percent(0.6392156862745098),
    lin: LinRGB(0.3662525955988395),
    shortHex: "0xA3",
  ),
  v164(
    UI8(0xA4),
    norm: Percent(0.6431372549019608),
    lin: LinRGB(0.3712376804741491),
    shortHex: "0xA4",
  ),
  v165(
    UI8(0xA5),
    norm: Percent(0.6470588235294118),
    lin: LinRGB(0.3762621229909065),
    shortHex: "0xA5",
  ),
  v166(
    UI8(0xA6),
    norm: Percent(0.6509803921568628),
    lin: LinRGB(0.38132601143253014),
    shortHex: "0xA6",
  ),
  v167(
    UI8(0xA7),
    norm: Percent(0.6549019607843137),
    lin: LinRGB(0.386429433787049),
    shortHex: "0xA7",
  ),
  v168(
    UI8(0xA8),
    norm: Percent(0.6588235294117647),
    lin: LinRGB(0.39157247774972326),
    shortHex: "0xA8",
  ),
  v169(
    UI8(0xA9),
    norm: Percent(0.6627450980392157),
    lin: LinRGB(0.39675523072562685),
    shortHex: "0xA9",
  ),
  v170(
    UI8(0xAA),
    norm: Percent(0.6666666666666666),
    lin: LinRGB(0.4019777798321958),
    shortHex: "0xAA",
  ),
  v171(
    UI8(0xAB),
    norm: Percent(0.6705882352941176),
    lin: LinRGB(0.4072402119017367),
    shortHex: "0xAB",
  ),
  v172(
    UI8(0xAC),
    norm: Percent(0.6745098039215687),
    lin: LinRGB(0.41254261348390375),
    shortHex: "0xAC",
  ),
  v173(
    UI8(0xAD),
    norm: Percent(0.6784313725490196),
    lin: LinRGB(0.4178850708481375),
    shortHex: "0xAD",
  ),
  v174(
    UI8(0xAE),
    norm: Percent(0.6823529411764706),
    lin: LinRGB(0.4232676699860717),
    shortHex: "0xAE",
  ),
  v175(
    UI8(0xAF),
    norm: Percent(0.6862745098039216),
    lin: LinRGB(0.4286904966139066),
    shortHex: "0xAF",
  ),
  v176(
    UI8(0xB0),
    norm: Percent(0.6901960784313725),
    lin: LinRGB(0.43415363617474895),
    shortHex: "0xB0",
  ),
  v177(
    UI8(0xB1),
    norm: Percent(0.6941176470588235),
    lin: LinRGB(0.4396571738409188),
    shortHex: "0xB1",
  ),
  v178(
    UI8(0xB2),
    norm: Percent(0.6980392156862745),
    lin: LinRGB(0.44520119451622786),
    shortHex: "0xB2",
  ),
  v179(
    UI8(0xB3),
    norm: Percent(0.7019607843137254),
    lin: LinRGB(0.45078578283822346),
    shortHex: "0xB3",
  ),
  v180(
    UI8(0xB4),
    norm: Percent(0.7058823529411765),
    lin: LinRGB(0.45641102318040466),
    shortHex: "0xB4",
  ),
  v181(
    UI8(0xB5),
    norm: Percent(0.7098039215686275),
    lin: LinRGB(0.4620769996544071),
    shortHex: "0xB5",
  ),
  v182(
    UI8(0xB6),
    norm: Percent(0.7137254901960784),
    lin: LinRGB(0.467783796112159),
    shortHex: "0xB6",
  ),
  v183(
    UI8(0xB7),
    norm: Percent(0.7176470588235294),
    lin: LinRGB(0.47353149614800955),
    shortHex: "0xB7",
  ),
  v184(
    UI8(0xB8),
    norm: Percent(0.7215686274509804),
    lin: LinRGB(0.4793201831008268),
    shortHex: "0xB8",
  ),
  v185(
    UI8(0xB9),
    norm: Percent(0.7254901960784313),
    lin: LinRGB(0.4851499400560704),
    shortHex: "0xB9",
  ),
  v186(
    UI8(0xBA),
    norm: Percent(0.7294117647058823),
    lin: LinRGB(0.4910208498478356),
    shortHex: "0xBA",
  ),
  v187(
    UI8(0xBB),
    norm: Percent(0.7333333333333333),
    lin: LinRGB(0.4969329950608704),
    shortHex: "0xBB",
  ),
  v188(
    UI8(0xBC),
    norm: Percent(0.7372549019607844),
    lin: LinRGB(0.5028864580325687),
    shortHex: "0xBC",
  ),
  v189(
    UI8(0xBD),
    norm: Percent(0.7411764705882353),
    lin: LinRGB(0.5088813208549338),
    shortHex: "0xBD",
  ),
  v190(
    UI8(0xBE),
    norm: Percent(0.7450980392156863),
    lin: LinRGB(0.5149176653765214),
    shortHex: "0xBE",
  ),
  v191(
    UI8(0xBF),
    norm: Percent(0.7490196078431373),
    lin: LinRGB(0.5209955732043543),
    shortHex: "0xBF",
  ),
  v192(
    UI8(0xC0),
    norm: Percent(0.7529411764705882),
    lin: LinRGB(0.5271151257058131),
    shortHex: "0xC0",
  ),
  v193(
    UI8(0xC1),
    norm: Percent(0.7568627450980392),
    lin: LinRGB(0.5332764040105052),
    shortHex: "0xC1",
  ),
  v194(
    UI8(0xC2),
    norm: Percent(0.7607843137254902),
    lin: LinRGB(0.5394794890121072),
    shortHex: "0xC2",
  ),
  v195(
    UI8(0xC3),
    norm: Percent(0.7647058823529411),
    lin: LinRGB(0.5457244613701866),
    shortHex: "0xC3",
  ),
  v196(
    UI8(0xC4),
    norm: Percent(0.7686274509803922),
    lin: LinRGB(0.5520114015120001),
    shortHex: "0xC4",
  ),
  v197(
    UI8(0xC5),
    norm: Percent(0.7725490196078432),
    lin: LinRGB(0.5583403896342679),
    shortHex: "0xC5",
  ),
  v198(
    UI8(0xC6),
    norm: Percent(0.7764705882352941),
    lin: LinRGB(0.5647115057049292),
    shortHex: "0xC6",
  ),
  v199(
    UI8(0xC7),
    norm: Percent(0.7803921568627451),
    lin: LinRGB(0.5711248294648731),
    shortHex: "0xC7",
  ),
  v200(
    UI8(0xC8),
    norm: Percent(0.7843137254901961),
    lin: LinRGB(0.5775804404296506),
    shortHex: "0xC8",
  ),
  v201(
    UI8(0xC9),
    norm: Percent(0.788235294117647),
    lin: LinRGB(0.5840784178911641),
    shortHex: "0xC9",
  ),
  v202(
    UI8(0xCA),
    norm: Percent(0.792156862745098),
    lin: LinRGB(0.5906188409193369),
    shortHex: "0xCA",
  ),
  v203(
    UI8(0xCB),
    norm: Percent(0.796078431372549),
    lin: LinRGB(0.5972017883637634),
    shortHex: "0xCB",
  ),
  v204(
    UI8(0xCC),
    norm: Percent(0.8),
    lin: LinRGB(0.6038273388553378),
    shortHex: "0xCC",
  ),
  v205(
    UI8(0xCD),
    norm: Percent(0.803921568627451),
    lin: LinRGB(0.6104955708078648),
    shortHex: "0xCD",
  ),
  v206(
    UI8(0xCE),
    norm: Percent(0.807843137254902),
    lin: LinRGB(0.6172065624196511),
    shortHex: "0xCE",
  ),
  v207(
    UI8(0xCF),
    norm: Percent(0.8117647058823529),
    lin: LinRGB(0.6239603916750761),
    shortHex: "0xCF",
  ),
  v208(
    UI8(0xD0),
    norm: Percent(0.8156862745098039),
    lin: LinRGB(0.6307571363461468),
    shortHex: "0xD0",
  ),
  v209(
    UI8(0xD1),
    norm: Percent(0.8196078431372549),
    lin: LinRGB(0.6375968739940326),
    shortHex: "0xD1",
  ),
  v210(
    UI8(0xD2),
    norm: Percent(0.8235294117647058),
    lin: LinRGB(0.6444796819705821),
    shortHex: "0xD2",
  ),
  v211(
    UI8(0xD3),
    norm: Percent(0.8274509803921568),
    lin: LinRGB(0.6514056374198242),
    shortHex: "0xD3",
  ),
  v212(
    UI8(0xD4),
    norm: Percent(0.8313725490196079),
    lin: LinRGB(0.6583748172794485),
    shortHex: "0xD4",
  ),
  v213(
    UI8(0xD5),
    norm: Percent(0.8352941176470589),
    lin: LinRGB(0.665387298282272),
    shortHex: "0xD5",
  ),
  v214(
    UI8(0xD6),
    norm: Percent(0.8392156862745098),
    lin: LinRGB(0.6724431569576875),
    shortHex: "0xD6",
  ),
  v215(
    UI8(0xD7),
    norm: Percent(0.8431372549019608),
    lin: LinRGB(0.6795424696330938),
    shortHex: "0xD7",
  ),
  v216(
    UI8(0xD8),
    norm: Percent(0.8470588235294118),
    lin: LinRGB(0.6866853124353135),
    shortHex: "0xD8",
  ),
  v217(
    UI8(0xD9),
    norm: Percent(0.8509803921568627),
    lin: LinRGB(0.6938717612919899),
    shortHex: "0xD9",
  ),
  v218(
    UI8(0xDA),
    norm: Percent(0.8549019607843137),
    lin: LinRGB(0.7011018919329731),
    shortHex: "0xDA",
  ),
  v219(
    UI8(0xDB),
    norm: Percent(0.8588235294117647),
    lin: LinRGB(0.7083757798916868),
    shortHex: "0xDB",
  ),
  v220(
    UI8(0xDC),
    norm: Percent(0.8627450980392157),
    lin: LinRGB(0.7156935005064807),
    shortHex: "0xDC",
  ),
  v221(
    UI8(0xDD),
    norm: Percent(0.8666666666666667),
    lin: LinRGB(0.7230551289219693),
    shortHex: "0xDD",
  ),
  v222(
    UI8(0xDE),
    norm: Percent(0.8705882352941177),
    lin: LinRGB(0.7304607400903537),
    shortHex: "0xDE",
  ),
  v223(
    UI8(0xDF),
    norm: Percent(0.8745098039215686),
    lin: LinRGB(0.7379104087727308),
    shortHex: "0xDF",
  ),
  v224(
    UI8(0xE0),
    norm: Percent(0.8784313725490196),
    lin: LinRGB(0.7454042095403874),
    shortHex: "0xE0",
  ),
  v225(
    UI8(0xE1),
    norm: Percent(0.8823529411764706),
    lin: LinRGB(0.7529422167760779),
    shortHex: "0xE1",
  ),
  v226(
    UI8(0xE2),
    norm: Percent(0.8862745098039215),
    lin: LinRGB(0.7605245046752924),
    shortHex: "0xE2",
  ),
  v227(
    UI8(0xE3),
    norm: Percent(0.8901960784313725),
    lin: LinRGB(0.768151147247507),
    shortHex: "0xE3",
  ),
  v228(
    UI8(0xE4),
    norm: Percent(0.8941176470588236),
    lin: LinRGB(0.7758222183174236),
    shortHex: "0xE4",
  ),
  v229(
    UI8(0xE5),
    norm: Percent(0.8980392156862745),
    lin: LinRGB(0.7835377915261935),
    shortHex: "0xE5",
  ),
  v230(
    UI8(0xE6),
    norm: Percent(0.9019607843137255),
    lin: LinRGB(0.7912979403326302),
    shortHex: "0xE6",
  ),
  v231(
    UI8(0xE7),
    norm: Percent(0.9058823529411765),
    lin: LinRGB(0.799102738014409),
    shortHex: "0xE7",
  ),
  v232(
    UI8(0xE8),
    norm: Percent(0.9098039215686274),
    lin: LinRGB(0.8069522576692516),
    shortHex: "0xE8",
  ),
  v233(
    UI8(0xE9),
    norm: Percent(0.9137254901960784),
    lin: LinRGB(0.8148465722161012),
    shortHex: "0xE9",
  ),
  v234(
    UI8(0xEA),
    norm: Percent(0.9176470588235294),
    lin: LinRGB(0.8227857543962835),
    shortHex: "0xEA",
  ),
  v235(
    UI8(0xEB),
    norm: Percent(0.9215686274509803),
    lin: LinRGB(0.8307698767746546),
    shortHex: "0xEB",
  ),
  v236(
    UI8(0xEC),
    norm: Percent(0.9254901960784314),
    lin: LinRGB(0.83879901174074),
    shortHex: "0xEC",
  ),
  v237(
    UI8(0xED),
    norm: Percent(0.9294117647058824),
    lin: LinRGB(0.846873231509858),
    shortHex: "0xED",
  ),
  v238(
    UI8(0xEE),
    norm: Percent(0.9333333333333333),
    lin: LinRGB(0.8549926081242338),
    shortHex: "0xEE",
  ),
  v239(
    UI8(0xEF),
    norm: Percent(0.9372549019607843),
    lin: LinRGB(0.8631572134541023),
    shortHex: "0xEF",
  ),
  v240(
    UI8(0xF0),
    norm: Percent(0.9411764705882353),
    lin: LinRGB(0.8713671191987972),
    shortHex: "0xF0",
  ),
  v241(
    UI8(0xF1),
    norm: Percent(0.9450980392156862),
    lin: LinRGB(0.8796223968878317),
    shortHex: "0xF1",
  ),
  v242(
    UI8(0xF2),
    norm: Percent(0.9490196078431372),
    lin: LinRGB(0.8879231178819663),
    shortHex: "0xF2",
  ),
  v243(
    UI8(0xF3),
    norm: Percent(0.9529411764705882),
    lin: LinRGB(0.8962693533742664),
    shortHex: "0xF3",
  ),
  v244(
    UI8(0xF4),
    norm: Percent(0.9568627450980393),
    lin: LinRGB(0.9046611743911496),
    shortHex: "0xF4",
  ),
  v245(
    UI8(0xF5),
    norm: Percent(0.9607843137254902),
    lin: LinRGB(0.9130986517934192),
    shortHex: "0xF5",
  ),
  v246(
    UI8(0xF6),
    norm: Percent(0.9647058823529412),
    lin: LinRGB(0.9215818562772946),
    shortHex: "0xF6",
  ),
  v247(
    UI8(0xF7),
    norm: Percent(0.9686274509803922),
    lin: LinRGB(0.9301108583754237),
    shortHex: "0xF7",
  ),
  v248(
    UI8(0xF8),
    norm: Percent(0.9725490196078431),
    lin: LinRGB(0.938685728457888),
    shortHex: "0xF8",
  ),
  v249(
    UI8(0xF9),
    norm: Percent(0.9764705882352941),
    lin: LinRGB(0.9473065367331999),
    shortHex: "0xF9",
  ),
  v250(
    UI8(0xFA),
    norm: Percent(0.9803921568627451),
    lin: LinRGB(0.9559733532492861),
    shortHex: "0xFA",
  ),
  v251(
    UI8(0xFB),
    norm: Percent(0.984313725490196),
    lin: LinRGB(0.9646862478944651),
    shortHex: "0xFB",
  ),
  v252(
    UI8(0xFC),
    norm: Percent(0.9882352941176471),
    lin: LinRGB(0.9734452903984125),
    shortHex: "0xFC",
  ),
  v253(
    UI8(0xFD),
    norm: Percent(0.9921568627450981),
    lin: LinRGB(0.9822505503331171),
    shortHex: "0xFD",
  ),
  v254(
    UI8(0xFE),
    norm: Percent(0.996078431372549),
    lin: LinRGB(0.9911020971138298),
    shortHex: "0xFE",
  ),
  v255(
    UI8(0xFF),
    norm: Percent.v100,
    lin: LinRGB.v100,
    shortHex: "0xFF",
  );

  const Iq255(this.intVal,
      {required this.norm, required final LinRGB lin, required this.shortHex})
      : linearized = lin;
  final UI8 intVal;
  final Percent norm;
  final LinRGB linearized;
  final String shortHex;

  static Map<int, Iq255> mapValues = getLookupTable();

  static Map<int, Iq255> getLookupTable() {
    return <int, Iq255>{for (Iq255 iq in Iq255.values) iq.intVal.value: iq};
  }

  static LinRGB intToLinear(final int val) => val.linearizeUint8;

  static LinRGB doubleToLinear(final double val) => val.linearize;

  static Percent intToNormalized(final int val) => Percent.fromInt(val);
  static const Iq255 min = Iq255.v0;
  static const Iq255 max = Iq255.v255;
  static const Iq255 CC = Iq255.v204; // v204
  static const Iq255 CD = Iq255.v205; // v205
  static const Iq255 CE = Iq255.v206; // v206
  static const Iq255 CF = Iq255.v207;
  static const Iq255 E0 = Iq255.v224;
  static const Iq255 E1 = Iq255.v225;
  static const Iq255 E2 = Iq255.v226;
  static const Iq255 E3 = Iq255.v227;
  static const Iq255 E4 = Iq255.v228;
  static const Iq255 E5 = Iq255.v229;
  static const Iq255 E6 = Iq255.v230;
  static const Iq255 E7 = Iq255.v231;
  static const Iq255 E8 = Iq255.v232;
  static const Iq255 E9 = Iq255.v233;
  static const Iq255 EA = Iq255.v234;
  static const Iq255 EB = Iq255.v235;
  static const Iq255 EC = Iq255.v236;
  static const Iq255 ED = Iq255.v237;
  static const Iq255 EE = Iq255.v238;
  static const Iq255 EF = Iq255.v239;
  static const Iq255 F0 = Iq255.v240;
  static const Iq255 F1 = Iq255.v241;
  static const Iq255 F2 = Iq255.v242;
  static const Iq255 F3 = Iq255.v243;
  static const Iq255 F4 = Iq255.v244;
  static const Iq255 F5 = Iq255.v245;
  static const Iq255 F6 = Iq255.v246;
  static const Iq255 F7 = Iq255.v247;
  static const Iq255 F8 = Iq255.v248;
  static const Iq255 F9 = Iq255.v249;
  static const Iq255 FA = Iq255.v250;
  static const Iq255 FB = Iq255.v251;
  static const Iq255 FC = Iq255.v252;
  static const Iq255 FD = Iq255.v253;
  static const Iq255 FE = Iq255.v254;
  static const Iq255 FF = Iq255.v255;

  static Iq255 getIq255(final int x255) {
    x255.assertRange0to255();
    return mapValues[x255] ?? (throw Exception('could not get value $x255'));
  }
}
