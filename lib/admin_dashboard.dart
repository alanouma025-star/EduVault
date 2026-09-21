import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selected = 0;
  final materials = <Map<String, String>>[
    {'title':'Introduction to Microscopy','subject':'Biology','status':'Approved'},
    {'title':'Compound Microscope: Parts and Functions','subject':'Zoology','status':'Pending Review'},
    {'title':'Soil Formation','subject':'Soil Science','status':'Approved'},
    {'title':'Types of Soil','subject':'Soil Science','status':'Pending Review'},
  ];
  final users = <Map<String,String>>[
    {'name':'Demo Student','role':'Student','status':'Active'},
    {'name':'Demo Contributor','role':'Contributor','status':'Active'},
    {'name':'Sample Student','role':'Student','status':'Active'},
  ];
  final subjects = ['Biology','Zoology','Botany','Agriculture','Soil Science'];

  @override Widget build(BuildContext context) {
    final pages = [_home(), _materials(), _users(), _subjects(), _quizzes(), _reports(), _analytics(), _settings()];
    return Scaffold(
      appBar: AppBar(title: const Text('EduVault Admin'), actions:[
        IconButton(onPressed:()=>setState((){}), icon:const Icon(Icons.refresh)),
        IconButton(onPressed:()=>_message('Admin session: Demo Administrator'), icon:const Icon(Icons.account_circle)),
      ]),
      drawer: Drawer(child: SafeArea(child: ListView(children:[
        const DrawerHeader(child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Icon(Icons.admin_panel_settings,size:46), SizedBox(height:10),
          Text('EduVault',style:TextStyle(fontSize:25,fontWeight:FontWeight.bold)), Text('Administrator Dashboard')
        ])),
        _item(Icons.dashboard,'Dashboard',0), _item(Icons.library_books,'Materials',1),
        _item(Icons.people,'Users',2), _item(Icons.category,'Subjects & Topics',3),
        _item(Icons.quiz,'Quizzes',4), _item(Icons.flag,'Reports',5),
        _item(Icons.analytics,'Analytics',6), _item(Icons.settings,'Settings',7),
      ]))),
      body: pages[selected],
      floatingActionButton: (selected==1||selected==3||selected==4) ? FloatingActionButton.extended(
        onPressed:selected==1?_addMaterial:selected==3?_addSubject:_addQuiz,
        icon:const Icon(Icons.add), label:Text(selected==1?'Add material':selected==3?'Add subject':'Create quiz')):null,
    );
  }

  Widget _item(IconData icon,String label,int i)=>ListTile(
    leading:Icon(icon),title:Text(label),selected:selected==i,
    onTap:(){setState(()=>selected=i);Navigator.pop(context);});

  Widget _home()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('Admin Dashboard',style:TextStyle(fontSize:29,fontWeight:FontWeight.bold)),
    const SizedBox(height:5), const Text('Manage EduVault content, users and learning activities.'),
    const SizedBox(height:18),
    Wrap(spacing:10,runSpacing:10,children:[
      _stat('Users','${users.length}',Icons.people), _stat('Materials','${materials.length}',Icons.library_books),
      _stat('Pending','${materials.where((m)=>m['status']=='Pending Review').length}',Icons.pending_actions),
      _stat('Subjects','${subjects.length}',Icons.category), _stat('Quizzes','4',Icons.quiz), _stat('Reports','2',Icons.flag),
    ]),
    const SizedBox(height:22), const Text('Quick actions',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    _quick('Upload / add lecture material',Icons.upload_file,1),
    _quick('Review pending materials',Icons.fact_check,1),
    _quick('Manage users',Icons.manage_accounts,2),
    _quick('Manage subjects and topics',Icons.category,3),
    _quick('Create a quiz',Icons.add_task,4),
  ]);

  Widget _stat(String title,String value,IconData icon)=>SizedBox(width:150,child:Card(child:Padding(padding:const EdgeInsets.all(15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,size:30),const SizedBox(height:8),Text(value,style:const TextStyle(fontSize:25,fontWeight:FontWeight.bold)),Text(title)]))));
  Widget _quick(String title,IconData icon,int page)=>Card(child:ListTile(leading:Icon(icon),title:Text(title),trailing:const Icon(Icons.chevron_right),onTap:()=>setState(()=>selected=page)));

  Widget _materials()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('Materials Management',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),
    const SizedBox(height:6),const Text('Approve, reject, remove and manage learning materials.'),const SizedBox(height:12),
    ...materials.map((m)=>Card(child:ListTile(leading:const Icon(Icons.picture_as_pdf),title:Text(m['title']!),subtitle:Text('${m['subject']} • ${m['status']}'),trailing:PopupMenuButton<String>(onSelected:(v){setState((){if(v=='approve')m['status']='Approved';if(v=='reject')m['status']='Rejected';if(v=='delete')materials.remove(m);});},itemBuilder:(_)=>const[PopupMenuItem(value:'approve',child:Text('Approve & publish')),PopupMenuItem(value:'reject',child:Text('Reject')),PopupMenuItem(value:'delete',child:Text('Delete'))]))))
  ]);

  Widget _users()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('User Management',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    ...users.map((u)=>Card(child:ListTile(leading:CircleAvatar(child:Text(u['name']![0])),title:Text(u['name']!),subtitle:Text('${u['role']} • ${u['status']}'),trailing:PopupMenuButton<String>(onSelected:(v)=>setState(()=>u['status']=v=='suspend'?'Suspended':'Active'),itemBuilder:(_)=>const[PopupMenuItem(value:'suspend',child:Text('Suspend')),PopupMenuItem(value:'restore',child:Text('Restore'))]))))
  ]);

  Widget _subjects()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('Subjects & Topics',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    ...subjects.map((s)=>Card(child:ExpansionTile(title:Text(s),leading:const Icon(Icons.book),children:[
      ListTile(title:const Text('Add topic'),leading:const Icon(Icons.add),onTap:()=>_message('Topic builder will be connected to the database.')),
      const ListTile(title:Text('Manage existing topics'),leading:Icon(Icons.edit_note)),
    ])))
  ]);

  Widget _quizzes()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('Quiz Management',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    _quiz('Microscopy Quiz','10 questions','Published'),_quiz('Introduction to Zoology','15 questions','Draft'),_quiz('Soil Science Basics','20 questions','Published'),
  ]);
  Widget _quiz(String title,String count,String status)=>Card(child:ListTile(leading:const Icon(Icons.quiz),title:Text(title),subtitle:Text('$count • $status'),trailing:const Icon(Icons.chevron_right),onTap:()=>_message('$title selected')));

  Widget _reports()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('Reports & Moderation',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    Card(child:ListTile(leading:const Icon(Icons.flag),title:const Text('Reported material'),subtitle:const Text('Pending review • 1 report'),trailing:FilledButton(onPressed:()=>_message('Report opened for review'),child:const Text('Review')))),
    Card(child:ListTile(leading:const Icon(Icons.person_off),title:const Text('Reported user'),subtitle:const Text('Pending review • 1 report'),trailing:FilledButton(onPressed:()=>_message('User report opened'),child:const Text('Review')))),
  ]);

  Widget _analytics()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('Analytics',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    _metric('Active users','128'),_metric('Materials opened','436'),_metric('Downloads','219'),_metric('Quiz attempts','174'),_metric('Average quiz score','82%'),_metric('Most studied','Microscopy'),
  ]);
  Widget _metric(String a,String b)=>Card(child:ListTile(title:Text(a),trailing:Text(b,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold))));

  Widget _settings()=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('Settings',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    const Card(child:ListTile(leading:Icon(Icons.security),title:Text('Admin security'),subtitle:Text('Role-based access and authentication'))),
    const Card(child:ListTile(leading:Icon(Icons.cloud),title:Text('Storage'),subtitle:Text('Secure PDF/material storage'))),
    const Card(child:ListTile(leading:Icon(Icons.smart_toy),title:Text('AI Tutor'),subtitle:Text('Server-side AI connection'))),
    const Card(child:ListTile(leading:Icon(Icons.policy),title:Text('Content policy'),subtitle:Text('Publish only authorized, open-license or rights-granted material'))),
  ]);

  void _addMaterial(){final t=TextEditingController(),s=TextEditingController(text:'Zoology');showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Add learning material'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:t,decoration:const InputDecoration(labelText:'Material title')),TextField(controller:s,decoration:const InputDecoration(labelText:'Subject')),const SizedBox(height:8),const Text('Demo mode: real PDF upload comes with secure storage.')]),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),FilledButton(onPressed:(){if(t.text.trim().isNotEmpty)setState(()=>materials.add({'title':t.text.trim(),'subject':s.text.trim(),'status':'Pending Review'}));Navigator.pop(context);},child:const Text('Add'))]));}
  void _addSubject(){final c=TextEditingController();showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Add subject'),content:TextField(controller:c,decoration:const InputDecoration(labelText:'Subject name')),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),FilledButton(onPressed:(){if(c.text.trim().isNotEmpty)setState(()=>subjects.add(c.text.trim()));Navigator.pop(context);},child:const Text('Add'))]));}
  void _addQuiz(){_message('Quiz builder: create questions, answers, explanations and publish the quiz.');}
  void _message(String text)=>showDialog(context:context,builder:(_)=>AlertDialog(content:Text(text),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('OK'))]));
}
