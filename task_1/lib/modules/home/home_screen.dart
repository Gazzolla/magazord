import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_1/modules/home/home_store.dart';
import 'package:task_1/modules/task/task_screen.dart';
import 'package:task_1/shared/models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    GlobalKey remainingSpaceKey = GlobalKey();
    HomeController controller = HomeController();

    return Scaffold(
      backgroundColor: Color(0xfff4f4f4),
      drawerEnableOpenDragGesture: false,
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(0xff0e1f53),
        onPressed: () async {
          var tasks = await showGeneralDialog(
            context: context,
            pageBuilder: (context, animation, secondaryAnimation) => SafeArea(child: TaskScreen()),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          );

          if (tasks != null) {
            controller.addTask(tasks);
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: Color(0xff0e1f53),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xff424d82),
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      "assets/images/magazord_logo.png",
                                      width: 90,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    scaffoldKey.currentState?.closeDrawer();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Color(0xff424d82),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Icon(
                                      FontAwesomeIcons.chevronLeft,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Jeferson Gazzola",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 38),
                          ),
                          SizedBox(height: 40),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              controller.clearTasks();
                              scaffoldKey.currentState?.closeDrawer();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Limpar Atividades",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Tooltip(
                                message: "Não desenvolvido!",
                                triggerMode: TooltipTriggerMode.tap,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.settings_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Configurações",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 30),
          child: LayoutBuilder(builder: (context, constraints) {
            double totalHeight = constraints.maxHeight;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final renderBox = remainingSpaceKey.currentContext?.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                double occupiedHeight = renderBox.size.height + 10;
                controller.setRemainingSpaceValue(totalHeight - occupiedHeight);
              }
            });
            return SingleChildScrollView(
              primary: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    key: remainingSpaceKey,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              scaffoldKey.currentState?.openDrawer();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                FontAwesomeIcons.bars,
                                color: Color(0xff7e86a1),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Observer(builder: (_) {
                              if (!controller.showSearchField) return SizedBox();
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(border: InputBorder.none),
                                        controller: controller.searchController,
                                        onChanged: (value) {
                                          controller.setSearchText(value);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Observer(builder: (_) {
                                      if (controller.searchText.isEmpty) return SizedBox();
                                      return InkWell(
                                        onTap: () {
                                          controller.clearSearchText();
                                        },
                                        child: Icon(Icons.clear),
                                      );
                                    })
                                  ],
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.toggleSearchField();
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Color(0xff7e86a1),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Explicações'),
                                        content: Text(
                                            'A pesquisa funciona tanto para o nome da tarefa como Categoria\n\nExiste uma lista predefinida de atividades, pode ser apagada no Drawer'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Okay'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.help_outline,
                                  color: Color(0xff7e86a1),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        // Segmentado para manter o alinhamento com o Botão para abrir o Drawer
                        padding: EdgeInsets.only(left: 5),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text(
                                "Olá Jeferson!",
                                style: TextStyle(
                                  color: Color(0xff252f59),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Categorias",
                                style: TextStyle(color: Color(0xffa0a4c0), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(height: 15),
                              SizedBox(
                                height: 130,
                                child: Observer(builder: (_) {
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (var i = 0; i < controller.completionResume.length; i++)
                                        Padding(
                                          padding: i < controller.completionResume.length ? EdgeInsets.only(right: 10) : EdgeInsets.zero,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "${controller.completionResume[i].taskQuantity} Atividade${controller.completionResume[i].taskQuantity > 1 ? "s" : ""}",
                                                  style: TextStyle(
                                                    color: Color(0xffa0a4c0),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  controller.completionResume[i].title,
                                                  style: TextStyle(
                                                    color: Color(0xff252f59),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                LinearProgressIndicator(
                                                  value: controller.completionResume[i].progress,
                                                  color: controller.completionResume[i].color,
                                                  backgroundColor: Color(0xffefefef),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Atividades",
                                style: TextStyle(color: Color(0xffa0a4c0), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Observer(builder: (_) {
                    return SizedBox(
                      height: controller.remainingSpace <= 0 ? constraints.maxHeight * 0.7 : controller.remainingSpace,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(right: 30),
                        child: Column(
                          children: [
                            for (var i = 0; i < controller.tasks.length; i++)
                              Observer(builder: (_) {
                                return Padding(
                                  padding: i < controller.tasks.length ? EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                                  child: Dismissible(
                                    confirmDismiss: (direction) async {
                                      return await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirmar Exclusão'),
                                            content: Text('Tem certeza que deseja excluir esta tarefa?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                                child: Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                                child: Text('Excluir'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    key: Key(controller.tasks[i].id),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      controller.tasks.removeAt(i);
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Icon(Icons.delete, color: Colors.white),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: controller.tasks[i].completed,
                                            onChanged: (value) {
                                              controller.tasks[i].completed = value!;
                                            },
                                            activeColor: CategoryIndicators.getColorForCategory(controller.tasks[i].category),
                                            shape: CircleBorder(),
                                          ),
                                          SizedBox(width: 10),
                                          ExtendedText(
                                            controller.tasks[i].title,
                                            joinZeroWidthSpace: true,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 10)
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
