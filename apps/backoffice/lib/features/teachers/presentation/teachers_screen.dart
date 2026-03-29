import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import 'package:ui/ui.dart';

import '../../../common/widgets/show_alert_dialog.dart';
import '../bloc/teachers_bloc.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeachersBloc(
        profileRepository: context.read<ProfileRepository>(),
        courseRepository: context.read<CourseRepository>(),
        supabase: Supabase.instance.client,
      )..add(const TeachersLoaded()),
      child: const _TeachersView(),
    );
  }
}

class _TeachersView extends StatelessWidget {
  const _TeachersView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<TeachersBloc, TeachersState>(
      listener: (context, state) {
        if (state is TeacherCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.userCreated)),
          );
        } else if (state is TeacherCreateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        } else if (state is TeacherAssignSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.courseSaved)),
          );
        } else if (state is TeacherAssignFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        } else if (state is TeacherUnassignSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.courseSaved)),
          );
        } else if (state is TeacherUnassignFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.teachers),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Sizes.p16),
              child: FilledButton.icon(
                onPressed: () => _openCreateDrawer(context),
                icon: const Icon(Icons.person_add_outlined),
                label: Text(l10n.createTeacher),
              ),
            ),
          ],
        ),
        body: BlocBuilder<TeachersBloc, TeachersState>(
          builder: (context, state) {
            return switch (state) {
              TeachersInitial() || TeachersLoading() =>
                const Center(child: CircularProgressIndicator()),
              TeachersFailure() => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Sizes.p16,
                    children: [
                      Text(l10n.somethingWentWrong),
                      TextButton(
                        onPressed: () => context
                            .read<TeachersBloc>()
                            .add(const TeachersLoaded()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              TeachersSuccess(:final teachers, :final courses) =>
                teachers.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noTeachers,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).appColors.textMuted,
                              ),
                        ),
                      )
                    : _TeachersList(teachers: teachers, courses: courses),
            };
          },
        ),
      ),
    );
  }

  void _openCreateDrawer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<TeachersBloc>(),
        child: const _CreateTeacherDrawer(),
      ),
    );
  }
}

class _TeachersList extends StatelessWidget {
  const _TeachersList({required this.teachers, required this.courses});

  final List<Profile> teachers;
  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(Sizes.p24),
      itemCount: teachers.length,
      separatorBuilder: (_, _) => const SizedBox(height: Sizes.p8),
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        final assignedCourses =
            courses.where((c) => c.teacherId == teacher.id).toList();
        final unassignedCourses =
            courses.where((c) => c.teacherId != teacher.id).toList();
        return _TeacherRow(
          key: ValueKey('${teacher.id}-${assignedCourses.length}'),
          teacher: teacher,
          assignedCourses: assignedCourses,
          unassignedCourses: unassignedCourses,
        );
      },
    );
  }
}

class _TeacherRow extends StatelessWidget {
  const _TeacherRow({
    super.key,
    required this.teacher,
    required this.assignedCourses,
    required this.unassignedCourses,
  });

  final Profile teacher;
  final List<Course> assignedCourses;
  final List<Course> unassignedCourses;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;

    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: colors.accent.withValues(alpha: 0.15),
          child: Text(
            teacher.fullName.isNotEmpty
                ? teacher.fullName[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: colors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(
          teacher.fullName,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${assignedCourses.length} ${l10n.courses.toLowerCase()}',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.textMuted),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p16,
              0,
              Sizes.p16,
              Sizes.p16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Sizes.p8,
              children: [
                Text(
                  l10n.assignedCourses,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: colors.textMuted),
                ),
                if (assignedCourses.isEmpty)
                  Text(
                    l10n.noneSelected,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.textMuted),
                  )
                else
                  ...assignedCourses.map(
                    (course) => Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: colors.success,
                        ),
                        const SizedBox(width: Sizes.p8),
                        Expanded(child: Text(course.name)),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: colors.danger,
                          ),
                          onPressed: () => _confirmUnassign(context, course),
                          child: Text(l10n.unassignCourse),
                        ),
                      ],
                    ),
                  ),
                if (unassignedCourses.isNotEmpty) ...[
                  const Divider(),
                  Text(
                    l10n.assignCourse,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: colors.textMuted),
                  ),
                  ...unassignedCourses.map(
                    (course) => Row(
                      children: [
                        Expanded(child: Text(course.name)),
                        TextButton(
                          onPressed: () {
                            context.read<TeachersBloc>().add(
                                  TeacherCourseAssigned(
                                    teacherId: teacher.id,
                                    courseId: course.id,
                                  ),
                                );
                          },
                          child: Text(l10n.assignCourse),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmUnassign(BuildContext context, Course course) async {
    final l10n = context.l10n;
    final confirmed = await showAlertDialog(
      context: context,
      title: l10n.unassignConfirmTitle,
      content: l10n.unassignConfirmMessage,
      cancelActionText: l10n.cancel,
      defaultActionText: l10n.unassignConfirmButton,
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<TeachersBloc>().add(
            TeacherCourseUnassigned(courseId: course.id),
          );
    }
  }
}

class _CreateTeacherDrawer extends StatefulWidget {
  const _CreateTeacherDrawer();

  @override
  State<_CreateTeacherDrawer> createState() => _CreateTeacherDrawerState();
}

class _CreateTeacherDrawerState extends State<_CreateTeacherDrawer> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TeachersBloc>().add(TeacherAccountCreated(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: Sizes.p24,
        right: Sizes.p24,
        top: Sizes.p24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Sizes.p16,
          children: [
            Row(
              children: [
                Text(
                  l10n.createTeacher,
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
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.fullName),
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? l10n.fieldRequired
                      : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: l10n.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.emailRequired;
                }
                if (!value.contains('@')) return l10n.emailInvalid;
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: l10n.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              obscureText: _obscure,
              validator: (value) =>
                  (value == null || value.isEmpty)
                      ? l10n.passwordRequired
                      : null,
            ),
            PrimaryButton(
              onPressed: _submit,
              label: l10n.createUser,
            ),
            const SizedBox(height: Sizes.p8),
          ],
        ),
      ),
    );
  }
}
