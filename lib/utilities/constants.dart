import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:corefit_academy/models/muscle.dart';

TextStyle coreFitTextStyle = GoogleFonts.roboto(
    textStyle: const TextStyle(
  fontSize: 30.0,
));
const kErrorMessageStyle = TextStyle(fontSize: 12.0, color: Colors.red);
const kTitleStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);

const String kAppName = 'CoreFit Academy';

const kGoogleProvider = 'google.com';

const String kCoursePageName = 'Courses';
const String kHomePageName = 'Home';
const String kLogbookPageName = 'Logbook';
const String kSettingsPageName = 'Settings';

const String kThemeSettingsName = 'Themes';
const String kThemeLightName = 'Light';
const String kThemeDarkName = 'Dark';

const String kAddFriendsToCourseAction = 'Add Friends To Course';
const String kDeleteCourseAction = 'Delete Course';
const String kDeleteWorkoutAction = 'Delete Workout';
const String kDeleteExerciseAction = 'Delete Exercise';
const String kDeleteWorkoutLogAction = 'Delete Workout Log';
const String kDeleteExerciseLogAction = 'Delete Exercise Log';
const String kSkipExerciseLogAction = 'Skip Exercise Log';
const String kRemoveCourseAction = 'Remove Course';
const String kCloneCourseAction = 'Clone Course';
const String kCreateCourseAction = 'Create New Course';
const String kCreateWorkoutAction = 'Create New Workout';
const String kCreateExerciseAction = 'Create New Exercise';
const String kSeeLogbookAction = 'See Logbook';
const String kLogExerciseTitle = 'Log Exercise';
const String kSetTimeAction = 'Set Time';

const String kCreateCourseActionButton = 'Create Course';
const String kCreateExerciseActionButton = 'Create Exercise';
const String kCreateWorkoutActionButton = 'Create Workout';
const String kLogWorkoutActionButton = 'Log Workout';

const String kCourseNameFieldLabel = 'Course Name';
const String kWorkoutNameFieldLabel = 'Workout Name';
const String kExerciseNameFieldLabel = 'Exercise Name';

const String kSelectCourseToLogFromInstruction =
    "Select a Course to Log a Workout From";
const String kSelectWorkoutToLogFromInstruction = "Select a Workout to Log";

const String kRepsNameFieldLabel = "Reps";
const String kREPNameFieldLabel = "RPE";
const String kSetsNameFieldLabel = "Sets";
const String kDistanceKMNameFieldLabel = "Distance (KM)";
const String kWeightKGNameFieldLabel = "Weight (KG)";
const String kPercentageOfExertionNameFieldLabel = "Percentage of Exertion (%)";

const String kErrorEnterValidEmailString = 'Enter a valid email address!';
const String kErrorEnterValidIntString = 'Enter a valid number!';
const String kErrorUserNotFound = 'User not found!';
const String kErrorOwnerCannotBeAViewer = 'You already own the course!';
const String kErrorEnterValidNameString = 'Enter a valid name!';
const String kErrorNoWorkoutsFoundString = "No Workouts Found for this Course!";
const String kErrorNoLoggedExercisesFoundString =
    "No Logged Exercises were found!";
const String kErrorNoCoursesFoundString =
    "No Courses Found, Please Create a Course!";
const String kErrorNoExercisesFoundString =
    "No Exercises Found for this Workout!";
const String kEmailOfFriendString = 'Email of Friend';
const String kNewCourseNameString = 'New Course Name';

const String kSelectedCourse = "Selected Course: ";
const String kSelectedWorkout = "Selected Workout: ";
const String kErrorNoWorkoutLoggedThisWeek =
    "No Workouts have been Logged this Week!";
const String kErrorSelectedWorkoutNoExercisesString =
    "Selected Workout currently has no Exercises!";

const String kUsersCollection = 'users';
const String kCoursesCollection = 'courses';
const String kWorkoutsCollection = 'workouts';
const String kExercisesCollection = 'exercises';
const String kLogExerciseCollection = 'exerciseLog';
const String kLogWorkoutCollection = 'workoutLog';

const String kRpeField = 'RPE';
const String kWorkoutLogIdField = 'workoutLogId';
const String kWorkoutNameField = 'workoutName';
const String kCourseNameField = 'courseName';
const String kTargetRpeField = 'targetRPE';
const String kSetsField = 'sets';
const String kTargetSetsField = 'targetSets';
const String kRepsField = 'reps';
const String kTargetRepsField = 'targetReps';
const String kNameField = 'name';
const String kEmailField = 'email';
const String kUserIdField = 'userId';
const String kViewersField = 'viewers';
const String kWeightKgField = 'weightKg';
const String kTargetWeightKgField = 'targetWeightKg';
const String kWorkoutsField = 'workouts';
const String kCreatedAtField = 'createdAt';
const String kTimeHoursField = 'timeHours';
const String kTargetTimeHoursField = 'targetTimeHours';
const String kExercisesField = 'exercises';
const String kExerciseLogsField = 'exerciseLogs';
const String kWorkoutLogField = 'workoutLog';
const String kDistanceKmField = 'distanceKm';
const String kTargetDistanceKmField = 'targetDistanceKm';
const String kTimeMinutesField = 'timeMinutes';
const String kTargetTimeMinutesField = 'targetTimeMinutes';
const String kTimeSecondsField = 'timeSeconds';
const String kTargetTimeSecondsField = 'targetTimeSeconds';
const String kParentCourseField = 'parentCourse';
const String kParentWorkoutField = 'parentWorkout';
const String kTargetedMusclesField = 'targetedMuscles';
const String kTargetedMuscleGroupsIdsField = 'targetedMuscleGroupsIds';
const String kMuscleNameField = 'muscleName';
const String kMuscleGroupIndexField = 'muscleGroupIndex';
const String kTargetedMuscleGroupField = 'targetedMuscleGroup';
const String kTargetPercentageOfExertionField = 'targetPercentageOfExertion';
const String kPercentageOfExertionField = 'percentageOfExertion';
const String kExerciseReferenceField = 'exerciseReference';

const String kAddFriend = 'Add Friend';
const String kAddLogAction = 'Add Log';
const String kCancel = 'Cancel';
const String kDelete = 'Delete';
const String kRemove = 'Remove';
const String kPleaseSelectString = 'Please Select!';

const String kShowNumberExercisesForWorkout =
    "Number of Exercises in Workout: ";
const String kShowNumberExercisesForMuscleGroup =
    "Number of Exercises in Muscle Group: ";
const String kShowNumberExercisesLoggedForWorkout =
    "Number of Logged Exercises in Workout: ";
const String kShowNumberViewersForWorkout = "Number of Viewers in Workout: ";
const String kShowNumberWorkoutsForCourse = "Number of Workouts in Course: ";
const String kShowNumberViewersForCourse = "Number of Viewers in Course: ";

const String kSelectMuscleGroupTitle = "Select Muscle Group";
const String kSelectTargetedMusclesTitle = "Select Muscles";
const String kSetMuscleGroupTitle = "Set Muscle Group";
const String kSetTargetedMusclesTitle = "Set Targeted Muscles";

const List<String> kTargetMuscleGroupsNames = [
  "Chest",
  "Back",
  "Arms",
  "Shoulders",
  "Legs",
  "Calves",
  "Core"
];
enum MuscleGroup { chest, back, arms, shoulders, legs, calves, core }

List<Muscle> kChestMuscles = [
  Muscle(muscleName: "Pectoralis major", muscleGroup: MuscleGroup.chest),
  Muscle(muscleName: "Pectoralis minor", muscleGroup: MuscleGroup.chest),
  Muscle(muscleName: "Serratus anterior", muscleGroup: MuscleGroup.chest),
  Muscle(muscleName: "Subclavius", muscleGroup: MuscleGroup.chest),
];

List<Muscle> kBackMuscles = [
  Muscle(muscleName: "Trapezius", muscleGroup: MuscleGroup.back),
  Muscle(muscleName: "Latissimus dorsi", muscleGroup: MuscleGroup.back),
  Muscle(muscleName: "Levator scapulae", muscleGroup: MuscleGroup.back),
  Muscle(muscleName: "Rhomboid major", muscleGroup: MuscleGroup.back),
  Muscle(muscleName: "Rhomboid minor", muscleGroup: MuscleGroup.back),
  Muscle(
      muscleName: "Serratus posterior superior", muscleGroup: MuscleGroup.back),
  Muscle(
      muscleName: "Serratus posterior inferior", muscleGroup: MuscleGroup.back),
];

List<Muscle> kArmsMuscles = [
  Muscle(muscleName: "Biceps brachii", muscleGroup: MuscleGroup.arms),
  Muscle(muscleName: "Coracobrachialis", muscleGroup: MuscleGroup.arms),
  Muscle(muscleName: "Brachialis", muscleGroup: MuscleGroup.arms),
  Muscle(muscleName: "Triceps brachii", muscleGroup: MuscleGroup.arms),
];

List<Muscle> kShouldersMuscles = [
  Muscle(muscleName: "Pectoralis major", muscleGroup: MuscleGroup.shoulders),
  Muscle(muscleName: "Pectoralis minor", muscleGroup: MuscleGroup.shoulders),
  Muscle(
      muscleName: "Posterior shoulder muscles",
      muscleGroup: MuscleGroup.shoulders),
  Muscle(muscleName: "Deltoids", muscleGroup: MuscleGroup.shoulders),
  Muscle(
      muscleName: "Rotator cuff muscles", muscleGroup: MuscleGroup.shoulders),
];

List<Muscle> kLegsMuscles = [
  Muscle(muscleName: "Rectus Femoris", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Vastus Lateralis", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Vastus Intermedius", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Vastus Medialis", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Biceps Femoris", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Semimembranosus", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Semitendinosus", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Gluteus Minimus", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Gluteus Medius", muscleGroup: MuscleGroup.legs),
  Muscle(muscleName: "Gluteus Maximus", muscleGroup: MuscleGroup.legs),
];

List<Muscle> kCalvesMuscles = [
  Muscle(muscleName: "Gastrocnemius", muscleGroup: MuscleGroup.calves),
  Muscle(muscleName: "Soleus", muscleGroup: MuscleGroup.calves),
];

List<Muscle> kCoreMuscles = [
  Muscle(muscleName: "Abs", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "Transverse Abdominis", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "Multifidus", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "External Obliques", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "Internal Obliques", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "Erector Spinae", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "Diaphragm", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "Pelvic Floor Muscles", muscleGroup: MuscleGroup.core),
  Muscle(muscleName: "Rectus Abdominis", muscleGroup: MuscleGroup.core),
];

List<List<Muscle>> kMusclesList = [
  kChestMuscles,
  kBackMuscles,
  kArmsMuscles,
  kShouldersMuscles,
  kLegsMuscles,
  kCalvesMuscles,
  kCoreMuscles,
];
