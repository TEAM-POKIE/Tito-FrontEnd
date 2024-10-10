# tito_app

## Retrofit build

- 아래 명령어 실행 후 `flutter run` 실행할 것

```
dart run build_runner build
```

## Resolving Errors

`RenderBox was not laid out `

- Flutter 레이아웃 시스템에서 위젯이 예상대로 배치되지 않았을 때 나타난다.
  - 주로 ListView, GridView, Column과 같은 scroll이 가능한 위젯 내부에 고정된 크기가 없는 위젯을 배치할 때 발생함

* [x] ListView를 Expanded로 감싸기 (고정 크기 위젯 내에 들어가 있어야 하므로)

Stack 위젯 사용 시, 위젯들을 쌓아서 위치시키기 위해 Container를 지정하며 각 Container의 크기를 지정해 위젯들을 배치해 주는데 이 부분을 까먹음 !

## Flutter의 상태관리 : Riverpod

플러터에서 말하는 상태는 2가지 의미를 가지고 있다.

1. UI에 변화를 주는 데이터
2. 위의 데이터를 관리하기 위해 만들어진 State class

- Flutter 같은 선언형 framework는 UI를 변경하기 위해 위젯을 다시 빌드해야 한다. 따라서, 위젯을 update 하는 방법이 중요하다.

- createState() 를 호출해 상태를 별도의 State 클래스에 저장함

  - setState() 를 호출하면, build() 가 호출도며 상태를 수정할 수 있지만, A라는 위젯에서 setState() 호출 시, 해당 위젯과 하위 위젯이 전부 build()가 호출되어 불필요한 렌더링이 발생하는 문제가 있다.
  - 상태를 전달해서 사용하는 방법이 아닌 모든 위젯이 데이터를 공유하는 방법이 있다.

  1. GetX
  2. BLoC
  3. Provider
  4. RiverPod
     - Flutter에 의존하지 않는다
     - 컴파일타임 동안 안전하다
     - Provider의 단점이 보완된 라이브러리이다.

  ### Provider와 상호작용하기 위한 ref의 주요 사용 방법

  **ref.watch:Provider** : 상태 변화를 화면에 즉각 반영해야 할 때 사용함
  **ref.read:Provider** : 상태를 가져오고 값 변경 가능
  **ref.listen:watch** : 위젯을 rebuild 하거나 상태를 전달하지 않고 값이 변경될 때 정의한 함수를 실행한다.

## Designs

1. 화면의 크기에 맞춰 위젯 크기 동적으로 조정하기

- 다양한 크기의 화면에서 일관된 UI 제공가능
  `MediaQuery.of(context).size.width & MediaQuery.of(context).size.height`
