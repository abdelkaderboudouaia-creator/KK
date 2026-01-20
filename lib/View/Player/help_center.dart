import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'.tr),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Get.locale?.languageCode == 'ar'
                  ? 'الأسئلة الأكثر شيوعاً'
                  : 'Frequently Asked Questions',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            if (Get.locale?.languageCode == 'ar') ..._buildArabicFAQ() else ..._buildEnglishFAQ(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildArabicFAQ() {
    return [
      _buildFAQItem(
        'كيف يمكنني الانضمام إلى مباراة؟',
        'يمكنك تصفح المباريات المتاحة في التطبيق، اختيار المباراة التي تريدها، واختيار الفريق (الأزرق أو الأحمر) للانضمام إليه. تأكد من وجود رصيد كافي في محفظتك لدفع رسوم المباراة.',
      ),

      _buildFAQItem(
        'كم يجب أن يكون عمري للعب؟',
        'يجب أن تكون في سن 18 عامًا على الأقل لاستخدام تطبيق Q-Play والمشاركة في المباريات.',
      ),

      _buildFAQItem(
        'كيف أقوم بإلغاء مشاركتي في مباراة؟',
        'يمكنك إلغاء مشاركتك من خلال الذهاب إلى تفاصيل المباراة والضغط على "إلغاء المشاركة". سيتم احتساب المبلغ المسترد حسب سياسة الاسترداد:\n• أكثر من 9 ساعات قبل المباراة: استرداد 100%\n• من 5-9 ساعات قبل المباراة: استرداد 50%\n• أقل من 5 ساعات قبل المباراة: لا يوجد استرداد',
      ),

      _buildFAQItem(
        'كيف تعمل المحفظة الإلكترونية؟',
        'المحفظة الإلكترونية تخزن أموالك في التطبيق. يمكنك إضافة أموال إليها واستخدامها لدفع رسوم المباريات. جميع المبالغ المودعة غير قابلة للاسترداد نقديًا، ولكن يمكن استخدامها في التطبيق فقط.',
      ),

      _buildFAQItem(
        'ماذا يحدث إذا تعرضت لإصابة أثناء اللعب؟',
        'Q-Play غير مسؤول عن الإصابات التي قد تحدث أثناء اللعب. أنت تلعب على مسؤوليتك الخاصة وتتحمل جميع النفقات الطبية. قد نقدم الإسعافات الأولية إذا كان ذلك ممكنًا.',
      ),

      _buildFAQItem(
        'هل يمكنني تحويل أموال لأصدقائي في التطبيق؟',
        'نعم، يمكنك تحويل الأموال من محفظتك الإلكترونية إلى لاعبين آخرين في التطبيق. تأكد من إدخال رقم الهاتف الصحيح المسجل في التطبيق.',
      ),

      _buildFAQItem(
        'ماذا يحدث إذا ألغت Q-Play المباراة؟',
        'إذا ألغت Q-Play المباراة، ستحصل على استرداد كامل 100% من رسوم المباراة إلى محفظتك الإلكترونية. في حالة عدم حضور عدد كافٍ من اللاعبين، سيتم استرداد الأموال للاعبين الحاضرين فقط.',
      ),

      _buildFAQItem(
        'ما هي قوانين اللعب النظيف؟',
        'يجب اتباع تعليمات الحكم في جميع الأوقات. البطاقة الصفراء هي إنذار أول، والبطاقة الحمراء تعني راحة 3 دقائق خارج الملعب. اللعب العنيف أو السلوك السيء يؤدي إلى المنع من المباريات الحالية والمستقبلية.',
      ),

      _buildFAQItem(
        'هل يمكنني استخدام محفظة لاعب آخر؟',
        'لا، لكل لاعب حسابه ومحفظته الخاصة. لا يُسمح بمشاركة الحسابات أو استخدام محفظة لاعب آخر.',
      ),

      _buildFAQItem(
        'ماذا يحدث لأموالي إذا حُذف حسابي بالخطأ؟',
        'Q-Play غير مسؤول عن الأموال في حالة حذف الحساب بالخطأ. تأكد من حماية حسابك وكلمة المرور الخاصة بك.',
      ),

      _buildFAQItem(
        'هل يمكنني الحصول على استرداد نقدي؟',
        'لا، جميع المبالغ المستردة تكون في شكل رصيد في محفظتك الإلكترونية لاستخدامها في المستقبل. لا يتم إصدار استردادات نقدية.',
      ),

      _buildFAQItem(
        'من المسؤول عن ممتلكاتي الشخصية؟',
        'أنت مسؤول عن ممتلكاتك الشخصية مثل المحفظة والساعة والملابس والنقود. Q-Play غير مسؤول عن فقدان أو سرقة الممتلكات الشخصية.',
      ),

      _buildFAQItem(
        'هل يمكن لـ Q-Play تصويري أثناء اللعب؟',
        'نعم، Q-Play لديه الحق في تصوير اللاعبين أثناء المباريات ونشر هذه الصور على وسائل التواصل الاجتماعي لأغراض التسويق والترويج للتطبيق.',
      ),
    ];
  }

  List<Widget> _buildEnglishFAQ() {
    return [
      _buildFAQItem(
        'How can I join a match?',
        'You can browse available matches in the app, select the match you want, and choose a team (Blue or Red) to join. Make sure you have sufficient balance in your wallet to pay the match fee.',
      ),

      _buildFAQItem(
        'What is the minimum age to play?',
        'You must be at least 18 years old to use the Q-Play app and participate in matches.',
      ),

      _buildFAQItem(
        'How do I cancel my participation in a match?',
        'You can cancel your participation by going to the match details and clicking "Cancel Participation". The refund amount will be calculated according to our refund policy:\n• More than 9 hours before match: 100% refund\n• 5-9 hours before match: 50% refund\n• Less than 5 hours before match: No refund',
      ),

      _buildFAQItem(
        'How does the e-wallet work?',
        'The e-wallet stores your money within the app. You can add funds to it and use them to pay for match fees. All deposited amounts are non-refundable as cash, but can only be used within the app.',
      ),

      _buildFAQItem(
        'What happens if I get injured while playing?',
        'Q-Play is not responsible for injuries that may occur during play. You play at your own risk and are responsible for all medical expenses. We may provide first aid if possible.',
      ),

      _buildFAQItem(
        'Can I transfer money to my friends in the app?',
        'Yes, you can transfer money from your e-wallet to other players in the app. Make sure to enter the correct phone number registered in the app.',
      ),

      _buildFAQItem(
        'What happens if Q-Play cancels a match?',
        'If Q-Play cancels a match, you will receive a full 100% refund of the match fee to your e-wallet. In case of cancellation due to insufficient player attendance, only attending players will be refunded.',
      ),

      _buildFAQItem(
        'What are the fair play rules?',
        'You must follow the referee\'s instructions at all times. A yellow card is a first warning, and a red card means a 3-minute rest outside the pitch. Violent play or bad behavior leads to banning from current and future matches.',
      ),

      _buildFAQItem(
        'Can I use another player\'s wallet?',
        'No, each player has their own account and wallet. Sharing accounts or using another player\'s wallet is not allowed.',
      ),

      _buildFAQItem(
        'What happens to my money if my account gets deleted by mistake?',
        'Q-Play is not responsible for funds in case of accidental account deletion. Make sure to protect your account and password.',
      ),

      _buildFAQItem(
        'Can I get a cash refund?',
        'No, all refunds are in the form of credit in your e-wallet for future use. No cash refunds are issued.',
      ),

      _buildFAQItem(
        'Who is responsible for my personal belongings?',
        'You are responsible for your personal belongings such as wallet, watch, clothes, and money. Q-Play is not responsible for loss or theft of personal property.',
      ),

      _buildFAQItem(
        'Can Q-Play photograph me while playing?',
        'Yes, Q-Play has the right to photograph players during matches and publish these images on social media for marketing and promotional purposes for the app.',
      ),
    ];
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Get.isDarkMode
              ? Colors.grey.shade600
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
        // Optional: Add background color for better contrast
        color: Get.isDarkMode
            ? Colors.grey.shade800
            : Colors.white,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        // Optional: Set icon color for better visibility
        iconColor: Get.isDarkMode ? Colors.white70 : Colors.black87,
        collapsedIconColor: Get.isDarkMode ? Colors.white70 : Colors.black87,
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Get.isDarkMode ? Colors.white70 : Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}