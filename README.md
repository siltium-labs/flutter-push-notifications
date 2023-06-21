
------------------------------------------
# **S-PushNotify: Siltium Component for Push Notifications**<br> ![](https://img.shields.io/badge/Dart-Flutter-blue) ![](https://img.shields.io/badge/Android-green) ![](https://img.shields.io/badge/pendiente-iOS-black) <br>


## **Descripción**
Plugin para incluir en proyectos mobile de Siltium que permite el uso de notificaciones push, tanto en Foreground App como en Background y Terminate App.
<br>
<br>

## **Versión**
**0.1.0 - Versión inicial** - Notificaciones Push para Android únicamente. Pendiente: Notificaciones Push para iOS (Apple).
<br>
<br>

## **Instalación de la Librería (Android)**
EN FLUTTER:

1) Agregar la librería en `pubspec.yaml`:
```yaml
dependencies:
  s_push_notify:
    git:
      url: https://github.com/YamiTeyssier/s-push-notify.git
      ref: development
```
Nota: Si se realizan cambios en la rama de dicho repositorio, es necesario quitar la librería (comentarla), correr el comando `flutter pub get`, volver a agregar la librería (descomentarla) y finalmente volver a correr el comando `flutter pub get`.

PARA ANDROID:

2) Modificar el minSdkVersion a 19 en `project_name\android\app\build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 19
        ...
    }
}
```

EN FIREBASE:

3) En Firebase, Ir a la [Consola Firebase](https://firebase.google.com) y crear un nuevo proyecto:

![Crear nuevo proyecto firebase](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/install_01.png)

Colocarle nombre al nuevo proyecto y continuar:

![Nombrar el nuevo proyecto firebase](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/install_02.png)

También puedes habilitar o deshabilitar Google Analytics. Si lo deshabilitas, seguidamente puedes crear el proyecto. Si no, continúa a la configuración del mismo:

![Habilitar/Deshabilitar google analytics](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/install_03.png)

Al habilitar Google Analytics es necesario configurarlo y aceptar las condiciones de uso. Y finalmente, puedes crear el proyecto:

![Finalizar y crear el proyecto](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/install_04.png)

4) Luego, añadir Firebase a tu aplicación: NuevoProyectoFirebase -> Agregar app -> Flutter<br>

![Crear App de Flutter en Firebase](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/install_05.png)

A continuación, seguir los pasos 1 y 2 de la documentación oficial que se muestran en pantalla.<br>
Nota: Si es la primera vez que usas Firebase con Flutter, realiza los pasos 1 y 2 completos. Si ya lo usaste anteriormente, puedes realizar solo el paso 2 desde el comando `flutterfire configure`.<br>

![Paso 1](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/install_06.png)

![Paso 2](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/install_07.png)

También puedes seguir la guía de la [Documentación oficial para Agregar Firebase en una app de Flutter](https://firebase.google.com/docs/flutter/setup?hl=es-419&platform=android)<br>
(Una vez terminada esta guía, también es necesario ir a NuevoProyectoFirebase -> Agregar app -> Flutter)

<br>

## **Inicialización de la Librería (Android)**
Para agregar y utilizar en tu proyecto el plugin de notificaciones push, primero debes seguir estos pasos:
1) Importar la librería `s_push_notifications` y el archivo `firebase_options.dart` (generado anteriormente con la intalación/configuración de Firebase) en el archivo `main.dart` de tu proyecto:
```dart
// Package and Firebase options file import
import 'package:s_push_notifications/s_push_notifications.dart';
import 'firebase_options.dart';
```

2) Inicializar la librería en `main.dart` con `SPushNotify().init()`, pasando al parámetro `options` un FirebaseOptions, que se encuentra en el archivo `firebase_options.dart`, como se muestra a continuación:
```dart
void main() async {
  await SPushNotify().init(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
```
Nota: No olvidar agregar el async al main().

Ahora ya puedes usar el plugin y las diferentes funcionalidades que contiene.

## **Uso de la Librería**
EN FLUTTER:

1) Primero, para lograr hacer pruebas de envío de notificaciones push con Firebase, vamos a llamar a la función `SPushNotify().getToken()` para obtener el token del dispositivo y enviar dichas notificaciones al mismo:
```dart
void main() async {
  await SPushNotify().init(options: DefaultFirebaseOptions.currentPlatform);
  // Obtenemos el token del dispositivo
  final fcmToken = await SPushNotify().getToken();
  debugPrint("TOKEN: $fcmToken");
  //
  runApp(const MyApp());
}
```
Nota: Cada vez que se realice un `build` de la aplicación, devolverá un token diferente.

2) Seguidamente en tu proyecto, en la pantalla que quieras agregar el manejo de notificaciones, llamar a las siguientes funciones según tu preferencia:
- `SPushNotify().onForegroundNoify()` -> Para manejar las notificaciones push cuando se reciben, mientras la app esta abierta o en primer plano (Foreground App).
- `SPushNotify().onBackgroundNotify()` -> Para manejar las notificaciones push cuando se reciben, mientras la app esta cerrada o en segundo plano (Terminated y Background App).
- `SPushNotify().onTapBackgroundNotify()` -> Para manejar las notificaciones push al ser presionadas o seleccionadas desde la barra de notificaciones, mientras la app esta cerrada o en segundo plano (Terminated y Background App).

IMPORTANTE:<br>
La función que se utilice en `SPushNotify().onBackgroundNotify()` para manejar las notificaciones, debe tener la siguiente estructura:
```dart
@override
  void initState() {
    super.initState();
    _onReceiveBackgroundNotify();
  }

_onReceiveBackgroundNotify() async {
    await SPushNotify().onBackgroundNotify(_onBackgroundMessage);
  }

  // Esta función debe seguir la siguiente estructura:
  // 1) Si usas Flutter 3.3.0 o una versión posterior, debe tener la siguiente anotación justo encima de la declaración de la función:
  @pragma('vm:entry-point')
  // 2) La función no debe ser anónima.
  // 3) Y la función no debe ser de nivel superior (por ejemplo, no un método de clase que requiera inicialización)
  // o bien, debe ser una funcion "static".
  static Future<void> _onBackgroundMessage(message) async {
    // Tú código para manejo de Background Notifications;
  }
```
<br>

EN FIREBASE:

3) Entrar en la [Consola de Firebase](https://firebase.google.com), en la pestaña "Participación" del menú lateral y allí elegir "Messaging". En esta parte vamos a poder mandar mensajes de prueba y campañas:

![Prueba push notifications firebase 1](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/usage_01.png)

4) Ir a "Campaña nueva":

![Prueba push notifications firebase 2](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/usage_02.png)

5) En esta pantalla completar los datos que quieras enviar en la notificación push de prueba, y luego en "Enviar mensaje de prueba" agregar el token de tu dispositivo (obtenido anteriormente, en el paso 1). Entonces, al presionar "Probar" se enviará la notificación de prueba solamente al dispositivo cuyo token agregamos:

![Prueba push notifications firebase 3](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/usage_03.png)

![Prueba push notifications firebase 4](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/usage_04.png)

6) Una vez realizada la prueba y recibida la notificación push, ahora si podemos realizar una nueva campaña. Del mismo modo que el paso anterior, completamos los datos en la pantalla de "Campaña nueva" y al final de la misma hacemos click en "Revisar" y "Publicar":

![Prueba push notifications firebase 5](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/usage_05.png)

![Prueba push notifications firebase 6](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/usage_06.png)

![Prueba push notifications firebase 7](https://github.com/YamiTeyssier/s-push-notify/blob/development/assets/readme_images/usage_07.png)
<br>

## **EJEMPLO**
Ejemplo de [home_page.dart](https://github.com/YamiTeyssier/s-push-notify/blob/development/example/lib/home_page.dart), que se encuentra en la carpeta example de este plugin.

```dart
import 'package:flutter/material.dart';
import 'package:s_push_notifications/s_push_notifications.dart';
import 'package:s_push_notifications_example/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Home Page',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _navigate(),
            child: const Text("Navegar a Notification Page"),
          )
        ],
      ),
    );
  }

  // FUNCIONES --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _onReceiveForegroundNotify();
    _onReceiveBackgroundNotify();
    _onTapBackgroundNotify();
  }

  _navigate() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const NotificationPage()),
      ),
    );
  }

  _onReceiveForegroundNotify() async {
    await SPushNotify().onForegroundNoify(
      (message) {
        debugPrint("-----RECEIVE FOREGROUND NOTIFY-----");
        debugPrint("Title: ${message.notification?.title}");
        debugPrint("Body: ${message.notification?.body}");
        debugPrint("Payload: ${message.data}");
        debugPrint("----------------------------------------------");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Notify: ${message.notification?.title}")));
      },
    );
  }

  _onReceiveBackgroundNotify() async {
    await SPushNotify().onBackgroundNotify(_onBackgroundMessage);
  }

  _onTapBackgroundNotify() async {
    await SPushNotify().onTapBackgroundNotify(
      (message) {
        debugPrint("-----ONTAP BACKGROUND/TERMINATED NOTIFY-----");
        debugPrint("Title: ${message.notification?.title}");
        debugPrint("Body: ${message.notification?.body}");
        debugPrint("Payload: ${message.data}");
        debugPrint("----------------------------------------------");
        _navigate();
      },
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessage(message) async {
    debugPrint("-----RECEIVE BACKGROUND/TERMINATED NOTIFY-----");
    debugPrint("Title: ${message.notification?.title}");
    debugPrint("Body: ${message.notification?.body}");
    debugPrint("Payload: ${message.data}");
    debugPrint("----------------------------------------------");
  }
}
```