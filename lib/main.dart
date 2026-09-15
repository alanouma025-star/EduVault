import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

void main() => runApp(const EduVaultApp());

class EduVaultApp extends StatelessWidget {
  const EduVaultApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'EduVault', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const MainShell(),
  );
}

class MaterialItem {
  final String title, subject, topic, type;
  const MaterialItem(this.title, this.subject, this.topic, this.type);
}
const materials = [
  MaterialItem('Introduction to Microscopy','Biology','Microscopy','Lecture Notes'),
  MaterialItem('Compound Microscope: Parts and Functions','Zoology','Microscopy','Lecture Notes'),
  MaterialItem('Soil Formation','Soil Science','Soil Formation','Lecture Notes'),
  MaterialItem('Types of Soil','Soil Science','Soil Classification','Study Notes'),
  MaterialItem('Introduction to Zoology','Zoology','Introduction','Lecture Notes'),
  MaterialItem('Photosynthesis','Botany','Plant Physiology','Lecture Notes'),
];

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState()=>_MainShellState();
}
class _MainShellState extends State<MainShell> {
  int index=0;
  final pages=const [HomePage(),MaterialsPage(),QuizPage(),ProfilePage()];
  @override Widget build(BuildContext context)=>Scaffold(
    body: pages[index],
    bottomNavigationBar: NavigationBar(
      selectedIndex:index,onDestinationSelected:(i)=>setState(()=>index=i),
      destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
        NavigationDestination(icon:Icon(Icons.menu_book_outlined),selectedIcon:Icon(Icons.menu_book),label:'Materials'),
        NavigationDestination(icon:Icon(Icons.quiz_outlined),selectedIcon:Icon(Icons.quiz),label:'Quiz'),
        NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile'),
      ],
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
    const Text('EduVault',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold)),
    const Text('Learn. Practice. Succeed.',style:TextStyle(fontSize:16)),
    const SizedBox(height:20),
    TextField(
      decoration:InputDecoration(hintText:'Search notes, topics, subjects...',prefixIcon:const Icon(Icons.search),border:OutlineInputBorder(borderRadius:BorderRadius.circular(16))),
      onSubmitted:(q)=>Navigator.push(context,MaterialPageRoute(builder:(_)=>SearchPage(query:q))),
    ),
    const SizedBox(height:22),
    const Text('Your study area',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    const SizedBox(height:10),
    Wrap(spacing:8,runSpacing:8,children:[
      for(final s in ['Biology','Zoology','Botany','Agriculture','Soil Science'])
        ActionChip(label:Text(s),onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>SearchPage(query:s)))),
    ]),
    const SizedBox(height:25),
    Card(child:ListTile(leading:const Icon(Icons.auto_awesome),title:const Text('AI Tutor'),subtitle:const Text('Ask questions and get help with your studies.'),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const AiTutorPage())))),
    Card(child:ListTile(leading:const Icon(Icons.trending_up),title:const Text('Progress'),subtitle:const Text('Quiz average: 82%  •  6 topics studied'),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ProgressPage())))),
  ]));
}

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});
  @override State<MaterialsPage> createState()=>_MaterialsPageState();
}
class _MaterialsPageState extends State<MaterialsPage>{
  String q='';
  @override Widget build(BuildContext context){
    final list=materials.where((m)=>q.isEmpty||'${m.title} ${m.subject} ${m.topic}'.toLowerCase().contains(q.toLowerCase())).toList();
    return SafeArea(child:Column(children:[
      Padding(padding:const EdgeInsets.fromLTRB(16,16,16,8),child:TextField(decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search materials',border:OutlineInputBorder()),onChanged:(v)=>setState(()=>q=v))),
      Expanded(child:ListView.builder(itemCount:list.length,itemBuilder:(_,i)=>Card(margin:const EdgeInsets.symmetric(horizontal:12,vertical:5),child:ListTile(
        leading:const CircleAvatar(child:Icon(Icons.picture_as_pdf)),title:Text(list[i].title),subtitle:Text('${list[i].subject} • ${list[i].topic}'),trailing:const Icon(Icons.chevron_right),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ReaderPage(item:list[i]))),
      )))),
    ]));
  }
}

class SearchPage extends StatelessWidget{
  final String query; const SearchPage({super.key,required this.query});
  @override Widget build(BuildContext context){
    final list=materials.where((m)=>'${m.title} ${m.subject} ${m.topic}'.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(appBar:AppBar(title:Text('Results for "$query"')),body:list.isEmpty?const Center(child:Text('No matching materials yet.')):ListView(children:[
      for(final m in list) ListTile(leading:const Icon(Icons.picture_as_pdf),title:Text(m.title),subtitle:Text('${m.subject} • ${m.topic}'),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ReaderPage(item:m))))
    ]));
  }
}

class ReaderPage extends StatelessWidget{
  final MaterialItem item; const ReaderPage({super.key,required this.item});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Material')),body:ListView(padding:const EdgeInsets.all(18),children:[
    Text(item.title,style:const TextStyle(fontSize:25,fontWeight:FontWeight.bold)),
    Text('${item.subject} • ${item.topic} • ${item.type}'),const SizedBox(height:20),
    const Text('Study material',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:10),
    const Text('This is the EduVault reader preview. In the connected version, approved PDF materials will open here and can be downloaded for offline study.'),
    const SizedBox(height:25),
    FilledButton.icon(onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Saved to your study list.'))),icon:const Icon(Icons.bookmark_add),label:const Text('SAVE')),
    OutlinedButton.icon(onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Offline download will be available when storage is connected.'))),icon:const Icon(Icons.download),label:const Text('DOWNLOAD FOR OFFLINE')),
    FilledButton.icon(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const AiTutorPage())),icon:const Icon(Icons.auto_awesome),label:const Text('ASK AI TUTOR')),
  ]));
}

class AiTutorPage extends StatefulWidget{
  const AiTutorPage({super.key}); @override State<AiTutorPage> createState()=>_AiTutorPageState();
}
class _AiTutorPageState extends State<AiTutorPage>{
  final c=TextEditingController(); String answer='Ask me a question about Biology, Agriculture, Zoology, Botany or Soil Science.';
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('AI Tutor')),body:Padding(padding:const EdgeInsets.all(18),child:Column(children:[
    Expanded(child:SingleChildScrollView(child:Card(child:Padding(padding:const EdgeInsets.all(16),child:Text(answer))))),
    TextField(controller:c,decoration:const InputDecoration(hintText:'Type your question...',border:OutlineInputBorder())),
    const SizedBox(height:8),
    FilledButton(onPressed:()=>setState((){
      final q=c.text.trim(); answer=q.isEmpty?'Please type a question.':'Demo tutor response: I can explain "$q" step by step. The connected EduVault version will use the AI service and approved study materials.'; c.clear();
    }),child:const Text('ASK')),
  ])));
}

class QuizPage extends StatefulWidget{
  const QuizPage({super.key}); @override State<QuizPage> createState()=>_QuizPageState();
}
class _QuizPageState extends State<QuizPage>{
  int score=0,answered=0;
  void answer(bool correct)=>setState(() { if(correct) score++; answered++; });
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
    const Text('Microscopy Quiz',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    const Text('What is the main function of the objective lens?'),const SizedBox(height:8),
    for(final x in ['To magnify the specimen','To illuminate the room','To hold the microscope'])
      ListTile(title:Text(x),leading:const Icon(Icons.radio_button_unchecked),onTap:()=>answer(x=='To magnify the specimen')),
    const Divider(),Text('Score: $score/$answered'),
    if(answered>0)Text(score==answered?'Correct! 🎉':'Review the topic and try again.'),
  ]));
}

class ProgressPage extends StatelessWidget{
  const ProgressPage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('My Progress')),body:ListView(padding:const EdgeInsets.all(18),children:const[
    ListTile(leading:Icon(Icons.percent),title:Text('Overall progress'),trailing:Text('68%')),
    ListTile(leading:Icon(Icons.quiz),title:Text('Average quiz score'),trailing:Text('82%')),
    ListTile(leading:Icon(Icons.menu_book),title:Text('Topics studied'),trailing:Text('6')),
    ListTile(leading:Icon(Icons.local_fire_department),title:Text('Study streak'),trailing:Text('4 days')),
  ]));
}

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:const[
    CircleAvatar(radius:42,child:Icon(Icons.person,size:45)),SizedBox(height:12),
    Center(child:Text('Student',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold))),
    Center(child:Text('Kenya • University • Education - Agriculture & Biology')),
    SizedBox(height:20),
    Card(child:ListTile(leading:Icon(Icons.school),title:Text('Academic Profile'),subtitle:Text('University of Eldoret'))),
    Card(child:ListTile(leading:Icon(Icons.download),title:Text('Offline Materials'),subtitle:Text('Your downloaded study materials'))),
    Card(child:ListTile(leading:Icon(Icons.emoji_events),title:Text('Achievements'),subtitle:Text('First Quiz • 90% Quiz Score'))),
    const SizedBox(height:12),
    Card(child:ListTile(
      leading:const Icon(Icons.admin_panel_settings),
      title:const Text('Admin Dashboard'),
      subtitle:const Text('Administrator controls'),
      trailing:const Icon(Icons.chevron_right),
      onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const AdminDashboard())),
    )),
  ]));
}
