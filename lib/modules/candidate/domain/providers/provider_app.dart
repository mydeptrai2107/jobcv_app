import 'package:app/modules/candidate/data/models/hive_models/experience_model.dart';
import 'package:app/modules/candidate/data/models/hive_models/school_model.dart';
import 'package:app/modules/candidate/data/models/hive_models/skill_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProviderApp with ChangeNotifier {
  final _experience = Hive.box<ExperienceModel>('Experience');
  final _school = Hive.box<SchoolModel>('School');
  final _skill = Hive.box<SkillModel>('skill');

  List<ExperienceModel> _listExperience = [];
  List<SchoolModel> _listSchool = [];
  List<SkillModel> _listSkill = [];

  List<ExperienceModel> get listExperience =>
      _listExperience.isEmpty ? _experience.values.toList() : _listExperience;

  void fetchAllExperience() {
    _listExperience = _experience.values.toList();
    notifyListeners();
  }

  List<SchoolModel> get listSchool =>
      _listSchool.isEmpty ? _school.values.toList() : _listSchool;

  void fetchAllSchool() {
    _listSchool = _school.values.toList();
    notifyListeners();
  }

  List<SkillModel> get listSkill =>
      _listSkill.isEmpty ? _skill.values.toList() : _listSkill;

  void fetchAllSkill() {
    _listSkill = _skill.values.toList();
    notifyListeners();
  }
}
