# 🌐 Registro de Ecosistema — WowPeruVisualShop

## Prefijo de Red

| Prefijo | Canal | OpCodes |
|---|---|---|
| `WP_VISUAL` | `WHISPER` | `REQ_CATALOG`, `BUY_VISUAL:<id>`, `EQUIP_VISUAL:<id>` |

## Tablas MySQL

| Tabla | Sistema | Clave | Limpieza en Delete |
|---|---|---|---|
| `character_visuals` | VisualShop | `(guid, visual_id)` Composite PK | Obligatoria |

## Rangos DBC Reservados

| Tipo | Rango de Spell IDs |
|---|---|
| Alas | `943001–943018` |
| Títulos | `940001–940049` |
| Auras Combinadas | `941001–941999` |
| Auras Forma | `942001–942999` |
| **Próximos cosméticos** | A partir de `944000` |

## Script Eluna

`59_SpellVisualCatalog.lua` — carga antes que BattlePass (prefijo `59_` garantiza orden lexicográfico).
