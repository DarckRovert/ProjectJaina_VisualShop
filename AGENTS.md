# 🤖 Reglas de Agente IA — ProjectJaina_VisualShop

> **Ámbito:** `d:\Project Jaina\Client\Interface\AddOns\ProjectJaina_VisualShop\`

## Restricciones Críticas

1. **Rangos de IDs:** Cualquier cosmético nuevo debe asignarse a partir de `944000`. Los rangos `940001-943018` están bloqueados.
2. **Sincronización 1:1:** Las tablas de `Catalog.lua` (cliente) y `59_SpellVisualCatalog.lua` (servidor) deben ser idénticas. Nunca modificar uno sin el otro.
3. **Script Eluna prefijo `59_`:** Garantiza que este script se carga ANTES de `70_BattlePassSystem.lua`.
4. **Prefijo de red `WP_VISUAL`:** Exclusivo de este addon.
