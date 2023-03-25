import 'package:flutter/material.dart';

class HelpScreem extends StatelessWidget {
  static final routeName = "/helpScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "সাহায্য",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            "✅ জাতীয় ভোক্তা অভিযোগ কেন্দ্র,  টিসিবি ভবন- ৯ম তলা, ১ কারওয়ান বাজার ঢাকা, ফোন: ০১৭৭৭ ৭৫৩৬৬৮, ই-মেইল: nccc@dncrp.gov.bd\n✅উপ পরিচালক, চট্টগ্রাম বিভাগীয় কার্যালয়, জাতীয় ভোক্তা-অধিকার সংরক্ষণ অধিদপ্তর, টিসিবি ভবন, বন্দরটিলা, চট্টগ্রাম, ফোন: +৮৮ ০২৩৩ ৩৩৪১২১২উপ পরিচালক, রাজশাহী বিভাগীয় কার্যালয়, জাতীয় ভোক্তা-অধিকার সংরক্ষণ অধিদপ্তর, শ্রীরামপুর, রাজশাহী, ফোন: +৮৮ ০২৫৮ ৮৮০৭৭৪\n✅উপ পরিচালক, খুলনা বিভাগীয় কার্যালয়, জাতীয় ভোক্তা-অধিকার সংরক্ষণ অধিদপ্তর, টিসিবি ভবন, শিববাড়ী মোড়, খুলনা, ফোন: +৮৮ ০২৪৭ ৭৭২২৩১১\n✅উপ পরিচালক, বরিশাল বিভাগীয় কার্যালয়, জাতীয় ভোক্তা-অধিকার সংরক্ষণ অধিদপ্তর, মহিলা ক্লাব ভবন, বরিশাল, ফোন: +৮৮ ০২৪৭ ৮৮৬২০৪২\n✅উপ পরিচালক, সিলেট বিভাগীয় কার্যালয়, জাতীয় ভোক্তা-অধিকার সংরক্ষণ অধিদপ্তর, বিভাগীয় কমিশনারের কার্যালয়, সিলেট ফোন: +৮৮ ০২৯৯ ৬৬৪৩৪৫৬\n✅উপ পরিচালক, রংপুর বিভাগীয় কার্যালয়, জাতীয় ভোক্তা-অধিকার সংরক্ষণ অধিদপ্তর, নিউ ইঞ্জিনিয়ার পাড়া, রংপুর, ফোন: +৮৮ ০৫২১-৫৫৬৯১\n✅প্রত্যেক জেলার জেলা ম্যাজিস্ট্রেট।",
            textWidthBasis: TextWidthBasis.longestLine,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
