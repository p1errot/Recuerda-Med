# 💊 RecuerdaMed

**Versión:** 1.0  
**Fecha:** Junio 2025

RecuerdaMed es una aplicación móvil desarrollada en **Flutter** que permite a los usuarios recordar la toma de medicamentos, programarlos con fecha y hora, y recibir notificaciones. Además, incorpora un sistema de autenticación con inicio de sesión y perfil de usuario.

---

## 📚 Índice

- [� RecuerdaMed](#-recuerdamed)
  - [📚 Índice](#-índice)
  - [📱 Funcionalidades principales](#-funcionalidades-principales)
    - [🔐 Inicio de Sesión](#-inicio-de-sesión)
    - [👤 Perfil de Usuario](#-perfil-de-usuario)
    - [➕ Agregar Medicamentos](#-agregar-medicamentos)
    - [🔔 Notificaciones](#-notificaciones)
    - [📋 Lista de Medicamentos](#-lista-de-medicamentos)
  - [🧪 ¿Cómo funciona?](#-cómo-funciona)
  - [⚙️ Requisitos](#️-requisitos)
  - [🗃️ Almacenamiento local con SQL](#️-almacenamiento-local-con-sql)
  - [👨‍💻 Desarrolladores](#-desarrolladores)
  - [📩 Soporte](#-soporte)

---

## 📱 Funcionalidades principales

### 🔐 Inicio de Sesión
- Registro de usuarios con correo y contraseña.
- Inicio de sesión personalizado.
- Recuperación de contraseña (simulado o implementable con servicios como Firebase).

### 👤 Perfil de Usuario
- Acceso al perfil desde el ícono superior derecho.
- Campos previstos: nombre, correo, foto e información médica relevante (en futuras versiones).

### ➕ Agregar Medicamentos
- Botón “+” para añadir un medicamento.
- Campos: nombre, fecha y hora.
- (En desarrollo) Funciones para editar o eliminar medicamentos.

### 🔔 Notificaciones
- Aviso automático al usuario cuando es hora de tomar el medicamento.

### 📋 Lista de Medicamentos
- Vista general de los medicamentos programados.
- Persistencia de datos con **base de datos SQL local**.

---

## 🧪 ¿Cómo funciona?

1. Abrir la app.
2. Registrarse o iniciar sesión.
3. Agregar un medicamento desde el botón “+”.
4. Recibir notificaciones según el horario programado.

---

## ⚙️ Requisitos

- **Sistema Operativo:** Android 8.0 o superior.
- **Permisos:** Notificaciones activadas.
- **Dependencias recomendadas:**
  - [`sqflite`](https://pub.dev/packages/sqflite): para manejar la base de datos local.
  - `path_provider`: para acceder a rutas del dispositivo.
  - `flutter_local_notifications`: para las alarmas.
  - (Opcional) Firebase Auth.

---

## 🗃️ Almacenamiento local con SQL

RecuerdaMed utiliza una base de datos local SQLite para almacenar:

- Usuarios registrados.
- Medicamentos programados.
- Datos del perfil.

Esto permite que los datos se mantengan aun si se cierra la app o el dispositivo se reinicia.

> ✅ Ideal para aplicaciones sin conexión a internet.

---

## 👨‍💻 Desarrolladores

Este proyecto fue desarrollado por estudiantes como parte de una práctica académica en Flutter.

---

## 📩 Soporte

Si tienes problemas o sugerencias:

📧 recuerda.med.sistema@gmail.com