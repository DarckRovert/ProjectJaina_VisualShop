# 🇵🇪 WoW Perú — VisualShop (Tienda de Cosméticos)

> **WoW Perú Ecosystem** · WotLK 3.3.5a compatible · `Interface: 30300`

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Tienda oficial de efectos visuales, alas, auras y cosméticos del **Reino Andino**. Permite a los jugadores previsualizar, adquirir y equipar cosméticos personalizados en tiempo real comunicándose directamente con el backend autoritativo de Eluna en AzerothCore.

---

## Características

- **Catálogo de Visuales Dinámico** — Previsualización 3D en modelo de personaje antes de comprar.
- **Categorías Cosméticas** — Alas exclusivas, auras ambientales, auras de forma y títulos visuales.
- **Botón de Minimapa con Deadzone** — Botón orbital interactivo con umbral físico para evitar clics accidentales durante el arrastre.
- **Sincronización Atómica** — Protocolo de red por chunks seguros (`OWN`, `EXP`, `FIN`) inmune a pérdidas de paquetes.

## Compatibilidad de Plataforma

- **Cliente:** World of Warcraft 3.3.5a (Build 12340) | `Interface: 30300` | Lua 5.1
- **Backend Servidor:** `59_SpellVisualCatalog.lua` (Eluna Lua Engine / AzerothCore v4.x)
- **Base de Datos:** Tabla `character_spell_visuals` en MySQL.

## Rangos de Spell IDs Reservados

| Tipo de Cosmético | Rango de Hechizos |
|---|---|
| Alas (Modelos HD) | Spells `943001–943018` |
| Títulos Visuales | Spells `940001–940049` |
| Auras Combinadas | Spells `941001–941999` |
| Auras de Forma | Spells `942001–942999` |

## Variables Guardadas

- `WowPeruVisualShopDB` — Preferencias de posición del botón de minimapa y filtros de catálogo.

## 💻 Comandos de Barra (Slash Commands)

| Comando | Acción |
|---|---|
| `/tienda` | Abre o cierra el catálogo de cosméticos y efectos visuales. |
| `/visualshop` | Alias alternativo en inglés para abrir la tienda visual. |
| `/alas` | Acceso directo a la pestaña de alas cosméticas. |
| `/wpvs` | Abreviatura rápida de apertura y cierre. |

## 📥 Instalación en el Cliente WoW

1. Asegúrate de que la carpeta `WowPeruVisualShop` se encuentre dentro de:
   ```
   World of Warcraft/Interface/AddOns/WowPeruVisualShop/
   ```
2. Inicia el cliente de juego WoW Perú y verifica que el accesorio esté activo.
3. Puedes abrir la tienda haciendo clic en el botón del minimapa o escribiendo `/tienda`.

## Créditos y Licencia

- **Autor:** DarckRovert (Ingame: `Elnazzareno`) & WoW Perú Team — [wow-peru.lat](https://wow-peru.lat/)
- **Licencia:** [MIT License](LICENSE)

---

## Documentación del Ecosistema

* [Ficha Técnica Oficial del Ecosistema](ECOSYSTEM_REGISTRY.md)
* [Historial de Cambios](CHANGELOG.md)
* [Aviso Legal y Atribución](NOTICE.md)
* [Licencia MIT Canónica](LICENSE)

---

*Parte del [ecosistema WoW Perú](https://github.com/DarckRovert)*
