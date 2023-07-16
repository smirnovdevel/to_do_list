# Flutter To Do List app

Приложение написано в рамках обучения в Школе Мобильной Разработки Яндекса 2023.

[Скачать](https://github.com/smirnovdevel/to_do_list/releases/download/v.1.0.0-todo/app-release.apk)

![Скриншот](https://github.com/smirnovdevel/to_do_list/assets/122177529/4dd42411-f173-4a12-9207-1cecf4db4577)

### Текущее состояние

Написано API для получения, отправки и удаления задач с бэкенда. Добавлен функционал сохранения задач в локальную базу данных. При создании задачи, она отправляется в бэкенд и сохраняется в базе данных с фиксацией статуса отправки. Синхронизация списка задач выполняется при запуске. Добавлена анимация переходов и заполнения списка. Есть поддержка планшетов и больших экранов. Интерфейс можно посмотреть на https://mytodo.online/
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/a7782f15-dbb9-4cd1-9392-3073dda7555e" alt="drawing" width="600"/>
<br><br>
Навигация переписана на Navigator 2.0 с использованием Riverpod для управлением стейтом.
<br><br>
Реализована работа с Remote Configs, работает рантайм-переключение цвета важности. Цвет используется, в том числе, в loading indicator.
<br><br>
К проекту подключён и настроен Firebase Crashlytics, репортинг ошибок работает.
<br><br>
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/d5820952-2e15-4940-9915-4f38c315a5a1" alt="drawing" width="400"/>
<br><br>
Поддержаны 2 флейвора: для сборки тестинг и прод окружения.
<br><br>
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/f531b598-b579-4cbb-91bf-0c570392102e" alt="drawing" width="400"/>
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/9e64042a-2426-4716-99ca-6b4b0c24a976" alt="drawing" width="400"/>
<br><br>
Настроен CI на GitHub. Скрипт выполняет тестирование, форматирование, проверку линтером, сборку и деплой на Firebase App Distribution.
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/46da50da-5366-453c-85e2-023ff0016d39" alt="drawing" width="400"/>
<br><br>
Управления состоянием в приложении реализовано с помощью пакета [Riverpod](https://pub.dev/packages/riverpod)
<br><br>
Добавлен инструмент для аналитики: Firebase/AppMetrica. Собирается аналитика по событиям: добавление, удаление, выполнение, переходы по экранам.
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/6a69a99a-64d4-493c-8e1f-3af34c5ba50d" alt="drawing" width="400"/>
<br><br>
Локально данные сохраняются в базе с помощью пакета [sqflite](https://pub.dev/packages/sqflite), сетевой трафик на выбор, [dio](https://pub.dev/packages/dio) и [http](https://pub.dev/packages/http). Для обоих реализованы методы в слое `data`. По умолчанию используется http.
<br><br>
При свайпе задач вправо, задача отмечается выполненной, при свайпе влево удаляется из базы. Для удаление задачи требуется подтверждение
<br><br>
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/6cd9e65e-fb51-4c1c-81b1-86c19b793343" alt="drawing" width="400"/>
<br><br>
Для хранения токена используется библиотека [envied](https://pub.dev/packages/envied) Поэтому,для полноценного тестирования необходимо в корневой директории создать файл `.env` с точкой впереди. В него положить свой токен в виде `TOKEN='ваш токен'` 
<br><br>
После этого, необходимо в консоли выполнить команду генерации `flutter pub run build_runner build`
<br><br>
Добавлена обработка ошибок, с выдачей сообщений и без. Например, при отсутсвии интернета будет выдано сообщение, один раз при запуске программы.
<br><br>
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/1ecf2bb6-7cc4-4904-95e9-98392858804f" alt="drawing" width="400"/>
<br><br>
Тестами покрыто больше 80% строк кода
<br><br>
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/1ecd4f23-a337-43bd-80dc-8fabc553e9ca" alt="drawing" width="600"/>
<br><br>
Класс работы с сетью - HttpMock. Класс работы с базой данных скорректирован для состояния тестирования при помощи DI.
Unit тесты покрывают классы работы с сетью, работы с БД и бизнес логикой:
- local data source (создание, редактирование, удаление)
- remote data source (создание, редактирование, удаление)
- state holder (создание, редактирование, удаление)
<br><br>
Кроме unit-тестов написан интеграционный тест покрывающий сценарий добавления задачи. При этом соблюден принцип независимости окружения. Не используется записи в физическую базу данных, и нет обмена с реальным сервером. Т.е. для теста отправки даже не нужен интернет.
<br><br>
<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/8ca80802-bce0-4489-8f2f-3a9588f243b5" alt="drawing" width="400"/>
<br><br>
Добавлена поддержка диплинков
Для тестирования ссылки создающую новую задачу на эмуляторе android используется команда
<br>
`adb shell am start -W -a android.intent.action.VIEW -d app://mytodo.online/new` 
<br>
для ios: `xcrun simctl openurl booted app://mytodo.online/new`
<br><br>
Архитектура приложения построена на принципе Clean Architecture
<br><br>

<img src="https://github.com/smirnovdevel/to_do_list/assets/122177529/c847de1d-1dc9-4e29-ba82-67e763603701" alt="drawing" width="400"/>
