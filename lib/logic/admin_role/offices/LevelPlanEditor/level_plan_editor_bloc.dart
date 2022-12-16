import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/workspace_type_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'level_plan_editor_event.dart';

part 'level_plan_editor_state.dart';

const _HEIGHT = 100.0;
const _WIDTH = 100.0;

/// Все координаты относительно этих значений.class

class _IdGenerator {
  static int _lastId = 0;

  static int getId() {
    _lastId++;
    return _lastId;
  }
}

class LevelPlanEditorBloc
    extends Bloc<LevelPlanEditorEvent, LevelPlanEditorState> {
  final Map<int, LevelPlanEditorElementData> _mapOfPlanElements = {};
  static final Map<int, _Size> _mapLastSize = {
    1: _Size(width: 10, height: 10),
    2: _Size(width: 20, height: 20),
  };
  int levelNumber = 0;
  int? _selectedElementId;

  LevelPlanEditorBloc() : super(LevelPlanEditorInitial()) {
    on<LevelPlanEditorEvent>((event, emit) {
      // TODO: implement event handler
    });

    ///
    ///
    /// Двигаем элемент по плану
    on<LevelPlanEditorElementMoveEvent>((event, emit) {
      _setElementToNewPosition(_mapOfPlanElements[event.id]!,
          event.newPositionX, event.newPositionY);
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    /// меняем активный эелмент isSelect
    on<LevelPlanEditorElementTapEvent>((event, emit) {
      _changeSelectedElement(event.id);
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    ///Добавляем по тапу новый воркплейс на план
    on<LevelPlanEditorCreateElementEvent>((event, emit) {
      var idOfCreatedElement = _addNewElementToPlan(
          event.type, WorkspaceTypeRepository().getMapOfTypes());
      _changeSelectedElement(idOfCreatedElement);

      ///меняем выбраный элемент на созданный
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    /// Изменяем размер
    on<LevelPlanEditorElementChangeSizeEvent>((event, emit) {
      _changeSizeElement(
          _mapOfPlanElements[event.id]!, event.newWidth, event.newHeight);
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    /// Удаляем место
    on<LevelPlanEditorDeleteWorkspaceButtonPressEvent>((event, emit) {
      _deleteElement(_selectedElementId);
      _selectedElementId = null;
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    ///Изменяем номер этажа
    on<LevelPlanEditorChangeLevelFieldEvent>((event, emit) {
      levelNumber = event.newLevel;
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    /// Изменяем описание воркспейса
    on<LevelPlanEditorChangeDescriptionFieldEvent>((event, emit) {
      _changeDescriptionOfElement(_selectedElementId!, event.form);
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    /// Изменяем статус (активно или нет) воркспейса
    on<LevelPlanEditorChangeActiveStatusEvent>((event, emit) {
      _switchActiveStatus(_selectedElementId!);
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });
    ///
    ///
    /// Изменяем количество мест воркспейса
    on<LevelPlanEditorChangeNumberOfWorkplacesFieldEvent>((event, emit) {
      _changeCountOfWorkplaces(_selectedElementId!,event.countOfWorkplaces);
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    ///
    ///
    /// Принудительно обновляет состояние
    on<LevelPlanEditorForceUpdateEvent>((event, emit) {
      emit(LevelPlanEditorMainState(
          mapOfPlanElements: _mapOfPlanElements,
          selectedElementId: _selectedElementId,
          levelNumber: levelNumber));
    });

    emit(LevelPlanEditorMainState(
        mapOfPlanElements: _mapOfPlanElements,
        selectedElementId: _selectedElementId,
        levelNumber: levelNumber));
  }

  /// функция размещает елемент на плане,
  /// проверяя не вышел ли он за рамки,
  /// если вышел то изменяет координаты до корректных
  void _setElementToNewPosition(LevelPlanEditorElementData planElement,
      double newPositionX, double newPositionY) {
    if (newPositionX < 0.0) {
      newPositionX = 0;
    } else if (newPositionX > (_WIDTH - planElement.width)) {
      newPositionX = _WIDTH - planElement.width;
    }
    if (newPositionY < 0.0) {
      newPositionY = 0;
    } else if (newPositionY > (_HEIGHT - planElement.height)) {
      newPositionY = _HEIGHT - planElement.height;
    }
    planElement.positionX = newPositionX;
    planElement.positionY = newPositionY;
  }

  void _changeSelectedElement(int id) {
    if (_selectedElementId == null) {
      _selectedElementId = id;
    } else {
      if (_selectedElementId == id) {
        _selectedElementId = null;
      } else {
        _selectedElementId = id;
      }
    }
  }

  ///
  ///
  /// метод вовращает айди созданого элемента
  int _addNewElementToPlan(WorkspaceType type, mapOfTypes) {
    int id = _IdGenerator.getId();
    if (type.id == 1) {
      _mapOfPlanElements[id] = LevelPlanEditorElementData(
        positionX: 50,
        positionY: 50,
        minSize: 10,
        width: _getLastSize(type.id).width,
        height: _getLastSize(type.id).height,
        numberOfWorkspaces: 1,
        type: type,
        description: 'description type 1',
        isActive: true,
      );
    } else if (type.id == 2) {
      _mapOfPlanElements[id] = LevelPlanEditorElementData(
        positionX: 50,
        positionY: 50,
        minSize: 10,
        width: _getLastSize(type.id).width,
        height: _getLastSize(type.id).height,
        numberOfWorkspaces: 20,
        type: type,
        description: 'description type 2',
        isActive: true,
      );
    } else {
      throw Exception("BAD TYPE ID: ${type.type}");
    }
    return id;
  }

  void _changeSizeElement(LevelPlanEditorElementData levelPlanEditorElementData,
      double newWidth, double newHeight) {
    ///todo добавить проверки на границы
    if (newWidth < levelPlanEditorElementData.minSize) {
      newWidth = levelPlanEditorElementData.minSize;
    }
    if (newHeight < levelPlanEditorElementData.minSize) {
      newHeight = levelPlanEditorElementData.minSize;
    }
    levelPlanEditorElementData.width = newWidth;
    levelPlanEditorElementData.height = newHeight;
    _mapLastSize[levelPlanEditorElementData.type.id] =
        _Size(width: newWidth, height: newHeight);
  }

  ///метод удаляет место
  void _deleteElement(int? selectedElementId) {
    _mapOfPlanElements.remove(selectedElementId);
  }

  _Size _getLastSize(int id) {
    _Size lastSize = _mapLastSize[id]!;
    return lastSize;
  }

  void _changeDescriptionOfElement(
      int selectedElementId, String newDescription) {
    _mapOfPlanElements[selectedElementId]!.description = newDescription;
  }

  /// меняем статус для места
  void _switchActiveStatus(int selectedElementId) {
    _mapOfPlanElements[selectedElementId]!.isActive =
        !(_mapOfPlanElements[selectedElementId]!.isActive);
  }
  /// меняем количество мест в воркспейсе
  void _changeCountOfWorkplaces(int selectedElementId,int count) {
    _mapOfPlanElements[selectedElementId]!.numberOfWorkspaces = count;
  }
}

class _Size {
  final double width;
  final double height;

  _Size({required this.width, required this.height});
}

class LevelPlanEditorElementData {
  double positionX;
  double positionY;
  double minSize;
  double width;
  double height;
  int numberOfWorkspaces;
  String description;
  bool isActive;
  WorkspaceType type;

  LevelPlanEditorElementData({
    required this.positionX,
    required this.positionY,
    required this.minSize,
    required this.width,
    required this.height,
    required this.numberOfWorkspaces,
    required this.type,
    required this.description,
    required this.isActive,
  });
}

class WorkspaceData {
  //final int id;
  final int numberOfWorkspaces;
  final String description;
  final bool isActive;
  final WorkspaceType type;

  WorkspaceData(
      this.numberOfWorkspaces, this.description, this.isActive, this.type);
//final List<Photo> photos; todo найти решение для загрузки фотографий
}
