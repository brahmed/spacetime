import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import 'package:ui/ui.dart';

import '../../../common/widgets/show_alert_dialog.dart';
import '../bloc/students_bloc.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentsBloc(
        profileRepository: context.read<ProfileRepository>(),
        courseRepository: context.read<CourseRepository>(),
        enrollmentRepository: context.read<EnrollmentRepository>(),
        supabase: Supabase.instance.client,
      )..add(const StudentsLoaded()),
      child: const _StudentsView(),
    );
  }
}

class _StudentsView extends StatelessWidget {
  const _StudentsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<StudentsBloc, StudentsState>(
      listener: (context, state) {
        if (state is StudentCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.userCreated)),
          );
        } else if (state is StudentCreateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        } else if (state is StudentEnrollSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.attendanceConfirmed)),
          );
        } else if (state is StudentUnenrollSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.attendanceCancelled)),
          );
        } else if (state is StudentEnrollFailure ||
            state is StudentUnenrollFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.students),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Sizes.p16),
              child: FilledButton.icon(
                onPressed: () => _openCreateDrawer(context),
                icon: const Icon(Icons.person_add_outlined),
                label: Text(l10n.createStudent),
              ),
            ),
          ],
        ),
        body: BlocBuilder<StudentsBloc, StudentsState>(
          builder: (context, state) {
            return switch (state) {
              StudentsInitial() || StudentsLoading() =>
                const Center(child: CircularProgressIndicator()),
              StudentsFailure() => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Sizes.p16,
                    children: [
                      Text(l10n.somethingWentWrong),
                      TextButton(
                        onPressed: () => context
                            .read<StudentsBloc>()
                            .add(const StudentsLoaded()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              StudentsSuccess(:final students, :final courses,
                :final enrollmentsByCourse) =>
                students.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noStudents,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).appColors.textMuted,
                              ),
                        ),
                      )
                    : _StudentsList(
                        students: students,
                        courses: courses,
                        enrollmentsByCourse: enrollmentsByCourse,
                      ),
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
        value: context.read<StudentsBloc>(),
        child: const _CreateUserDrawer(role: UserRole.student),
      ),
    );
  }
}

class _StudentsList extends StatelessWidget {
  const _StudentsList({
    required this.students,
    required this.courses,
    required this.enrollmentsByCourse,
  });

  final List<Profile> students;
  final List<Course> courses;
  final Map<String, List<String>> enrollmentsByCourse;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(Sizes.p24),
      itemCount: students.length,
      separatorBuilder: (_, _) => const SizedBox(height: Sizes.p8),
      itemBuilder: (context, index) {
        final student = students[index];
        final enrolledCourseIds = enrollmentsByCourse.entries
            .where((e) => e.value.contains(student.id))
            .map((e) => e.key)
            .toSet();
        return _StudentRow(
          student: student,
          courses: courses,
          enrolledCourseIds: enrolledCourseIds,
        );
      },
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.student,
    required this.courses,
    required this.enrolledCourseIds,
  });

  final Profile student;
  final List<Course> courses;
  final Set<String> enrolledCourseIds;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;

    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: colors.accent.withValues(alpha: 0.15),
          child: Text(
            student.fullName.isNotEmpty
                ? student.fullName[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: colors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(
          student.fullName,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          l10n.enrolledCoursesCount(enrolledCourseIds.length),
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
                  l10n.enrollments,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: colors.textMuted),
                ),
                ...courses.map((course) {
                  final isEnrolled = enrolledCourseIds.contains(course.id);
                  return Row(
                    children: [
                      Expanded(child: Text(course.name)),
                      isEnrolled
                          ? TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: colors.danger,
                              ),
                              onPressed: () =>
                                  _confirmUnenroll(context, course),
                              child: Text(l10n.unenroll),
                            )
                          : TextButton(
                              onPressed: () {
                                context.read<StudentsBloc>().add(
                                      StudentEnrolled(
                                        studentId: student.id,
                                        courseId: course.id,
                                      ),
                                    );
                              },
                              child: Text(l10n.enroll),
                            ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmUnenroll(BuildContext context, Course course) async {
    final l10n = context.l10n;
    final confirmed = await showAlertDialog(
      context: context,
      title: l10n.unenrollConfirmTitle,
      content: l10n.unenrollConfirmMessage,
      cancelActionText: l10n.cancel,
      defaultActionText: l10n.unenrollConfirmButton,
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<StudentsBloc>().add(
            StudentUnenrolled(
              studentId: student.id,
              courseId: course.id,
            ),
          );
    }
  }
}

class _CreateUserDrawer extends StatefulWidget {
  const _CreateUserDrawer({required this.role});

  final UserRole role;

  @override
  State<_CreateUserDrawer> createState() => _CreateUserDrawerState();
}

class _CreateUserDrawerState extends State<_CreateUserDrawer> {
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
    if (widget.role == UserRole.student) {
      context.read<StudentsBloc>().add(StudentAccountCreated(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
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
                  l10n.createUser,
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
                    _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              obscureText: _obscure,
              validator: (value) =>
                  (value == null || value.isEmpty) ? l10n.passwordRequired : null,
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
