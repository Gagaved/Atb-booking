import 'dart:async';
import 'dart:io';

import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/level_plan_provider.dart';
import 'package:atb_booking/data/services/workspace_provider.dart';
import 'package:atb_booking/data/services/workspace_type_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'level_plan_editor_event.dart';

part 'level_plan_editor_state.dart';

const _HEIGHT = 1000.0;
const _WIDTH = 1000.0;

/// Все координаты относительно этих значений.class

class LevelPlanEditorBloc
    extends Bloc<LevelPlanEditorEvent, LevelPlanEditorState> {
  final Map<int, LevelPlanElementData> _mapOfPlanElements = {};
  static final Map<int, _Size> _mapLastSize = {
    1: _Size(width: 100, height: 100),
    2: _Size(width: 200, height: 200),
  };
  int levelNumber = 0;
  int? backgroundImagePlanId;

  /// это айди картинки этажа
  int? _selectedElementId;
  List<int>? _selectedWorkspacePhotosIds;
  int? _levelId;

  Timer? _debounce;

  _onChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      print("_onChanged() add event send server changes");
      add(LevelPlanEditorSendChangesToServerEvent());
    });
  }

  LevelPlanEditorBloc() : super(LevelPlanEditorInitial()) {
    ///
    ///
    /// удаляем этаж
    on<LevelPlanEditorDeleteLevelEvent>((event, emit) async {
      await LevelProvider().deleteLevel(_levelId!);

      ///не знаю как нужно сделать
    });

    ///
    ///
    /// Двигаем элемент по плану
    on<LevelPlanEditorElementMoveEvent>((event, emit) async {
      _setElementToNewPosition(_mapOfPlanElements[event.id]!,
          event.newPositionX, event.newPositionY);
      _onChanged();

      add(LevelPlanEditorForceUpdateEvent());
    });

    ///
    ///
    /// Изменяем выбранный элемент
    on<LevelPlanEditorSelectElementEvent>((event, emit) {
      _selectedElementId = event.id;
      add(LevelPlanEditorForceUpdateEvent());
    });
    on<LevelPlanEditorDeselectElementEvent>((event, emit) {
      _selectedElementId = null;
      add(LevelPlanEditorForceUpdateEvent());
    });

    ///
    ///
    ///Добавляем по тапу новый воркплейс на план
    on<LevelPlanEditorCreateElementEvent>((event, emit) async {
      try {
        var element = _createNewElement(
            event.type, WorkspaceTypeRepository().getMapOfTypes(), _levelId!);
        int idOfCreatedWorkspace = await WorkspaceProvider()
            .createWorkspaceByLevelPlanEditorElementData(element);
        element.id = idOfCreatedWorkspace;
        _mapOfPlanElements[idOfCreatedWorkspace] = element;
        _selectedElementId = idOfCreatedWorkspace;
        add(LevelPlanEditorForceUpdateEvent());
      } catch (_) {
        //todo add logic
      }
    });

    ///
    ///
    /// Изменяем размер
    on<LevelPlanEditorElementChangeSizeEvent>((event, emit) async {
      _changeSizeElement(
          _mapOfPlanElements[event.id]!, event.newWidth, event.newHeight);
      await _onChanged();
      add(LevelPlanEditorForceUpdateEvent());
    });

    ///
    ///
    /// Удаляем место
    on<LevelPlanEditorDeleteWorkspaceButtonPressEvent>((event, emit) async {
      try {
        if (_selectedElementId == null) {}
        int id = _selectedElementId!;
        _selectedElementId = null;
        await WorkspaceProvider().deleteById(id);
        _deleteElement(id);
        add(LevelPlanEditorForceUpdateEvent());
      } catch (_) {
        print(_);
      }
    });

    ///
    ///
    ///Изменяем номер этажа
    on<LevelPlanEditorChangeLevelFieldEvent>((event, emit) {
      var oldValue = levelNumber;
      try {
        levelNumber = int.parse(event.newLevelForm);
        try {
          ///передаю пустой массив потому что я их все равно не сериализую
          ///По-хорошему - переделать
          var levelInfo = Level(
              id: _levelId!,
              planId: backgroundImagePlanId,
              number: levelNumber,
              workspaces: []);
          LevelProvider().putNewLevelInfo(levelInfo);
        } catch (_) {
          print(_);
          levelNumber = oldValue;
        }
        ;
        add(LevelPlanEditorForceUpdateEvent());
      } catch (_) {
        print(_);
      }
    });

    ///
    ///
    /// Изменяем описание воркспейса
    on<LevelPlanEditorChangeDescriptionFieldEvent>((event, emit) {
      _changeDescriptionOfElement(_selectedElementId!, event.form);
      _onChanged();
      add(LevelPlanEditorForceUpdateEvent());
    });

    ///
    ///
    /// Изменяем статус (активно или нет) воркспейса
    on<LevelPlanEditorChangeActiveStatusEvent>((event, emit) {
      _switchActiveStatus(_selectedElementId!);
      _onChanged();
      add(LevelPlanEditorForceUpdateEvent());
    });

    ///
    ///
    ///
    /// Изменяем количество мест воркспейса
    on<LevelPlanEditorChangeNumberOfWorkplacesFieldEvent>((event, emit) {
      _changeCountOfWorkplaces(_selectedElementId!, event.countOfWorkplaces);
      _onChanged();
      add(LevelPlanEditorForceUpdateEvent());
    });

    ///
    ///
    /// обновляет состояние, основной эвент который вызываетяс другими, по требованию
    on<LevelPlanEditorForceUpdateEvent>((event, emit) {
      var listOfElem = <LevelPlanElementData>[];
      int? selectedIndex;
      int tmp = 0;
      _mapOfPlanElements.entries.map((e) {
        if (e.key == _selectedElementId) selectedIndex = tmp;
        tmp++;
        listOfElem.add(e.value);
      }).toList();
      //загружаем фотки
      if (_selectedElementId != null) {
        _selectedWorkspacePhotosIds =
            _mapOfPlanElements[_selectedElementId]!.photosIds;
      } else {
        _selectedWorkspacePhotosIds = [];
      }
      emit(LevelPlanEditorMainState(
          listOfPlanElements: listOfElem,
          selectedElementIndex: selectedIndex,
          levelNumber: levelNumber,
          levelPlanImageId: backgroundImagePlanId,
          selectedWorkspacePhotosIds: _selectedWorkspacePhotosIds!));
    });

    ///
    ///
    /// Загружаем этаж с сервера
    on<LevelPlanEditorLoadWorkspacesFromServerEvent>((event, emit) async {
      if (_levelId != event.levelId) {
        emit(LevelPlanEditorLoadingState());
        _selectedElementId = null;
      }
      _levelId = event.levelId;
      try {
        var levelPlan = await LevelProvider().getPlanByLevelId(_levelId!);

        //backgroundImagePlanId = levelPlan.planId; todo remove comment
        levelNumber = levelPlan.number;
        _mapOfPlanElements.clear();
        backgroundImagePlanId = levelPlan.planId;
        print('ids of fetching workspaces:[');
        for (var elem in levelPlan.workspaces) {
          print(elem.id);
          _mapOfPlanElements[elem.id!] = elem;
        }
        print("]");
        if (event.preselectWorkspaceId != null) {
          if (_mapOfPlanElements[event.preselectWorkspaceId] != null) {
            _selectedElementId = event.preselectWorkspaceId;
          }
        }
        add(LevelPlanEditorForceUpdateEvent());
      } catch (_) {}
    });

    on<LevelPlanEditorDeleteWorkspacePhotoEvent>((event, emit) async {
      try {
        event.imageId;
        await WorkspaceProvider().deletePhotoOfWorkspaceById(event.imageId);
      } catch (_) {
        print(_);
      }
      add(LevelPlanEditorLoadWorkspacesFromServerEvent(_levelId!));
    });

    ///
    ///
    /// Добавляем фотки к рабочему месту
    on<LevelPlanEditorAddImageToWorkspaceButtonEvent>((event, emit) async {
      try {
        final imageFromPicker =
            (await ImagePicker().pickImage(source: event.source));
        if (imageFromPicker == null) return;
        final imageFile = File(imageFromPicker.path);
        try {
          //int idOfCreatedImage = await AppImageProvider.upload(imageFile);
          await WorkspaceProvider()
              .uploadWorkspacePhoto(imageFile, _selectedElementId!);
        } catch (_) {
          print(_);
        }
      } on PlatformException catch (e) {
        print(e);
      }
      add(LevelPlanEditorLoadWorkspacesFromServerEvent(_levelId!));
    });

    ///
    ///
    /// Добавляем фотки на задник плана
    on<LevelPlanEditorChangeBackgroundButtonEvent>((event, emit) async {
      //todo
      try {
        final imageFromPicker =
            (await ImagePicker().pickImage(source: ImageSource.gallery));
        if (imageFromPicker == null) return;
        final imageFile = File(imageFromPicker.path);
        try {
          await LevelProvider().addImageToPlanByIds(imageFile, _levelId!);
        } catch (_) {
          print(_);
        }
      } on PlatformException catch (e) {
        print(e);
      }
      add(LevelPlanEditorLoadWorkspacesFromServerEvent(_levelId!));
    });

    ///
    ///
    /// Загружаем воркплейсы на сервер
    on<LevelPlanEditorSendChangesToServerEvent>((event, emit) async {
      try {
        print("send ids:[");
        List<LevelPlanElementData> listOfChangedWorkspaces =
            _mapOfPlanElements.entries.map((e) {
          print(e.value.id);
          return e.value;
        }).toList();
        print("]");
        await WorkspaceProvider()
            .sendWorkspacesChangesByLevelId(listOfChangedWorkspaces);
        //add(LevelPlanEditorLoadWorkspacesFromServerEvent(_levelId!));
      } catch (_) {
        print(_);
        print("^277^ ids:[");
        for (var elem in _mapOfPlanElements.entries) {
          print(elem.value.id);
        }
        print("]");
        add(LevelPlanEditorLoadWorkspacesFromServerEvent(_levelId!));
      }
    });
  }

  /// функция размещает елемент на плане,
  /// проверяя не вышел ли он за рамки,
  /// если вышел то изменяет координаты до корректных
  void _setElementToNewPosition(LevelPlanElementData planElement,
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

  //
  // void _changeSelectedElement(int id) {
  //   if (_selectedElementId == null) {
  //     _selectedElementId = id;
  //   } else {
  //     if (_selectedElementId == id) {
  //       _selectedElementId = null;
  //     } else {
  //       _selectedElementId = id;
  //     }
  //   }
  // }

  ///
  ///
  /// метод вовращает айди созданого элемента
  LevelPlanElementData _createNewElement(
      WorkspaceType type, mapOfTypes, int levelId) {
    if (type.id == 1) {
      return LevelPlanElementData(
          positionX: 50,
          positionY: 50,
          width: _getLastSize(type.id).width,
          height: _getLastSize(type.id).height,
          numberOfWorkspaces: 1,
          type: type,
          description: '',
          isActive: true,
          levelId: _levelId);
    } else if (type.id == 2) {
      return LevelPlanElementData(
          positionX: 50,
          positionY: 50,
          width: _getLastSize(type.id).width,
          height: _getLastSize(type.id).height,
          numberOfWorkspaces: 20,
          type: type,
          description: '',
          isActive: true,
          levelId: _levelId);
    } else {
      throw Exception("BAD TYPE ID: ${type.type}");
    }
  }

  void _changeSizeElement(LevelPlanElementData levelPlanEditorElementData,
      double newWidth, double newHeight) {
    ///todo добавить проверки на границы
    if (newWidth < 60) {
      newWidth = 60;
    }
    if (newHeight < 60) {
      newHeight = 60;
    }
    levelPlanEditorElementData.width = newWidth;
    levelPlanEditorElementData.height = newHeight;
    _mapLastSize[levelPlanEditorElementData.type.id] =
        _Size(width: newWidth, height: newHeight);
  }

  ///метод удаляет место
  void _deleteElement(int id) {
    _mapOfPlanElements.remove(id);
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
  void _changeCountOfWorkplaces(int selectedElementId, int count) {
    _mapOfPlanElements[selectedElementId]!.numberOfWorkspaces = count;
  }
}

class _Size {
  final double width;
  final double height;

  _Size({required this.width, required this.height});
}
