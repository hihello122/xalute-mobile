import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

/// ==========================
/// Survey State
/// ==========================

class DiseaseHistory {
  String disease_code;
  bool doctor_diagnosed;
  bool has_prescription;
  bool med_intake;
  bool regular_med_intake;
  double duration_years;
  String name; // 기타질환

  DiseaseHistory({
    required this.disease_code,
    this.doctor_diagnosed = false,
    this.has_prescription = false,
    this.med_intake = false,
    this.regular_med_intake = false,
    this.duration_years = 0.0,
    this.name = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "disease_code": disease_code,
      "doctor_diagnosed": doctor_diagnosed,
      "has_prescription": has_prescription,
      "med_intake": med_intake,
      "regular_med_intake": regular_med_intake,
      "duration_years": duration_years,
      if (disease_code == "기타질환") "name": name,
    };
  }
}

class SurveyState {
  String gender = "M";

  bool hasHealthCheck = false;
  String healthCheckDate = "";

  List<DiseaseHistory> diseaseHistory = [];

  //q1_1_regular_clinic
  bool receive_regular_care = false;
  String clinics = "";
  String q1_1_other = "";

  //q1_2_medication_adherence
  bool follow_prescription = false;
  int main_reason = 0;
  String q1_2_other = "";

  //q2_bp_knowledge
  int know_recent_bp = 1;
  String q2_bp_measurement_frequency = "";
  double q2_count = 0;

  //q3_bg_knowledge
  int know_recent_bg = 1;
  String q3_bp_measurement_frequency = "";
  double q3_count = 0.0;

  //q4_chronic_education_experience
  bool has_education = false;

  //q5_smoking
  bool no_smoke = true;
  bool ever_smoked_over_5packs = false;
  String current_stauts = "daily";
  List<String> current_types = [];
  String q5_other = "";
  String pattern = "";
  int avg_cigs_per_day = 0;
  int avg_cigs_per_month = 0;
  int smoking_years = 0;

  //q6_quit_intention
  String q6_quit_intention = "";

  //q7_alcohol
  bool drank = true;
  String frequency = "2_4_per_month";
  int amount_per_occasion_glasses = 0;
  double avg = 0.0;

  //q8_sitting_time
  double hours_per_day = 6.0;
  double minutes_per_day = 10.0;

  //q9_physical_activity
  List<double> work_high = [0.0, 0.0, 0.0];
  List<double> work_mid = [0.0, 0.0, 0.0];
  List<double> transport_walk_cycle = [0.0, 0.0, 0.0];
  List<double> leisure_high = [0.0, 0.0, 0.0];
  List<double> leisure_mid = [0.0, 0.0, 0.0];

  //q9_1_physical_activity
  String stage_of_change = "";
  String no_activity_main_reason = "";
  String q9_1_other = "";

  //q10_weight_change_last_6m
  String status = "loss";
  double kg = 3.0;

  //q11_self_body_image
  String q11_self_body_image = "slightly_obese";

  //q12_weight_control_effort
  String q12_weight_control_effort = "lose";

  //q13_breakfast_frequency_per_week
  int q13_breakfast_frequency_per_week = 5;

  //q14_diet_score
  bool grain_diversity = true;
  bool vegetable_variety = true;
  bool daily_fruit = true;
  bool daily_dairy = true;
  bool regular_3_meals = true;
  bool balanced_korean_meal = true;
  bool low_salt = true;
  bool no_extra_salt = true;
  bool remove_meat_fat = false;
  bool low_fried_food = true;
  int q14_total_score = 7;

  //q15_why_poor_diet
  String q15_why_poor_diet = "low_will";
  String q15_other = "";

  //q16_sleep_hours
  double weekly = 6.0;
  double weekend = 8.0;

  //q17_depression_score
  int depressed_mood = 1;
  int loss_of_interest = 0;
  int sleep_problem = 0;
  int appetite_change = 0;
  int psychomotor_change = 0;
  int fatigue = 0;
  int worthlessness = 0;
  int concentration = 1;
  int suicidal_ideation = 0;
  int q17_total_score = 7;

  //demographics
  String marry = "married_with_spouse";
  int household_size = 3;
  String insurance_type = "nhis";
  String education_level = "high_school";
  int monthly_household_income = 200;

  Map<String, dynamic> _activityToJson(List<double> v) {
    return {
      "days": v[0],
      "hours_per_day": v[1],
      "minutes_per_day": v[2],
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "gender": gender,

      // health_check_last_6m
      "health_check_last_6m": {
        "has_experience": hasHealthCheck,
        "date": hasHealthCheck ? healthCheckDate : "",
      },

      // q1_disease_history
      "q1_disease_history": diseaseHistory.map((d) => {
        "disease_code": d.disease_code,
        "doctor_diagnosed": d.doctor_diagnosed,
        "has_prescription": d.has_prescription,
        "med_intake": d.med_intake,
        "regular_med_intake": d.regular_med_intake,
        "duration_years": d.duration_years,
        if (d.disease_code == "기타질환") "name": d.name,
      }).toList(),

      // q1_1_regular_clinic
      "q1_1_regular_clinic": {
        "receive_regular_care": receive_regular_care,
        "clinics": receive_regular_care ? clinics : "",
        "other": (receive_regular_care && clinics == "기타")
            ? q1_1_other
            : "",
      },

      // q1_2_medication_adherence
      "q1_2_medication_adherence": {
        "follow_prescription": follow_prescription,
        "main_reason": follow_prescription ? "" : main_reason,
        "other": (follow_prescription || main_reason != "기타")
            ? ""
            : q1_2_other,
      },

      // q2_bp_knowledge
      "q2_bp_knowledge": {
        "know_recent_bp": know_recent_bp,
        "bp_measurement_frequency":
        know_recent_bp == 3 ? "" : q2_bp_measurement_frequency,
        "count": q2_count,
      },

      // q3_bg_knowledge
      "q3_bg_knowledge": {
        "know_recent_bg": know_recent_bg,
        "bp_measurement_frequency":
        know_recent_bg == 3 ? "" : q3_bp_measurement_frequency,
        "count": q3_count,
      },

      // q4_chronic_education_experience
      "q4_chronic_education_experience": {
        "has_education": has_education,
      },

      // q5_smoking
      "q5_smoking": {
        "no_smoke": no_smoke,
        "ever_smoked_over_5packs": ever_smoked_over_5packs,
        "current_status": no_smoke ? "" : current_stauts,
        "current_types": no_smoke ? [] : current_types,
        "other": no_smoke ? "" : q5_other,
        "past_detail": no_smoke
            ? {}
            : {
          "pattern": pattern,
          "avg_cigs_per_day": avg_cigs_per_day,
          "avg_cigs_per_month": avg_cigs_per_month,
          "smoking_years": smoking_years,
        },
      },

      // q6_quit_intention
      "q6_quit_intention": q6_quit_intention,

      // q7_alcohol
      "q7_alcohol": {
        "drank": drank,
        "frequency": drank ? frequency : "",
        "amount_per_occasion_glasses":
        drank ? amount_per_occasion_glasses : 0,
        "avg": (drank && amount_per_occasion_glasses == 10)
            ? avg
            : 0.0,
      },

      // q8_sitting_time
      "q8_sitting_time": {
        "hours_per_day": hours_per_day,
        "minutes_per_day": minutes_per_day,
      },

      // q9_physical_activity
      "q9_physical_activity": {
        "work_high": _activityToJson(work_high),
        "work_mid": _activityToJson(work_mid),
        "transport_walk_cycle": _activityToJson(transport_walk_cycle),
        "leisure_high": _activityToJson(leisure_high),
        "leisure_mid": _activityToJson(leisure_mid),
      },

      // q9_1_physical_activity
      "q9_1_physical_activity": {
        "stage_of_change": stage_of_change,
        "no_activity_main_reason": stage_of_change == "no_intention"
            ? no_activity_main_reason
            : "",
        "other": no_activity_main_reason == "other"
            ? q9_1_other
            : "",
      },

      // q10_weight_change_last_6m
      "q10_weight_change_last_6m": {
        "status": status,
        "kg": status.isEmpty ? 0 : kg,
      },

      // q11_self_body_image
      "q11_self_body_image": q11_self_body_image,

      // q12_weight_control_effort
      "q12_weight_control_effort": q12_weight_control_effort,

      // q13_breakfast_frequency_per_week
      "q13_breakfast_frequency_per_week":
      q13_breakfast_frequency_per_week,

      // q14_diet_score
      "q14_diet_score": {
        "grain_diversity": grain_diversity,
        "vegetable_variety": vegetable_variety,
        "daily_fruit": daily_fruit,
        "daily_dairy": daily_dairy,
        "regular_3_meals": regular_3_meals,
        "balanced_korean_meal": balanced_korean_meal,
        "low_salt": low_salt,
        "no_extra_salt": no_extra_salt,
        "remove_meat_fat": remove_meat_fat,
        "low_fried_food": low_fried_food,
        "total_score": q14_total_score,
      },

      // q15_why_poor_diet
      "q15_why_poor_diet": q15_why_poor_diet,
      "q15_other": q15_why_poor_diet == "other" ? q15_other : "",

      // q16_sleep_hours
      "q16_sleep_hours": {
        "weekday": weekly,
        "weekend": weekend,
      },

      // q17_depression_score
      "q17_depression_score": {
        "items": {
          "depressed_mood": depressed_mood,
          "loss_of_interest": loss_of_interest,
          "sleep_problem": sleep_problem,
          "appetite_change": appetite_change,
          "psychomotor_change": psychomotor_change,
          "fatigue": fatigue,
          "worthlessness": worthlessness,
          "concentration": concentration,
          "suicidal_ideation": suicidal_ideation,
        },
        "total_score": q17_total_score,
      },

      // demographics
      "demographics": {
        "marry": marry,
        "household_size": household_size,
        "insurance_type": insurance_type,
        "education_level": education_level,
        "monthly_household_income": monthly_household_income,
      },
    };
  }

}

class _SurveyPageState extends State<SurveyPage> {
  // 기존 코드의 SurveyState 인스턴스를 유지
  final SurveyState state = SurveyState();

  int openedIndex = -1;

  // 서버 전송 로직
  void _submitData() {
    final Map<String, dynamic> data = state.toJson();

    print("서버 전송용 JSON: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("설문 데이터가 성공적으로 저장되었습니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("건강 설문지",
      style: TextStyle(
        fontSize: 40, // 원하는 크기로 조절하세요
        fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "문항을 읽고 해당하는 사항에 체크해주세요",
              style: TextStyle(
                fontSize: 14, // 본문보다 약간 작게 설정
                color: Colors.grey, // 가독성을 위해 살짝 흐리게 설정 가능
              ),
            ),
            // 1. 질병 이력 섹션 (ExpansionTile 적용)
            _buildExpansionSection(
              //q1
              title: "1. 질병 이력 및 관리",
              index: 0,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("과거 치료받은 적이 있거나 현재 치료 중인 질환을 모두 선택해주세요. (중복가능)"),
                ),
                _buildDiseaseList(),
                _buildOtherDiseaseInput(), // 기타 질환명 입력 칸 추가
              ],
            ),

            // 2. 혈압 및 혈당 관리 섹션
            _buildExpansionSection(
              title: "2. 혈압 및 혈당 관리",
              index: 1,
              children: [
                //q2
                _buildDynamicQuestion<int>(
                  question: "최근(6개월 이내) 본인의 혈압 수치를 알고 계십니까?",
                  groupValue: state.know_recent_bp,
                  options: [
                    {"title": "알고 있다", "value": 1},
                    {"title": "모른다", "value": 2},
                    {"title": "최근(6개원 이내)에 측정한 적이 없다", "value": 3},
                  ],
                  onChanged: (val) => setState(() => state.know_recent_bp = val!),
                ),
                if (state.know_recent_bg == 1 || state.know_recent_bg == 2)
                  _buildKnowledgeExtraFields(
                    freqValue: state.q2_bp_measurement_frequency,
                    // 텍스트 필드에 표시하기 위해 문자열로 변환하여 전달
                    countText: state.q2_count.toString(),
                    onFreqChanged: (v) => setState(() => state.q2_bp_measurement_frequency = v),
                    // 입력받은 문자열을 다시 숫자로 변환하여 저장 (안전하게 tryParse 사용)
                    onCountChanged: (v) => setState(() {
                      state.q3_count = double.tryParse(v) ?? 0.0;
                    }),
                  ),
                //q3
                _buildDynamicQuestion<int>(
                  question: "최근(6개원 이내) 본인의 혈당 수치를 알고 계십니까?",
                  groupValue: state.know_recent_bg,
                  options: [
                    {"title": "알고 있다", "value": 1},
                    {"title": "모른다", "value": 2},
                    {"title": "최근(6개원 이내)에 측정한 적이 없다", "value": 3},
                  ],
                  onChanged: (val) => setState(() => state.know_recent_bg = val!),
                ),
                if (state.know_recent_bg == 1 || state.know_recent_bg == 2)
                  _buildKnowledgeExtraFields(
                    freqValue: state.q3_bp_measurement_frequency,
                    // 텍스트 필드에 표시하기 위해 문자열로 변환하여 전달
                    countText: state.q3_count.toString(),
                    onFreqChanged: (v) => setState(() => state.q3_bp_measurement_frequency = v),
                    // 입력받은 문자열을 다시 숫자로 변환하여 저장 (안전하게 tryParse 사용)
                    onCountChanged: (v) => setState(() {
                      state.q3_count = double.tryParse(v) ?? 0.0;
                    }),
                  ),
              ],
            ),


            //교육 경험
            _buildExpansionSection(
              title: "3. 교육 경험",
              index: 2,
              children: [
                //q4
                _buildYesOrNoQuestion(
                  title: "고혈압, 당뇨병, 고지혈증(이상지질혈증) 등 만성질환 관련 교육을 받은 적이 있습니까?",
                  groupValue: state.has_education,
                  onChanged: (val) => setState(() => state.has_education = val!),
                ),
              ],
            ),

            _buildExpansionSection(
              title: "4. 흡연 및 음주",
              index: 3,
              children: [
                //q5
                _buildDynamicQuestion<String>(
                  question: "지금까지 살아오는 동안 피운 담배의 양은 총 얼마나 됩니까?",
                  // 현재 상태를 기반으로 어떤 라디오가 체크될지 결정
                  groupValue: state.no_smoke
                      ? "never"
                      : (state.ever_smoked_over_5packs ? "over_5" : "under_5"),
                    options: [
                    {"title": "5갑(100 개비) 미만", "value": "under_5"},
                    {"title": "5갑(100 개비) 이상", "value": "over_5"},
                    {"title": "피워본 적이 없다", "value": "never"},
                  ],
                  onChanged: (val) {
                    setState(() {
                      if (val == "never") {
                        state.no_smoke = true;
                        state.ever_smoked_over_5packs = false;
                      } else if (val == "over_5") {
                        state.no_smoke = false;
                        state.ever_smoked_over_5packs = true;
                      } else {
                        state.no_smoke = false;
                        state.ever_smoked_over_5packs = false;
                      }
                    });
                  },
                ),// 5-2 & 5-3 조건부 노출 (매일 또는 가끔 피우는 경우)
                if (state.current_stauts == "daily" || state.current_stauts == "sometimes") ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("현재 피우시는 담배의 종류는 무엇입니까? (중복 선택 가능)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  _buildSmokingTypeCheckboxes(), // 담배 종류 체크박스 리스트

                  const Divider(),

                  _buildSmokingDetailInput(), // 5-3 흡연량 및 기간 입력 필드
                ],
                // 6. 금연 계획 (현재 흡연자에게만 노출)
                if (state.current_stauts == "daily" || state.current_stauts == "sometimes")
                  _buildDynamicQuestion<String>(
                    question: "앞으로 담배를 끊을 계획이 있습니까?",
                    groupValue: state.q6_quit_intention,
                    options: [
                      {"title": "현재로서는 전혀 금연할 생각이 없다.", "value": "none"},
                      {"title": "1개월 안에 금연할 계획이 있다.", "value": "within_1m"},
                      {"title": "6개월 안에 금연할 계획이 있다.", "value": "within_6m"},
                      {"title": "언젠가는 금연할 생각이 있다.", "value": "someday"},
                    ],
                    onChanged: (val) => setState(() => state.q6_quit_intention = val!),
                  ),

                const Divider(),
                //q7
                _buildDynamicQuestion<bool>(
                  question: "최근 6개월 동안의 음주 경험으로 볼 때, 술을 얼마나 자주 마십니까? 또 한번에 얼마나 마십니까?",
                  groupValue: state.drank,
                  options: [
                    {"title": "마시고 있다.", "value": true},
                    {"title": "최근 6개월 동안 전혀 마시지 않았다..", "value": false},
                  ],
                  onChanged: (val) => setState(() => state.drank = val!),
                ),
                // ⭐ 조건부 생성: '마시고 있다' 선택 시 음주 상세 질문 노출
                if (state.drank) _buildAlcoholDetailSection(),
              ],
            ),

            _buildExpansionSection(
              title: "5. 신체활동",
              index: 4,
              children: [
                //q8
                _buildDynamicQuestion<String>(
                  question: "최근 6개월 전과 비교해 보았을 때 몸무게에 변화가 있었습니까? 몸무게가 줄거나 늘었다면 어느 정도였습니까?",
                  groupValue: state.status,
                  options: [
                    {"title": "변화가 없었다(0kg 이상 ~ 3kg 미만 증가 및 감소 포함)", "value": ""},
                    {"title": "몸무게가 줄었다.", "value": "loss"},
                    {"title": "몸무게가 늘었다.", "value": "gain"},
                  ],
                  onChanged: (val) => setState(() => state.status = val!),
                ),

              ],
            ),

            _buildExpansionSection(
              title: "6. 비만 및 체중조절",
              index: 5,
              children: [
                //q10
                _buildDynamicQuestion<String>(
                  question: "최근 6개월 전과 비교해 보았을 때 몸무게에 변화가 있었습니까? 몸무게가 줄거나 늘었다면 어느 정도였습니까?",
                  groupValue: state.status,
                  options: [
                    {"title": "변화가 없었다(0kg 이상 ~ 3kg 미만 증가 및 감소 포함)", "value": ""},
                    {"title": "몸무게가 줄었다.", "value": "loss"},
                    {"title": "몸무게가 늘었다.", "value": "gain"},
                  ],
                  onChanged: (val) => setState(() => state.status = val!),
                ),
                //q11
                _buildDynamicQuestion<String>(
                  question: "현재 본인의 체형이 어떻다고 생각하십니까?",
                  groupValue: state.q11_self_body_image,
                  options: [
                    {"title": "매우 마른 편이다", "value": "very_thin"},
                    {"title": "약간 마른 편이다", "value": "slightly_thin"},
                    {"title": "보통이다", "value": "normal"},
                    {"title": "약간 비만이다", "value": "slightly_obese"},
                    {"title": "매우 비만이다", "value": "very_obese"},
                  ],
                  onChanged: (val) => setState(() => state.q11_self_body_image = val!),
                ),
                //q12
                _buildDynamicQuestion<String>(
                  question: "최근 6개월 동안 몸무게를 조절하려고 노력한 적이 있습니까?",
                  groupValue: state.q12_weight_control_effort,
                  options: [
                    {"title": "몸무게를 줄이려고 노력했다", "value": "lose"},
                    {"title": "몸무게를 유지하려고 노력했다", "value": "maintain"},
                    {"title": "몸무게를 늘리려고 노력했다", "value": "gain"},
                    {"title": "몸무게를 조절하기 우해 노력해 본 적 없다", "value": "none"},
                  ],
                  onChanged: (val) => setState(() => state.q12_weight_control_effort = val!),
                ),

              ],
            ),

            _buildExpansionSection(
              title: "7. 식습관",
              index: 6,
              children: [
                //q13
                _buildDynamicQuestion<int>(
                  question: "최근 6개월 동안 아침식사를 일주일에 몇 회 하셨습니까?",
                  groupValue: state.q13_breakfast_frequency_per_week,
                  options: [
                    {"title": "주 5~7회", "value": 5},
                    {"title": "주 3~4회", "value": 3},
                    {"title": "주 1~2회", "value": 1},
                    {"title": "거의 안한다(주 0회)", "value": 0},
                  ],
                  onChanged: (val) => setState(() => state.q13_breakfast_frequency_per_week = val!),
                ),
                //q14
                _buildDynamicQuestion<String>(
                  question: "현재 본인의 체형이 어떻다고 생각하십니까?",
                  groupValue: state.q15_why_poor_diet,
                  options: [
                    {"title": "경제적으로 힘들어서", "value": "economic"},
                    {"title": "식사준비를 도와주는 사람이 없어서", "value": "no_helper"},
                    {"title": "의지가 약해서", "value": "low_will"},
                    {"title": "치아결손 등의 문제로 씹기가 힘들어서", "value": "chewing_problem"},
                    {"title": "영양정보를 몰라서", "value": "lack_info"},
                    {"title": "입맛(식욕)이 없어서", "value": "low_appetite"},
                    {"title": "기타", "value": "other"},
                  ],
                  onChanged: (val) => setState(() => state.q15_why_poor_diet = val!),
                ),
                //q15
                _buildDynamicQuestion<String>(
                  question: "최근 6개월 동안 몸무게를 조절하려고 노력한 적이 있습니까?",
                  groupValue: state.q12_weight_control_effort,
                  options: [
                    {"title": "몸무게를 줄이려고 노력했다", "value": "lose"},
                    {"title": "몸무게를 유지하려고 노력했다", "value": "maintain"},
                    {"title": "몸무게를 늘리려고 노력했다", "value": "gain"},
                    {"title": "몸무게를 조절하기 우해 노력해 본 적 없다", "value": "none"},
                  ],
                  onChanged: (val) => setState(() => state.q12_weight_control_effort = val!),
                ),
              ],
            ),

            _buildExpansionSection(
              title: "8. 정신건강",
              index: 7,
              children: [
                //q16
                _buildDynamicQuestion<int>(
                  question: "하루에 보통 몇 시간 주무십니까?",
                  groupValue: state.q13_breakfast_frequency_per_week,
                  options: [
                    {"title": "주 5~7회", "value": 5},
                    {"title": "주 3~4회", "value": 3},
                    {"title": "주 1~2회", "value": 1},
                    {"title": "거의 안한다(주 0회)", "value": 0},
                  ],
                  onChanged: (val) => setState(() => state.q13_breakfast_frequency_per_week = val!),
                ),
                //q17
                _buildDynamicQuestion<String>(
                  question: "최근 2주일 동안 자신에게 해당된다고 생각하는 곳에 체크해주세요?",
                  groupValue: state.q15_why_poor_diet,
                  options: [
                    {"title": "경제적으로 힘들어서", "value": "economic"},
                    {"title": "식사준비를 도와주는 사람이 없어서", "value": "no_helper"},
                    {"title": "의지가 약해서", "value": "low_will"},
                    {"title": "치아결손 등의 문제로 씹기가 힘들어서", "value": "chewing_problem"},
                    {"title": "영양정보를 몰라서", "value": "lack_info"},
                    {"title": "입맛(식욕)이 없어서", "value": "low_appetite"},
                    {"title": "기타", "value": "other"},
                  ],
                  onChanged: (val) => setState(() => state.q15_why_poor_diet = val!),
                ),
              ],
            ),


            //demographies
            _buildExpansionSection(
              title: "9. 일반정보(선택적 기재 사항)",
              index: 8,
              children: [
                //marry    
                _buildDynamicQuestion<String>(
                  question: "혼인상태가 어떻게 되십니까?",
                  groupValue: state.marry,
                  options: [
                    {"title": "기혼(배우자 유)", "value": "married_with_spouse"},
                    {"title": "기혼(배우자 무)", "value": "married_no_spouse"},
                    {"title": "미혼", "value": "single"},
                    {"title": "무응답", "value": "no_answer"},
                  ],
                  onChanged: (val) => setState(() => state.marry = val!),
                ),
                //household_size
                _buildDynamicQuestion<int>(
                  question: "현재 살고 계신 댁에 본인을 포함하여 총 몇 명이서 살고 계십니까?",
                  groupValue: state.household_size,
                  options: [
                    {"title": "1인", "value": 1},
                    {"title": "2인", "value": 2},
                    {"title": "3인", "value": 3},
                    {"title": "4인 이상", "value": 4},
                    {"title": "무응답", "value": 0},
                  ],
                  onChanged: (val) => setState(() => state.household_size = val!),
                ),
                //insurance_type
                _buildDynamicQuestion<String>(
                  question: "건강보험 가입형태가 어떻게 되십니까?",
                  groupValue: state.insurance_type,
                  options: [
                    {"title": "건강보험(지역/직장)", "value": "nhis"},
                    {"title": "의료급여(1종/2종)", "value": "medical_aid"},
                    {"title": "미가입", "value": "none"},
                    {"title": "무응답", "value": "no_answer"},
                  ],
                  onChanged: (val) => setState(() => state.insurance_type = val!),
                ),
                //education_level
                _buildDynamicQuestion<String>(
                  question: "최종학력이 어떻게 되십니까?",
                  groupValue: state.education_level,
                  options: [
                    {"title": "초등학교 졸업 이하", "value": "primary_or_less"},
                    {"title": "중학교 졸업", "value": "middle"},
                    {"title": "고등학교 졸업", "value": "high_school"},
                    {"title": "대학(전문대) 졸업 이상", "value": "college_or_more"},
                    {"title": "무응답", "value": "no_answer"},
                  ],
                  onChanged: (val) => setState(() => state.education_level = val!),
                ),
                //monthly_household_income
                _buildDynamicQuestion<int>(
                  question: "현재 월 가구소득은 어떻게 되십니까?",
                  groupValue: state.monthly_household_income,
                  options: [
                    {"title": "200만원 미만", "value": 200},
                    {"title": "200~400만원 미만", "value": 300},
                    {"title": "400~600만원 미만", "value": 500},
                    {"title": "600만원 이상", "value": 600},
                    {"title": "무응답", "value": 0},
                  ],
                  onChanged: (val) => setState(() => state.monthly_household_income = val!),
                ),
              ],
            ),



            //식습관
            _buildExpansionSection(
              title: "최근 6개월 동안 아침식사를 일주일에 몇 회 하셨습니까?",
              index: 9,
              children: [
                _buildDietCheckbox("곡류를 다양하게 섭취합니까?", state.grain_diversity, (v) => state.grain_diversity = v!),
                _buildDietCheckbox("채소를 매끼 2가지 이상 먹습니까?", state.vegetable_variety, (v) => state.vegetable_variety = v!),
                _buildDietCheckbox("제철 과일을 매일 먹습니까?", state.daily_fruit, (v) => state.daily_fruit = v!),
                _buildDietCheckbox("유제품을 매일 마십니까?", state.daily_dairy, (v) => state.daily_dairy = v!),
                _buildDietCheckbox("싱겁게 먹습니까? (국물 적게)", state.low_salt, (v) => state.low_salt = v!),
              ],
            ),

            const SizedBox(height: 30),

            // 제출 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: _submitData, // 서버로 데이터 전송
              child: const Text("설문 제출 및 서버 전송", style: TextStyle(color: Colors.white, fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }

  // --- 위젯 빌더 함수들 ---
  Widget _buildDynamicQuestion<T>({
    required String question,
    required T? groupValue,
    required List<Map<String, dynamic>> options, // [{ "title": "예", "value": 1 }, ...]
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          // options 리스트를 순회하며 라디오 버튼 생성
          ...options.map((option) {
            return RadioListTile<T>(
              title: Text(option['title']),
              value: option['value'] as T,
              groupValue: groupValue,
              onChanged: onChanged,
              dense: true,
              contentPadding: EdgeInsets.zero, // 왼쪽 여백 제거
            );
          }).toList(),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildExpansionSection({
    required int index,
    required String title,
    required List<Widget> children
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        // key를 부여하여 Flutter가 각 Tile의 상태를 명확히 구분하게 합니다.
        key: Key("expansion_$title"),
        // 현재 인덱스가 openedIndex와 같을 때만 펼쳐진 상태를 유지합니다.
        initiallyExpanded: index == openedIndex,
        // 현재 열려있는지 여부를 제어합니다.
        onExpansionChanged: (bool expanded) {
          setState(() {
            if (expanded) {
              // 새로 펼쳐지는 경우, 해당 인덱스를 저장
              openedIndex = index;
            } else {
              // 이미 펼쳐진 걸 닫는 경우
              if (openedIndex == index) {
                openedIndex = -1;
              }
            }
          });
        },
        title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        childrenPadding: const EdgeInsets.all(10),
        children: children,
      ),
    );
  }

  Widget _buildDiseaseList() {
    final diseaseOptions = ["고혈압", "당뇨병", "이상지질혈증", "뇌졸중", "관상동맥질환", "만성콩팥병"];

    return Column(
      children: diseaseOptions.map((name) {
        // 해당 질환이 리스트에 있는지 확인
        int diseaseIndex = state.diseaseHistory.indexWhere((d) => d.disease_code == name);
        bool isSelected = diseaseIndex != -1;

        return Column(
          children: [
            CheckboxListTile(
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              value: isSelected,
              onChanged: (bool? checked) {
                setState(() {
                  if (checked == true) {
                    // 체크 시 객체 추가
                    state.diseaseHistory.add(DiseaseHistory(disease_code: name, doctor_diagnosed: true));
                  } else {
                    // 체크 해제 시 삭제
                    state.diseaseHistory.removeWhere((d) => d.disease_code == name);
                  }
                });
              },
            ),
            // [핵심] 선택되었을 때만 상세 항목 노출
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
                child: Column(
                  children: [
                    // 각 항목을 체크박스로 변경
                    _buildSubDetailCheckbox("의사 진단 여부", state.diseaseHistory[diseaseIndex].doctor_diagnosed, (v) {
                      setState(() => state.diseaseHistory[diseaseIndex].doctor_diagnosed = v!);
                    }),
                    _buildSubDetailCheckbox("약물 처방 여부", state.diseaseHistory[diseaseIndex].has_prescription, (v) {
                      setState(() => state.diseaseHistory[diseaseIndex].has_prescription = v!);
                    }),
                    _buildSubDetailCheckbox("약 복용 여부", state.diseaseHistory[diseaseIndex].med_intake, (v) {
                      setState(() => state.diseaseHistory[diseaseIndex].med_intake = v!);
                    }),
                    _buildSubDetailCheckbox("규칙적 복용(월 20일 이상)", state.diseaseHistory[diseaseIndex].regular_med_intake, (v) {
                      setState(() => state.diseaseHistory[diseaseIndex].regular_med_intake = v!);
                    }),

                    // 유병 기간 레이블 색상 변경
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            "유병 기간: ",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60, // 입력창 너비
                            child: TextFormField(
                              keyboardType: TextInputType.number, // 숫자 키패드 노출
                              initialValue: state.diseaseHistory[diseaseIndex].duration_years.toInt().toString(),
                              style: const TextStyle(color: Colors.black), // 입력 글자 검은색
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 2),
                                ),
                              ),
                              onChanged: (v) {
                                setState(() {
                                  state.diseaseHistory[diseaseIndex].duration_years = double.tryParse(v) ?? 0;
                                });
                              },
                            ),
                          ),
                          const Text(
                            " 년",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSubDetailCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 15), // 검은색 텍스트
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading, // 체크박스를 왼쪽으로 배치
      contentPadding: EdgeInsets.zero, // 여백 조절
      dense: true, // 크기를 조금 더 콤팩트하게
      activeColor: Colors.blue, // 체크되었을 때의 색상
    );
  }

  Widget _buildOtherDiseaseInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          labelText: "기타 질환이 있으면 병명을 입력하세요.(갑상선, 간질환 등)",
          labelStyle: TextStyle(fontSize: 12),
          border: OutlineInputBorder(),
        ),
        onChanged: (val) {
          int idx = state.diseaseHistory.indexWhere((d) => d.disease_code == "기타질환");
          if (idx != -1) state.diseaseHistory[idx].name = val;
        },
      ),
    );
  }


  // 2, 3번 추가 질문 필드 (측정 빈도 및 횟수) 수정 버전
  Widget _buildKnowledgeExtraFields({
    required String freqValue,
    required String countText,
    required Function(String) onFreqChanged,
    required Function(String) onCountChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("최근 측정을 하셨습니까?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),

          // 핵심 수정 부분: Wrap 위젯을 사용하여 오버플로우 방지
          Wrap(
            spacing: 10, // 항목 간 가로 간격
            runSpacing: 5, // 줄바꿈 시 세로 간격
            children: ["매일 혹은 매주", "매월", "가끔"].map((label) {
              return InkWell(
                onTap: () => onFreqChanged(label),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: label,
                      groupValue: freqValue,
                      onChanged: (v) => onFreqChanged(v!),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text(label, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // 측정 횟수 입력 레이아웃
          Row(
            children: [
              const Text("최근 측정 횟수 주/월/6개월: ", style: TextStyle(fontSize: 13)),
              const SizedBox(width: 10),
              SizedBox(
                width: 70,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    border: OutlineInputBorder(),
                    suffixText: "회",
                  ),
                  onChanged: onCountChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubDetailSwitch(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }

  // 5-2 담배 종류 체크박스
  Widget _buildSmokingTypeCheckboxes() {
    final types = [
      {"title": "일반담배(궐련)", "value": "normal"},
      {"title": "궐련형 전자담배(아이코스 등)", "value": "heat_not_burn"},
      {"title": "액상형 전자담배", "value": "liquid"},
      {"title": "기타", "value": "other"},
    ];
    return Column(
      children: types.map((t) {
        bool isSelected = state.current_types.contains(t['value']);
        return CheckboxListTile(
          title: Text(t['title']!, style: const TextStyle(fontSize: 14)),
          value: isSelected,
          onChanged: (bool? checked) {
            setState(() {
              if (checked == true) {
                state.current_types.add(t['value']!);
              } else {
                state.current_types.remove(t['value']);
              }
            });
          },
          dense: true,
        );
      }).toList(),
    );
  }

// 5-3 흡연 세부 정보 입력 필드
  Widget _buildSmokingDetailInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("평균 흡연량 및 흡연기간", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("하루 평균 "),
              SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (v) => state.avg_cigs_per_day = int.tryParse(v) ?? 0,
                  decoration: const InputDecoration(isDense: true),
                ),
              ),
              const Text(" 개비 / 총 "),
              SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (v) => state.smoking_years = int.tryParse(v) ?? 0,
                  decoration: const InputDecoration(isDense: true),
                ),
              ),
              const Text(" 년간"),
            ],
          ),
          if (state.current_stauts == "sometimes") ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("최근 1달간 "),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) => state.avg_cigs_per_month = int.tryParse(v) ?? 0,
                    decoration: const InputDecoration(isDense: true),
                  ),
                ),
                const Text(" 일 흡연"),
              ],
            ),
          ]
        ],
      ),
    );
  }

  // 7. 음주 상세 정보 (빈도 및 주량)
  Widget _buildAlcoholDetailSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("7-1. 음주 횟수 (최근 6개월)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Wrap(
            children: [
              "한 달에 1번 미만", "한 달에 1번 정도", "한 달에 2~4번 정도",
              "일주일에 2~3번 정도", "일주일에 4번 이상"
            ].map((f) => SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: CheckboxListTile(
                title: Text(f, style: const TextStyle(fontSize: 12)),
                value: state.frequency == f,
                onChanged: (v) => setState(() => state.frequency = f),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
            )).toList(),
          ),
          const Divider(),
          const Text("7-2. 한 번에 마시는 음주량", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Wrap(
            children: [
              "1~2잔", "3~4잔", "5~6잔", "7~9잔", "10잔 이상"
            ].map((a) => SizedBox(
              width: MediaQuery.of(context).size.width * 0.28,
              child: CheckboxListTile(
                title: Text(a, style: const TextStyle(fontSize: 12)),
                value: state.amount_per_occasion_glasses.toString() == a, // 단순 매칭 예시
                onChanged: (v) => setState(() {
                  // 실제 state에는 숫자로 저장되도록 로직 추가 필요
                }),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
  // 공통 숫자 입력 필드
  Widget _buildSmallField(Function(String) onChanged, String suffix) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
            onChanged: onChanged,
          ),
        ),
        Text(" $suffix"),
      ],
    );
  }

  Widget _buildRadioQuestion({required String title, required int groupValue, required ValueChanged<int?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(title)),
        RadioListTile<int>(title: const Text("알고 있다"), value: 1, groupValue: groupValue, onChanged: onChanged),
        RadioListTile<int>(title: const Text("대략 안다"), value: 2, groupValue: groupValue, onChanged: onChanged),
        RadioListTile<int>(title: const Text("모른다"), value: 3, groupValue: groupValue, onChanged: onChanged),
      ],
    );
  }

  Widget _buildYesOrNoQuestion({required String title, required bool? groupValue, required ValueChanged<bool?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8), child: Text(title)),
        RadioListTile<bool>(title: const Text("예"), value: true, groupValue: groupValue, onChanged: onChanged),
        RadioListTile<bool>(title: const Text("아니요"), value: false, groupValue: groupValue, onChanged: onChanged),
      ],
    );
  }

  Widget _buildDietCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }
}
