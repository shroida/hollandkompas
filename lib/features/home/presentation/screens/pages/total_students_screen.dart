import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/student.dart';
import 'package:hollandkompas/features/home/presentation/providers/all_students_provider.dart';

class TotalStudentsScreen extends ConsumerStatefulWidget {
  const TotalStudentsScreen({super.key});

  @override
  ConsumerState<TotalStudentsScreen> createState() =>
      _TotalStudentsScreenState();
}

class _TotalStudentsScreenState extends ConsumerState<TotalStudentsScreen> {
  final searchController = TextEditingController();

  String selectedLevel = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Student> _filterStudents(List<Student> students) {
    final query = searchController.text.trim().toLowerCase();

    return students.where((student) {
      final matchesSearch =
          query.isEmpty ||
          student.fullName.toLowerCase().contains(query) ||
          student.email.toLowerCase().contains(query) ||
          (student.phoneNumber ?? '').contains(query);

      final matchesLevel =
          selectedLevel == 'All' ||
          student.level.toLowerCase() == selectedLevel.toLowerCase();

      return matchesSearch && matchesLevel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(allStudentsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Students',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(allStudentsProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
          ),

          const SizedBox(width: 12),
        ],
      ),

      body: studentsAsync.when(
        loading: () => const _StudentsLoading(),

        error: (error, stack) {
          return _ErrorView(
            error: error.toString(),
            onRetry: () {
              ref.invalidate(allStudentsProvider);
            },
          );
        },

        data: (students) {
          final filteredStudents = _filterStudents(students);

          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 700;

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(allStudentsProvider);
                  await ref.read(allStudentsProvider.future);
                },

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: EdgeInsets.all(isMobile ? 16 : 32),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        context,
                        students.length,
                        filteredStudents.length,
                      ),

                      const SizedBox(height: 24),

                      _buildFilters(context, students),

                      const SizedBox(height: 24),

                      if (filteredStudents.isEmpty)
                        const _EmptyStudents()
                      else
                        isMobile
                            ? _buildMobileList(context, filteredStudents)
                            : _buildDesktopTable(context, filteredStudents),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int total, int filtered) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Students',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Manage and view all registered students',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ),

        if (MediaQuery.sizeOf(context).width > 500)
          _StatBadge(
            icon: Icons.people_alt_rounded,
            value: filtered == total ? '$total' : '$filtered / $total',
            label: 'Students',
          ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, List<Student> students) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Wrap(
          spacing: 14,
          runSpacing: 14,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: AppColors.textColor(context)),
                decoration: InputDecoration(
                  hintText: 'Search students...',
                  hintStyle: TextStyle(color: AppColors.subtitleColor(context)),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.subtitleColor(context),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            _buildLevelFilter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLevel,
          borderRadius: BorderRadius.circular(14),
          items: const [
            DropdownMenuItem(value: 'All', child: Text('All Levels')),
            DropdownMenuItem(value: 'a1', child: Text('A1')),
            DropdownMenuItem(value: 'a2', child: Text('A2')),
            DropdownMenuItem(value: 'b1', child: Text('B1')),
            DropdownMenuItem(value: 'b2', child: Text('B2')),
            DropdownMenuItem(value: 'c1', child: Text('C1')),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedLevel = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<Student> students) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1000,
          child: DataTable(
            headingRowHeight: 60,
            dataRowMinHeight: 72,
            dataRowMaxHeight: 82,
            columnSpacing: 28,

            headingTextStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),

            columns: const [
              DataColumn(label: Text('Student')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Level')),
              DataColumn(label: Text('Joined')),
              DataColumn(label: Text('Status')),
            ],

            rows: students.map((student) {
              return DataRow(
                cells: [
                  DataCell(_StudentIdentity(student: student)),

                  DataCell(
                    Text(
                      student.email,
                      style: TextStyle(color: AppColors.textColor(context)),
                    ),
                  ),

                  DataCell(
                    Text(
                      student.phoneNumber ?? '—',
                      style: TextStyle(color: AppColors.textColor(context)),
                    ),
                  ),

                  DataCell(_LevelBadge(level: student.level)),

                  DataCell(Text(_formatDate(student.createdAt))),

                  const DataCell(_ActiveBadge()),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List<Student> students) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _StudentCard(student: students[index]);
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _StudentIdentity extends StatelessWidget {
  const _StudentIdentity({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(name: student.fullName),

        const SizedBox(width: 12),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.fullName,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              student.role.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.subtitleColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                _Avatar(name: student.fullName, size: 52),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        student.email,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.subtitleColor(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                _LevelBadge(level: student.level),
              ],
            ),

            const SizedBox(height: 18),

            const Divider(),

            const SizedBox(height: 12),

            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: student.phoneNumber ?? 'Not provided',
            ),

            const SizedBox(height: 10),

            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Joined',
              value: _formatDate(student.createdAt),
            ),

            const SizedBox(height: 10),

            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'Role',
              value: student.role,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.size = 44});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name
              .trim()
              .split(' ')
              .take(2)
              .map((e) => e.isNotEmpty ? e[0] : '')
              .join()
              .toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: size * 0.32,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 7, color: AppColors.success),
          SizedBox(width: 6),
          Text(
            'Active',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.subtitleColor(context)),

        const SizedBox(width: 10),

        Text(
          '$label:',
          style: TextStyle(
            color: AppColors.subtitleColor(context),
            fontSize: 13,
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudentsLoading extends StatelessWidget {
  const _StudentsLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _EmptyStudents extends StatelessWidget {
  const _EmptyStudents();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 70,
              color: AppColors.subtitleColor(context),
            ),
            const SizedBox(height: 18),
            const Text(
              'No students found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Try changing your search or filter.',
              style: TextStyle(color: AppColors.subtitleColor(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: AppColors.destructive,
            ),

            const SizedBox(height: 16),

            const Text(
              'Unable to load students',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.subtitleColor(context)),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
