import 'package:flutter/material.dart';

class CourseTermsDialog extends StatelessWidget {
  const CourseTermsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      scrollable: true,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      title: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(Icons.gavel_rounded, color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'شروط استخدام الكورس',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      content: const _CourseTermsContent(),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.check_rounded),
            label: const Text('فهمت وأوافق'),
          ),
        ),
      ],
    );
  }
}

class _CourseTermsContent extends StatelessWidget {
  const _CourseTermsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ArabicTerms(),
        const SizedBox(height: 28),
        const Divider(),
        const SizedBox(height: 28),
        const _EnglishTerms(),
      ],
    );
  }
}

class _ArabicTerms extends StatelessWidget {
  const _ArabicTerms();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LanguageHeader(
            title: 'شروط استخدام الكورس',
            subtitle:
                'يرجى قراءة الشروط التالية بعناية قبل إتمام عملية الشراء.',
            icon: Icons.language_rounded,
          ),
          const SizedBox(height: 20),
          const _ArabicTerm(
            number: '1',
            title: 'طبيعة الكورس',
            body:
                'هذا الكورس عبارة عن محتوى تعليمي رقمي لتعلّم اللغة الهولندية، ويتم توفير الدروس والمواد التعليمية من خلال منصة HollandKompas.',
          ),
          const _ArabicTerm(
            number: '2',
            title: 'عدم الإلغاء أو استرداد المبلغ',
            body:
                'بعد إتمام عملية الدفع وتفعيل الوصول إلى المحتوى التعليمي، لا يمكن إلغاء الاشتراك أو طلب استرداد المبلغ المدفوع، وذلك بسبب طبيعة المحتوى الرقمي وإمكانية الوصول إليه إلكترونيًا.',
          ),
          const _ArabicTerm(
            number: '3',
            title: 'الاستخدام الشخصي',
            body:
                'الاشتراك شخصي ومخصص للمستخدم الذي قام بالشراء فقط. لا يجوز مشاركة الحساب أو بيانات تسجيل الدخول مع أي شخص آخر أو السماح للغير باستخدام المحتوى من خلال حسابك.',
          ),
          const _ArabicTerm(
            number: '4',
            title: 'حظر نسخ أو إعادة استخدام المحتوى',
            body:
                'جميع الدروس والفيديوهات والملفات والنصوص والتمارين والمواد التعليمية المرتبطة بالكورس محمية بحقوق الملكية الفكرية. يُمنع نسخ المحتوى أو تسجيله أو إعادة نشره أو توزيعه أو بيعه أو مشاركته أو استخدامه لإنشاء محتوى مماثل دون إذن كتابي.',
          ),
          const _ArabicTerm(
            number: '5',
            title: 'منع مشاركة المحتوى',
            body:
                'يُمنع مشاركة روابط الدروس أو الملفات أو أي وسيلة أخرى تسمح لشخص غير مشترك بالوصول إلى المحتوى المدفوع. كما يُمنع رفع المحتوى على مواقع أو منصات أخرى أو مجموعات التواصل الاجتماعي أو خدمات التخزين العامة.',
          ),
          const _ArabicTerm(
            number: '6',
            title: 'الحساب ومسؤولية المستخدم',
            body:
                'المستخدم مسؤول عن الحفاظ على سرية بيانات حسابه وعدم مشاركتها مع الآخرين. في حال ثبوت إساءة استخدام الحساب أو مشاركة المحتوى بشكل غير مصرح به، يحق لإدارة المنصة تعليق أو إنهاء الوصول إلى المحتوى وفقًا للحالة.',
          ),
          const _ArabicTerm(
            number: '7',
            title: 'التحديثات التعليمية',
            body:
                'قد يتم تحديث محتوى الكورس أو تحسين الدروس والتمارين والمواد التعليمية من وقت لآخر بهدف تحسين التجربة التعليمية.',
          ),
          const _ArabicTerm(
            number: '8',
            title: 'الملكية الفكرية',
            body:
                'جميع الحقوق المتعلقة بالمحتوى الأصلي للكورس، بما في ذلك النصوص والمواد التعليمية والتصميمات والعناصر المرئية والصوتية، محفوظة لصاحب الحقوق.',
          ),
          const SizedBox(height: 12),
          _CopyrightBox(
            title: 'حقوق الملكية',
            copyright: '© 2026 Mohamed Walid (Shroida)',
            reserved: 'جميع الحقوق محفوظة.',
            contact: 'للتواصل بشأن حقوق المحتوى أو الحصول على إذن للاستخدام:',
          ),
        ],
      ),
    );
  }
}

class _EnglishTerms extends StatelessWidget {
  const _EnglishTerms();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LanguageHeader(
            title: 'Course Terms of Use',
            subtitle:
                'Please read the following terms carefully before purchasing the course.',
            icon: Icons.language_rounded,
          ),
          const SizedBox(height: 20),
          const _EnglishTerm(
            number: '1',
            title: 'Course Nature',
            body:
                'This course is digital educational content for learning Dutch. Lessons and educational materials are provided through the HollandKompas platform.',
          ),
          const _EnglishTerm(
            number: '2',
            title: 'No Cancellation or Refund',
            body:
                'After payment is completed and access to the educational content is activated, the subscription cannot be cancelled and the paid amount cannot be refunded due to the digital nature of the content and its electronic accessibility.',
          ),
          const _EnglishTerm(
            number: '3',
            title: 'Personal Use',
            body:
                'The subscription is personal and intended only for the purchasing user. Sharing the account or login credentials with another person or allowing others to access the content through your account is not permitted.',
          ),
          const _EnglishTerm(
            number: '4',
            title: 'No Copying or Unauthorized Use',
            body:
                'All lessons, videos, files, texts, exercises, and educational materials associated with the course are protected by intellectual property rights. Copying, recording, reproducing, publishing, distributing, selling, sharing, or using the content to create similar material without written permission is prohibited.',
          ),
          const _EnglishTerm(
            number: '5',
            title: 'No Content Sharing',
            body:
                'Sharing lesson links, files, or any other method that allows a non-subscriber to access paid content is prohibited. Uploading the content to other websites, platforms, social media groups, or public storage services is also prohibited.',
          ),
          const _EnglishTerm(
            number: '6',
            title: 'Account Responsibility',
            body:
                'Users are responsible for keeping their account credentials confidential. In case of account misuse or unauthorized content sharing, the platform may suspend or terminate access to the content, depending on the circumstances.',
          ),
          const _EnglishTerm(
            number: '7',
            title: 'Educational Updates',
            body:
                'Course content, lessons, exercises, and educational materials may be updated or improved from time to time to enhance the learning experience.',
          ),
          const _EnglishTerm(
            number: '8',
            title: 'Intellectual Property',
            body:
                'All rights relating to the original course content, including texts, educational materials, designs, visual elements, and audio materials, are reserved by the rights holder.',
          ),
          const SizedBox(height: 12),
          _CopyrightBox(
            title: 'Copyright & Ownership',
            copyright: '© 2026 Mohamed Walid (Shroida)',
            reserved: 'All rights reserved.',
            contact: 'For content rights or permission requests:',
          ),
        ],
      ),
    );
  }
}

class _LanguageHeader extends StatelessWidget {
  const _LanguageHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArabicTerm extends StatelessWidget {
  const _ArabicTerm({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnglishTerm extends StatelessWidget {
  const _EnglishTerm({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyrightBox extends StatelessWidget {
  const _CopyrightBox({
    required this.title,
    required this.copyright,
    required this.reserved,
    required this.contact,
  });

  final String title;
  final String copyright;
  final String reserved;
  final String contact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.copyright_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            copyright,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            reserved,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contact,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 5),
          SelectableText(
            '01151975641',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
