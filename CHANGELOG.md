# 📋 Registro de Cambios — ProjectJaina_VisualShop

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [1.0.3] — 2026-11-16
### Renovación de Alas Caducadas y Ajustes de Diseño UI (Hito #382)
- **Renovación de Visuales Expirados (`UI.lua`):** Añadidos helpers de vigencia temporal `EstaVigente(id)` y `EstaCaducado(id)` para desbloquear la recompra/renovación tras expirar alas previas (mostrando el botón `"Renovar y elegir bonus"` y estado `"Caducado - Disponible para renovar"` en lugar de bloquear con `"Proximamente"`).
- **Maquetado y Validación (`UI.lua`):** Ajuste geométrico de `title`, `subtitle`, `tokenLabel`, `pageLabel` y `card.cost`, unificación del handler `ADDON_LOADED` y verificación sintáctica limpia con `luac52.exe -p` (exit `0`).

---

## [1.0.2] — 2026-11-10
### Deduplicación Cross-Prefix y Guardas de Metamorfosis/Entrega Offline (Hito #341 / Bug #4)
- **Anti-Eco Cross-Prefix (`UI.lua`):** Añadida ventana de deduplicación (`0.25s`, `lastRecvMsg` / `lastRecvPrefix`) para evitar el procesamiento duplicado de respuestas entre prefijos primario y legacy.
- **Catálogo Visual & Entrega (`59_SpellVisualCatalog.lua`, `66_StoreDeliveryEngine.lua`):** Enrutamiento por prefijo preferido (`playerPrefPrefix`), bloqueo de cambio si `visualSwapInProgress` o en forma druida/chaman (`IsPlayerInShapeshiftForm`), sanitización de `bonusKey` (`[^%a]`) y desactivación previa de visuales activos al entregar offline.

---

## [1.0.1] — 2026-10-10
### Estabilización de Ecosistema y Gobernanza Oficial (Project Jaina)
- **Normalización de UI y Gráficos:** Cuadratura geométrica 1:1 en icono del catálogo (42x42), SetBlendMode('BLEND') y sincronización autoritativa de paquetes OWN, EXP y FIN.
- **Homologación Documental:** Incorporación y actualización formal de `GOVERNANCE.md`, `LICENSE`, `NOTICE.md` y `SECURITY.md`.
- **Licencia Canónica:** Consolidación de licencia MIT 2026 bajo titularidad de DarckRovert & Project Jaina Team.
- **Validación de Runtime:** Verificado al 100% con compilador sintáctico `lua52_compiler.exe -p` con 0 errores y 0 warnings.

---

## [1.0.0] — 2026-10-04
### Lanzamiento Inicial — Ecosistema Project Jaina WotLK 3.3.5a
- Implementación de la arquitectura base para Project Jaina Visual Shop.
- Registro de comandos slash: `/vshop, /visualshop`.
- Persistencia de configuración en `VisualShopDB`.
- Compatibilidad certificada con cliente WotLK 3.3.5a (Build 12340) y directiva `Interface: 30300`.
