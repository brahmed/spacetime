import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import 'package:ui/ui.dart';

import '../bloc/courses_bloc.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesBloc(
        courseRepository: context.read<CourseRepository>(),
        profileRepository: context.read<ProfileRepository>(),
        supabase: Supabase.instance.client,
      )..add(const CoursesLoaded()),
      child: const _CoursesView(),
    );
  }
}

class _CoursesView extends StatelessWidget {
  const _CoursesView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.courseSaved)),
          );
        } else if (state is CoursesSaveFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        } else if (state is CoursesSessionsGenerated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.sessionsGenerated)),
          );
        } else if (state is CoursesSessionsGenerateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.courses),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Sizes.p16),
              child: FilledButton.icon(
                onPressed: () => _openCourseDrawer(context, course: null),
                icon: const Icon(Icons.add),
                label: Text(l10n.createCourse),
              ),
            ),
          ],
        ),
        body: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            return switch (state) {
              CoursesInitial() || CoursesLoading() =>
                const Center(child: CircularProgressIndicator()),
              CoursesFailure() => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Sizes.p16,
                    children: [
                      Text(l10n.somethingWentWrong),
                      TextButton(
                        onPressed: () => context
                            .read<CoursesBloc>()
                            .add(const CoursesLoaded()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              CoursesSuccess(:final courses, :final teachers) =>
                _CoursesList(courses: courses, teachers: teachers),
            };
          },
        ),
      ),
    );
  }

  void _openCourseDrawer(BuildContext context, {required Course? course}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<CoursesBloc>(),
        child: _CourseDrawer(course: course),
      ),
    );
  }
}

class _CoursesList extends StatelessWidget {
  const _CoursesList({required this.courses, required this.teachers});

  final List<Course> courses;
  final List<Profile> teachers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (courses.isEmpty) {
      return Center(
        child: Text(
          l10n.noCourses,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).appColors.textMuted,
              ),
        ),
      );
    }

    final teacherById = {for (final t in teachers) t.id: t};

    return ListView.separated(
      padding: const EdgeInsets.all(Sizes.p24),
      itemCount: courses.length,
      separatorBuilder: (_, _) => const SizedBox(height: Sizes.p8),
      itemBuilder: (context, index) {
        final course = courses[index];
        final teacher = course.teacherId != null
            ? teacherById[course.teacherId]
            : null;
        return _CourseRow(course: course, teacher: teacher);
      },
    );
  }
}

class _CourseRow extends StatelessWidget {
  const _CourseRow({required this.course, required this.teacher});

  final Course course;
  final Profile? teacher;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (course.discipline != null) ...[
              const SizedBox(height: Sizes.p4),
              Text(
                course.discipline!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
              ),
            ],
            const SizedBox(height: Sizes.p8),
            Row(
              children: [
                if (course.room != null) ...[
                  _Chip(
                    icon: Icons.room_outlined,
                    label: course.room!,
                  ),
                  const SizedBox(width: Sizes.p16),
                ],
                if (teacher != null) ...[
                  _Chip(
                    icon: Icons.person_outline,
                    label: teacher!.fullName,
                  ),
                  const SizedBox(width: Sizes.p16),
                ],
                _Chip(
                  icon: Icons.schedule_outlined,
                  label: course.recurrenceTime,
                ),
              ],
            ),
            const SizedBox(height: Sizes.p8),
            Row(
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                  ),
                  onPressed: () => context.go('/sessions/${course.id}'),
                  icon: const Icon(Icons.calendar_month_outlined, size: 16),
                  label: Text(l10n.navSessions),
                ),
                const SizedBox(width: Sizes.p8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                  ),
                  onPressed: () {
                    context
                        .read<CoursesBloc>()
                        .add(CourseSessionsGenerated(courseId: course.id));
                  },
                  icon: const Icon(Icons.auto_awesome_outlined, size: 16),
                  label: Text(l10n.generateSessions),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: l10n.editCourse,
                  onPressed: () => _openEditDrawer(context, course),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openEditDrawer(BuildContext context, Course course) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<CoursesBloc>(),
        child: _CourseDrawer(course: course),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Sizes.p4,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).appColors.textMuted),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).appColors.textMuted,
              ),
        ),
      ],
    );
  }
}

class _CourseDrawer extends StatefulWidget {
  const _CourseDrawer({required this.course});

  final Course? course;

  @override
  State<_CourseDrawer> createState() => _CourseDrawerState();
}

class _CourseDrawerState extends State<_CourseDrawer> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _disciplineController;
  late final TextEditingController _roomController;
  late final TextEditingController _timeController;
  String? _selectedTeacherId;
  late List<int> _selectedDays;
  DateTime? _endsAt;

  static const _dayLabels = [
    (1, 'Mon'),
    (2, 'Tue'),
    (3, 'Wed'),
    (4, 'Thu'),
    (5, 'Fri'),
    (6, 'Sat'),
    (7, 'Sun'),
  ];

  @override
  void initState() {
    super.initState();
    final course = widget.course;
    _nameController = TextEditingController(text: course?.name);
    _disciplineController = TextEditingController(text: course?.discipline);
    _roomController = TextEditingController(text: course?.room);
    _timeController =
        TextEditingController(text: course?.recurrenceTime ?? '18:00');
    _selectedTeacherId = course?.teacherId;
    _selectedDays = List<int>.from(course?.recurrenceDays ?? [1]);
    _endsAt = course?.recurrenceEndsAt;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _disciplineController.dispose();
    _roomController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) return;

    final bloc = context.read<CoursesBloc>();
    if (widget.course == null) {
      bloc.add(CourseCreated(
        name: _nameController.text.trim(),
        discipline: _disciplineController.text.trim().isEmpty
            ? null
            : _disciplineController.text.trim(),
        room: _roomController.text.trim().isEmpty
            ? null
            : _roomController.text.trim(),
        teacherId: _selectedTeacherId,
        recurrenceDays: _selectedDays,
        recurrenceTime: _timeController.text.trim(),
        recurrenceEndsAt: _endsAt,
      ));
    } else {
      bloc.add(CourseUpdated(
        courseId: widget.course!.id,
        name: _nameController.text.trim(),
        discipline: _disciplineController.text.trim().isEmpty
            ? null
            : _disciplineController.text.trim(),
        room: _roomController.text.trim().isEmpty
            ? null
            : _roomController.text.trim(),
        teacherId: _selectedTeacherId,
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCreating = widget.course == null;
    final teachers = switch (context.read<CoursesBloc>().state) {
      CoursesSuccess(:final teachers) => teachers,
      _ => <Profile>[],
    };

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p24,
                Sizes.p16,
                Sizes.p24,
                0,
              ),
              child: Row(
                children: [
                  Text(
                    isCreating ? l10n.createCourse : l10n.editCourse,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(Sizes.p24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Sizes.p16,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: l10n.courseName),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? l10n.fieldRequired
                                : null,
                      ),
                      TextFormField(
                        controller: _disciplineController,
                        decoration: InputDecoration(labelText: l10n.discipline),
                      ),
                      TextFormField(
                        controller: _roomController,
                        decoration: InputDecoration(labelText: l10n.room),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedTeacherId,
                        decoration: InputDecoration(labelText: l10n.teacher),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.noneSelected),
                          ),
                          ...teachers.map(
                            (t) => DropdownMenuItem(
                              value: t.id,
                              child: Text(t.fullName),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedTeacherId = value),
                      ),
                      if (isCreating) ...[
                        Text(
                          l10n.recurrenceDays,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Wrap(
                          spacing: Sizes.p8,
                          children: _dayLabels.map((entry) {
                            final (day, label) = entry;
                            final selected = _selectedDays.contains(day);
                            return FilterChip(
                              label: Text(label),
                              selected: selected,
                              onSelected: (on) {
                                setState(() {
                                  if (on) {
                                    _selectedDays.add(day);
                                    _selectedDays.sort();
                                  } else {
                                    _selectedDays.remove(day);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          controller: _timeController,
                          decoration:
                              InputDecoration(labelText: l10n.recurrenceTime),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9:]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.fieldRequired;
                            }
                            final parts = value.split(':');
                            if (parts.length != 2) return l10n.fieldRequired;
                            return null;
                          },
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.recurrenceEndsAt),
                          subtitle: Text(
                            _endsAt != null
                                ? DateFormat.yMMMd().format(_endsAt!)
                                : l10n.noneSelected,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: const Icon(Icons.calendar_today_outlined),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _endsAt ??
                                  DateTime.now()
                                      .add(const Duration(days: 90)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 2)),
                            );
                            if (picked != null) {
                              setState(() => _endsAt = picked);
                            }
                          },
                        ),
                      ],
                      const SizedBox(height: Sizes.p8),
                      PrimaryButton(
                        onPressed: _submit,
                        label: l10n.saveChanges,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
