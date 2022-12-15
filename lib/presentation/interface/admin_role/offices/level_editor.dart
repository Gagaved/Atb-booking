import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/workspace_type_repository.dart';
import 'package:atb_booking/logic/admin_role/offices/LevelPlanEditor/level_plan_editor_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

double SCALE_FACTOR = 3.8;

class LevelEditor extends StatelessWidget {
  const LevelEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LevelPlanEditorBloc(),
        child: Column(
          children: const [
            _HorizontalWorkspaceBar(),
            _LevelPlanEditor(),
          ],
        ));
  }
}

class _LevelPlanEditorElementWidget extends StatelessWidget {
  final int id;
  final LevelPlanEditorElementData data;
  final bool isSelect;

  const _LevelPlanEditorElementWidget(
      {required this.data, required this.id, required this.isSelect});

  @override
  Widget build(BuildContext context) {
    var cornerSize = 6*SCALE_FACTOR;
    return Positioned(
      left: data.positionX * SCALE_FACTOR,
      top: data.positionY * SCALE_FACTOR,
      child: Container(
        color: Colors.green,
        height: data.height*SCALE_FACTOR,
        width: data.width*SCALE_FACTOR,
        child: GestureDetector(
          onPanUpdate: (details) {
            print("dx:${details.delta.dx}");
            print("dy:${details.delta.dy}");
            if (isSelect) {
              context.read<LevelPlanEditorBloc>().add(
                  LevelPlanEditorElementMoveEvent(
                      id,
                      data.positionY + (details.delta.dy / SCALE_FACTOR),
                      data.positionX + (details.delta.dx / SCALE_FACTOR)));
            }
          },
          onTap: () {
            context
                .read<LevelPlanEditorBloc>()
                .add(LevelPlanEditorElementTapEvent(id));
          },
          child: Stack(children: [
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  side: !isSelect
                      ? const BorderSide(width: 0.2, color: Colors.black)
                      : BorderSide(width: 4, color: appThemeData.primaryColor),
                  borderRadius: BorderRadius.circular(2.0 * SCALE_FACTOR)),
              shadowColor: !data.isActive
                  ? Colors.grey
                  : isSelect
                      ? const Color.fromARGB(255, 255, 126, 0)
                      : const Color.fromARGB(255, 198, 255, 170),
              elevation: isSelect ? 8 : 3,
              color: !data.isActive
                  ? Colors.grey
                  : isSelect
                      ? const Color.fromARGB(255, 255, 231, 226)
                      : const Color.fromARGB(255, 234, 255, 226),
              child: SizedBox(
                width: data.width * SCALE_FACTOR,
                height: data.height * SCALE_FACTOR,
                child: Padding(
                  padding: EdgeInsets.all(1.0 * SCALE_FACTOR),
                  child: Container(child: data.type.cachedNetworkImage),
                ),
              ),
            ),

            ///
            ///
            /// Левая верхняя точка
            Positioned(
                left: 0, //data.positionX * SCALE_FACTOR,
                top: 0, //data.positionY * SCALE_FACTOR,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<LevelPlanEditorBloc>().add(
                        LevelPlanEditorElementMoveEvent(
                            id,
                            data.positionY + (details.delta.dy / SCALE_FACTOR),
                            data.positionX +
                                (details.delta.dx / SCALE_FACTOR)));
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                          id,
                          data.width + -(details.delta.dx / SCALE_FACTOR),
                          data.height + -(details.delta.dy / SCALE_FACTOR),
                        ));
                  },
                  child: Container(
                    width: cornerSize,
                    height: cornerSize,
                    color: Colors.red,
                  ),
                )),

            ///
            ///
            ///Правая верхня точка
            Positioned(
                right: 0,
                top: 0, //data.positionY * SCALE_FACTOR,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<LevelPlanEditorBloc>().add(
                        LevelPlanEditorElementMoveEvent(
                            id,
                            data.positionY + (details.delta.dy / SCALE_FACTOR),
                            data.positionX));
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                          id,
                          data.width + (details.delta.dx / SCALE_FACTOR),
                          data.height + -(details.delta.dy / SCALE_FACTOR),
                        ));
                  },
                  child: Container(
                    width: cornerSize,
                    height: cornerSize,
                    color: Colors.red,
                  ),
                )),

            ///
            ///
            ///Левая нижняя точка
            Positioned(
                bottom: 0,
                left: 0, //data.positionY * SCALE_FACTOR,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<LevelPlanEditorBloc>().add(
                        LevelPlanEditorElementMoveEvent(
                            id,
                            data.positionY,
                            data.positionX +
                                (details.delta.dx / SCALE_FACTOR)));
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                          id,
                          data.width + -(details.delta.dx / SCALE_FACTOR),
                          data.height + (details.delta.dy / SCALE_FACTOR),
                        ));
                  },
                  child: Container(
                    width: cornerSize,
                    height: cornerSize,
                    color: Colors.red,
                  ),
                )),

            ///
            ///
            ///Правая нижняя точка
            Positioned(
                bottom: 0,
                right: 0, //data.positionY * SCALE_FACTOR,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                          id,
                          data.width + (details.delta.dx / SCALE_FACTOR),
                          data.height + (details.delta.dy / SCALE_FACTOR),
                        ));
                  },
                  child: Container(
                    width: cornerSize,
                    height: cornerSize,
                    color: Colors.red,
                  ),
                )),

            ///
            ///
            /// Левая cтенка для изменения размера
            Positioned(
                left: 0,
                top: 0 + cornerSize,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<LevelPlanEditorBloc>().add(
                        LevelPlanEditorElementMoveEvent(
                            id,
                            data.positionY,
                            data.positionX +
                                (details.delta.dx / SCALE_FACTOR)));
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                      id,
                      data.width + -(details.delta.dx / SCALE_FACTOR),
                      data.height,
                    ));
                  },
                  child: Container(
                    width: cornerSize,
                    height: ((data.height) * SCALE_FACTOR)-(cornerSize*2),
                    color: Colors.blue,
                  ),
                )),
            ///
            ///
            /// Правая cтенка для изменения размера
            Positioned(
                right: 0,
                top: 0 + cornerSize,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<LevelPlanEditorBloc>().add(
                        LevelPlanEditorElementMoveEvent(
                            id,
                            data.positionY,
                            data.positionX));
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                      id,
                      data.width + (details.delta.dx / SCALE_FACTOR),
                      data.height,
                    ));
                  },
                  child: Container(
                    width: cornerSize,
                    height: ((data.height) * SCALE_FACTOR)-(cornerSize*2),
                    color: Colors.blue,
                  ),
                )),
            ///
            ///
            /// Верхняя стенка
            Positioned(
                right: 0 + cornerSize,
                top: 0 ,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<LevelPlanEditorBloc>().add(
                        LevelPlanEditorElementMoveEvent(
                            id,
                            data.positionY + (details.delta.dy / SCALE_FACTOR),
                            data.positionX));
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                      id,
                      data.width ,
                      data.height-(details.delta.dy / SCALE_FACTOR),
                    ));
                  },
                  child: Container(
                    width: ((data.width) * SCALE_FACTOR)-(cornerSize*2),
                    height:cornerSize,
                    color: Colors.blue,
                  ),
                )),

            Positioned(
                bottom: 0,
                left: cornerSize,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context
                        .read<LevelPlanEditorBloc>()
                        .add(LevelPlanEditorElementChangeSizeEvent(
                      id,
                      data.width + (details.delta.dx / SCALE_FACTOR),
                      data.height,
                    ));
                  },
                  child: Container(
                    width: ((data.width) * SCALE_FACTOR)-(cornerSize*2),
                    height:cornerSize,
                    color: Colors.blue,
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}

///
///
///Горизонтальный список с виджетами для размещения на плане.
class _HorizontalWorkspaceBar extends StatelessWidget {
  const _HorizontalWorkspaceBar({Key? key}) : super(key: key);
  static List<WorkspaceType> types = WorkspaceTypeRepository()
      .getMapOfTypes()
      .entries
      .map((e) => e.value)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: types.length,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      types[index].type,
                      style: appThemeData.textTheme.titleSmall,
                      textAlign: TextAlign.right,
                    ),
                    width: 26 * SCALE_FACTOR,
                  ),
                  InkWell(
                    onTap: () {
                      context
                          .read<LevelPlanEditorBloc>()
                          .add(LevelPlanEditorCreateElementEvent(types[index]));
                    },
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(width: 0.2, color: Colors.black),
                          borderRadius: BorderRadius.circular(12.0)),
                      shadowColor: const Color.fromARGB(255, 255, 223, 186),
                      elevation: 3,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        width: 15 * SCALE_FACTOR,
                        height: 15 * SCALE_FACTOR,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child:
                              Container(child: types[index].cachedNetworkImage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _LevelPlanEditor extends StatelessWidget {
  const _LevelPlanEditor({Key? key}) : super(key: key);
  static final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelPlanEditorBloc, LevelPlanEditorState>(
        builder: (context, state) {
      if (state is LevelPlanEditorBaseState) {
        var elements = state.mapOfPlanElements.entries
            .map((e) => _LevelPlanEditorElementWidget(
                  id: e.key,
                  data: e.value,
                  isSelect: state.selectedElementId == e.key,
                ))
            .toList();
        return InteractiveViewer(
          minScale: 0.3,
          maxScale: 4,
          transformationController: _transformationController,
          child: Container(
              color: Color.fromARGB(255, 232, 232, 232),
              width: 100.0 * SCALE_FACTOR,
              height: 100.0 * SCALE_FACTOR,
              child: Stack(
                children: elements,
              )),
        );
      } else if (state is LevelPlanEditorInitial) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        throw Exception('State: $state');
      }
    });
  }
}