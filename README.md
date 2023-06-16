
------------------------------------------
# **S-PushNotify: Siltium Component for Push Notifications**<br> ![](https://img.shields.io/badge/Dart-Flutter-blue) ![](https://img.shields.io/badge/Android-green) ![](https://img.shields.io/badge/pendiente-iOS-black) <br>


## **Descripción**
Plugin para incluir en proyectos mobile de Siltium que permite el uso de notificaciones push, tanto en Foreground App como en Background y Terminate App.
<br>
<br>

## **Versión**
**0.1.0 - Version inicial** - Notificaciones Push para Android unicamente. Pendiente: Notificaciones Push para iOS (Apple).
<br>
<br>

## **Instalación de la Librería (Android)**
EN FLUTTER:

1) Agregar la libreria en `pubspec.yaml`:
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


## **Uso de la Librería**
Ir a la consola, a la pestaña "Participación" y alli elegir "Messaging". En esta parte vamos a poder mandar mensajes de prueba y campañas.

...

EJEMPLO: