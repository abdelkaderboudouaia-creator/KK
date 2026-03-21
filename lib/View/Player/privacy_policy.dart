import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Static screen that presents the application's privacy policy text.
///
/// The content is hardcoded (no API call required).
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'.tr),
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
            if (Get.locale?.languageCode == 'ar')
              ..._buildArabicContent()
            else
              ..._buildEnglishContent(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildArabicContent() {
    return [
      const Text(
        'شروط وأحكام تطبيق "Q-Play"',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      const Text(
        'المقدمة:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'لا يمكن لأي لاعب تسجيل الدخول و/أو الانضمام إلى التطبيق دون قراءة هذه الشروط والأحكام كاملة وقبولها. وإلا، يتحمل اللاعب جميع العواقب والمسؤوليات بمفرده. يجب على جميع اللاعبين والمستفيدين من خدمات هذه الشركة الموافقة الكاملة على جميع الشروط أدناه:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'أولاً: الشروط المتعلقة بالعمر و/أو السن:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• يجب أن يكون اللاعبون في سن الثامنة عشرة (18) على الأقل ليتمكنوا من استخدام خدمات هذا التطبيق.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'ثانياً: الشروط المتعلقة بالإصابات والوفاة:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• يمكن لجميع اللاعبين الانضمام إلى أي مباراة عبر تطبيق "Q-Play" على مسؤوليتهم الخاصة، دون تحميل التطبيق أو مدرائه أي مسؤولية عن أي نتائج قد تنتج عن هذه المباريات.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• شركة "Q-Play" وكل المعنيين بهذا التطبيق ليسوا مسؤولين عن أي إصابات محتملة قد تحدث نتيجة المشاركة في أي من هذه الألعاب، واللاعب مسؤول عن جميع النفقات الطبية.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• سيقوم الأشخاص المسؤولون عن تطبيق "Q-Play" بتقديم الإسعافات الأولية للاعبين المصابين فقط إذا كان ذلك ممكناً.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• تطبيق "Q-Play" غير مسؤول عن أي نزاعات قد تنشأ بين اللاعبين أثناء المباراة ويتبرأ من جميع المسؤولية عن عواقب هذه النزاعات.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• يبرأ تطبيق "Q-Play" من جميع المسؤولية في حالات الوفاة التي قد تحدث لأي لاعب في الملعب أثناء أي مباراة نتيجة الإصابات والأضرار التي قد تحدث لأي لاعب أثناء اللعب، مثل السكتات الدماغية، أو ابتلاع اللسان، وما إلى ذلك.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'ثالثاً: الشروط المتعلقة بالتأمين الصحي:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• تطبيق "Q-Play" غير مسؤول عن توفير تأمين صحي للمستفيدين من خدماته.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'رابعاً: الشروط المتعلقة بالالتزامات المالية:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• في حال حجز اللاعب مكاناً للعب وتأكيد حضوره ولكن لا يمكنه الحضور لأي سبب كان، يجب على اللاعب دفع مبلغ متفق عليه مسبقاً للمباراة القادمة إذا رغب في اللعب مرة أخرى.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'خامساً: الشروط المتعلقة بممتلكات اللاعبين الشخصية:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• يبرأ تطبيق "Q-Play" وكل المسؤولين عنه من مسؤولية فقدان الممتلكات وجميع العناصر الشخصية الخاصة باللاعبين، مثل المحافظ، الساعات، الملابس، النقود، والمزيد.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'سادساً: الشروط المتعلقة بحقوق النشر:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• للأفراد المسؤولين عن تطبيق "Q-Play" الحق في تصوير و/أو التقاط بعض الصور للاعبين أثناء اللعبة ولهم الحق في نشر هذه الصور على جميع منصات التواصل الاجتماعي كشكل من أشكال التسويق الإلكتروني والترويج للتطبيق، دون التسبب في ضرر لأي لاعب يستفيد من خدماته.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'سابعاً: الشروط المتعلقة باللعب النظيف:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• يبدأ / يستمر اللعب عند صافرة الحكم.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• تعتبر البطاقة الصفراء من الحكم بمثابة إنذار أول.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• تعتبر البطاقة الحمراء من الحكم بمثابة راحة خارج الملعب لمدة 3 دقائق (أو أي مدة يراها الحكم مناسبة).',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• سيؤدي اللعب المفرط أو الخشن أو أي سلوك سلبي (كما يحدده الحكم أو فريق التنظيم) إلى منع اللاعب من المباراة الحالية والمباريات المستقبلية (بدون استرداد الأموال).',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• إذا بدأ اللاعب أي فعل عنيف، لفظياً أو جسدياً (كما يحدده الحكم أو فريق التنظيم)، فسيتم منعه من المباريات الحالية والمستقبلية.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),
      const Text(
        'شروط وأحكام المحفظة الإلكترونية',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      const Text(
        'يمكن لأي لاعب أن يبدأ بدفع مبلغ من المال وتسليمه إلى القائمين على التطبيق. سيقوم القائمون على تطبيق (Q-Play) بإنشاء حساب وإيداع المبلغ في المحفظة الإلكترونية لكل لاعب (يمكن للاعب إنشاء حساب بنفسه أيضاً). يجب قراءة جميع البنود أدناه كجزء لا يتجزأ. وفي ضوء ذلك، يجب مراعاة مجموعة من الشروط:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        '1. الأموال المودعة في هذه المحفظة غير قابلة للاسترداد تحت أي ظرف من الظروف.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '2. يدفع اللاعب مبلغ المال، ويتم إيداع المبلغ في المحفظة الإلكترونية للاعب، وعندما يشارك في أي لعبة و/أو مباراة، سيتم خصم رصيده المتاح في المحفظة الإلكترونية.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '3. عند دفع مبلغ المال، من الممكن أن يمنح القائمون على التطبيق اللاعب رصيداً مجانياً، ويتم منح الرصيد المجاني حسب مبلغ المال الذي تم دفعه.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '4. يمكن للاعب أو المشارك الدفع من رصيده في المحفظة الإلكترونية لأي لاعب آخر وسيتم خصم المبلغ من رصيده.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '5. يبرأ تطبيق (Q-Play) وكل المسؤولين عنه من جميع المسؤولية في حالة التحويل الخاطئ إلى أي رقم هاتف آخر غير الموجود على التطبيق، بغض النظر عن قيمة المبلغ المحول.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '6. يبرأ تطبيق (Q-Play) وكل المسؤولين عنه من جميع المسؤولية في حالة حذف حساب اللاعب عن طريق الخطأ.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '7. في حالة انسحاب اللاعب من التطبيق و/أو اللعبة، تعتبر جميع الأرصدة المنقولة إلى المحفظة الإلكترونية من حق التطبيق، وليس للاعب الحق في المطالبة بأي مبالغ متبقية في رصيده.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '8. لكل لاعب حسابه الخاص وكلمة المرور الخاصة به، وبالتالي يبرأ التطبيق من جميع المسؤولية في حالة أي اختراق لحسابه.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '9. لا يجوز لأي لاعب استخدام المحفظة الإلكترونية لأي لاعب آخر.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '10. لا يجوز لأي لاعب أن يطلب من القائمين على التطبيق الخصم من المحفظة الخاصة لأي لاعب آخر.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '11. لا يوجد استرداد أموال للاعبين في حالة عنف لفظياً أو جسدياً. إذا تم حظر اللاعب من التطبيق لأي سبب، فإن الاسترداد غير ممكن.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),
      const Text(
        'سياسات الإلغاء والاسترداد',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      const Text(
        'سياسة الإلغاء:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• في حالة إلغاء Q-Play للمباراة، سيحصل جميع اللاعبين على استرداد كامل بنسبة 100% من مبلغ المباراة إلى محفظتهم الإلكترونية في Q-Play.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• في حالة الإلغاء بسبب عدم حضور عدد كافٍ من اللاعبين، سيتم استرداد الأموال للاعبين الحاضرين فقط.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• ستكون جميع المبالغ المستردة في شكل رصيد في محفظة التطبيق للاعب لاستخدامه في المستقبل. لن يتم إجراء أي استرداد نقدي.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'سياسة الاسترداد:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'في حالة قيام اللاعب بإلغاء مشاركته في مباراة نظمتها Q-Play، تنطبق القواعد التالية عند إضافة أمواله إلى المحفظة الإلكترونية:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '1. أكثر من 8 ساعات قبل بداية المباراة:',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const Text(
        '• إذا ألغى اللاعب مشاركته قبل أكثر من 9 ساعات من وقت بدء المباراة المحدد، سيتم استرداد 100% من المبلغ المدفوع إلى المحفظة الإلكترونية لـ Q-Play.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '2. من 9-5 ساعات و أقل قبل بداية المباراة:',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const Text(
        '• إذا ألغى اللاعب مشاركته ما بين 9 إلى 5 ساعات قبل وقت بدء المباراة المحدد، سيتم استرداد 50% من المبلغ المدفوع إلى المحفظة الإلكترونية لـ Q-Play.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '3. أقل 5 ساعات قبل بداية المباراة:',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const Text(
        '• إذا ألغى اللاعب مشاركته قبل أقل من 5 ساعات من وقت بدء المباراة المحدد، سيتم استرداد 0% من المبلغ المدفوع إلى المحفظة الإلكترونية لـ Q-Play.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'ملاحظة: ستكون جميع المبالغ المستردة في شكل رصيد في محفظة التطبيق للاعب لاستخدامه في المستقبل. لن يتم إجراء أي استرداد نقدي.',
        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),
      const Text(
        'مدفوعات البوابة الإلكترونية (E-gate) مدعومة من Visa و MasterCard.',
        style: TextStyle(fontSize: 14),
      ),
    ];
  }

  List<Widget> _buildEnglishContent() {
    return [
      const Text(
        'Terms and Conditions for the "Q-Play" Application',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      const Text(
        'Introduction:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'No player may log in and/or join the application without reading these terms and conditions in their entirety and accepting them. Otherwise, the player shall bear all consequences and responsibilities alone. All players and beneficiaries of this company\'s services must fully agree to all the conditions below:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'First: Conditions related to age:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• Players must be at least eighteen (18) years old to be able to use the services of this application.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Second: Conditions related to injuries and death:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• All players can join any match through the "Q-Play" application at their own risk, without holding the application or its administrators responsible for any results that may occur from these matches.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• The "Q-Play" company and all those involved in this application are not responsible for any potential injuries that may occur as a result of participating in any of these games, and the player is responsible for all medical expenses.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• The people responsible for the "Q-Play" application will only provide injured players with first aid if possible.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• The "Q-Play" application is not responsible for any disputes that may arise between players during the match and disclaims all responsibility for the consequences of these disputes.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• The "Q-Play" application disclaims all responsibility for cases of death that may occur to any player on the field during any match due to injuries and damages sustained while playing, such as strokes, tongue swallowing, and so on.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Third: Conditions related to health insurance:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• The "Q-Play" application is not responsible for providing health insurance to the beneficiaries of its services.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Fourth: Conditions related to financial obligations:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• In the event that a player reserves a spot to play and confirms their attendance but cannot attend for any reason, the player must pay a pre-arranged amount for the next game if they wish to play again.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Fifth: Conditions related to players\' personal belongings:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• The "Q-Play" application and all those responsible for it disclaim responsibility for the loss of belongings and all personal items related to the players, such as wallets, watches, clothing, money, and more.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Sixth: Conditions related to copyright:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• The individuals responsible for the "Q-Play" application have the right to photograph and/or capture some images of the players during the game and have the right to publish these images on all social media platforms as a form of electronic marketing and promotion for the application, without causing harm to any player benefiting from its services.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Seventh: Conditions related to fair play:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• Playing starts/continues at the referee\'s whistle.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• A yellow card issued by the referee is considered a first warning.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• A red card issued by the referee is considered a 3-minute rest outside the pitch (or any period the referee deems appropriate).',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• Excessive or rough play or any negative behavioral attitude (as identified by the referee or organizing team) will result in the player being banned from the current game and future games (no refund).',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 4),
      const Text(
        '• If a player initiates any violent act, verbally or physically (as identified by the referee or organizing team), they will be banned from current and future games.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),
      const Text(
        'E-Wallet Terms and Conditions',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      const Text(
        'Any player can start by paying a sum of money and handing it over to those in charge of the application. Those in charge of the (Q-Play) application will create an account and deposit the amount into each player\'s electronic wallet (The player can also create an account themselves). All the items below must be read as an integral part. In light of this, a set of conditions must be observed:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        '1. Funds deposited into this wallet are non-refundable under any circumstances.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '2. The player pays the amount of money, and the amount is deposited into the player\'s electronic wallet. When they participate in any game and/or match, their available balance in the electronic wallet will be deducted.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '3. When paying the amount of money, those in charge of the application may give the player free credit. The free credit is granted according to the amount of money paid.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '4. The player or participant can pay from their balance in the electronic wallet to any other player, and their balance will be debited.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '5. The (Q-Play) application and all those responsible for it disclaim all responsibility in the event of a mistaken transfer to any phone number other than the one registered in the application, regardless of the value of the transferred amount.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '6. The (Q-Play) application and all those responsible for it disclaim all responsibility in the event that the player\'s account is deleted by mistake.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '7. In the event that the player withdraws from the application and/or the game, all balances transferred to the electronic wallet are considered the right of the application, and the player is not entitled to claim any remaining amounts in their balance.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '8. Each player has their own account and password, and therefore the application disclaims all responsibility in the event of any hacking of their account.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '9. No player may use the electronic wallet of any other player.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '10. No player may ask those in charge of the application to deduct from the private wallet of any other player.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '11. No refund for players who cause verbal or physical violence. If the player has been blocked from the app for any reason, a refund is not possible.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),
      const Text(
        'Cancellation and Refund Policies',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      const Text(
        'Cancellation policy:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '• In the event that Q-Play cancels a game, all players will receive a full refund of 100% of the game amount to their Q-Play e-wallet.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• In case of cancellation due to insufficient player attendance, only the players who attended will be refunded.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '• All refunds will be in the form of credit in the player\'s app wallet for future usage. No cash refunds will be issued.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Refund Policy:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'In case the player cancels their participation in a match organized by Q-Play, the following rules apply when crediting their funds to the e-wallet:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '1. More than 8 hours before game start:',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const Text(
        '• If a player cancels their participation more than 9 hours prior to the scheduled game start time, 100% of the paid amount will be refunded to the Q-Play e-wallet.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '2. Between 9 - 5 hours before game start:',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const Text(
        '• If a player cancels their participation between 9 to 5 hours prior to the scheduled game start time, 50% of the paid amount will be refunded to the Q-Play e-wallet.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        '3. Less than 5 hours before game start:',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const Text(
        '• If a player cancels their participation less than 5 hours prior to the scheduled game start time, 0% of the paid amount will be refunded to the Q-Play e-wallet.',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 16),
      const Text(
        'Note: All refunds will be in the form of credit in the player\'s app wallet for future usage. No cash refunds will be issued.',
        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
      ),
      const SizedBox(height: 16),
      const Text(
        'E-gate payments are powered by Visa and MasterCard.',
        style: TextStyle(fontSize: 14),
      ),
    ];
  }
}
