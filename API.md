# 🔌 Especificación Técnica y API — WowPeruVisualShop

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FWowPeruVisualShop-black?logo=github)](https://github.com/DarckRovert/WowPeruVisualShop)
[![Ecosistema](https://img.shields.io/badge/Ecosistema-WoW%20Per%C3%BA%203.3.5a-gold.svg)](https://projectjaina.com/)

## 📌 Resumen Arquitectónico
Tienda in-game para previsualizar y adquirir auras cosméticas, alas, efectos de armas e ilusiones visuales sincronizadas con backend Eluna 59_SpellVisualCatalog.lua.

- **Rol en el Ecosistema:** Módulo Oficial #2 — Tienda de Visuales
- **Archivo Principal TOC:** `WowPeruVisualShop.toc`
- **Compatibilidad del Motor:** World of Warcraft 3.3.5a (Build 12340)

---

## ⌨️ Comandos de Consola (Slash Commands)
- `/tienda`: Acceso principal o comando del addon.
- `/alas`: Acceso principal o comando del addon.
- `/visualshop`: Acceso principal o comando del addon.
- `/wpvs`: Acceso principal o comando del addon.

---

## 📡 Protocolo de Red y Eventos
- `WPVS:SYNC`: Prefijo registrado para sincronización de datos.
- `WPVS:BUY`: Prefijo registrado para sincronización de datos.
- `WPVS:OWN`: Prefijo registrado para sincronización de datos.

### Eventos del Motor 3.3.5a Gestionados
- `PLAYER_LOGIN` / `ADDON_LOADED`: Inicialización atómica de tablas de configuración y hooks.
- `PLAYER_ENTERING_WORLD`: Sincronización de estado tras transiciones de pantalla o mapa.
- `PLAYER_LOGOUT`: Guardado seguro en disco de las variables locales.

---

## 💾 Persistencia de Datos (SavedVariables)
- `WowPeruVisualShopDB`: Almacenamiento estructurado de configuración y estado persistente.

---

## 🛠️ Buenas Prácticas de Integración
1. Toda invocación a funciones públicas debe verificar previamente la existencia del espacio de nombres en `_G`.
2. Las tablas de configuración deben consultarse en modo lectura sin sobreescribir valores por omisión no validados.
3. El intercambio de datos con otros addons debe efectuarse a través del bus oficial `Wanos_Companion` o hooks de eventos estándar.
