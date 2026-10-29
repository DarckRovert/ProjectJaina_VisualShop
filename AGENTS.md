# 🤖 Directrices para Agentes de IA — ProjectJaina_VisualShop

> **Documento Maestro de Arquitectura, Restricciones y Memoria Operativa**  
> **Ámbito:** `Client\Interface\AddOns\ProjectJaina_VisualShop\`  
> **Persona:** 'Claude Mythos 5' — Staff Software Engineer (L9)  

---

## 1. Leyes Inviolables de Implementación

1. **Rangos de IDs y Claves Primarias:**
   Cualquier cosmético o efecto visual nuevo debe asignarse obligatoriamente a partir del ID `944000`. Los rangos `940001` a `943018` están permanentemente bloqueados para el catálogo fundacional de alas y auras de temporada.
2. **Sincronización Canónica 1:1 (SSOT):**
   Las tablas contenidas en `Catalog.lua` (lado cliente) y en `59_SpellVisualCatalog.lua` (lado servidor Eluna) deben ser **estrictamente idénticas**. Jamás modificar o agregar un ítem visual en el cliente sin replicarlo exactamente en el backend del servidor.
3. **Orden de Carga del Servidor Eluna:**
   El script del servidor posee el prefijo numérico `59_` (`59_SpellVisualCatalog.lua`). Esto garantiza a nivel de sistema de archivos que se ejecute antes de `70_BattlePassSystem.lua` para que las auras de bonificación de pase estén registradas previamente en memoria.
4. **Sistema de Renderizado por Láminas (Spritesheets):**
   - Las alas animadas utilizan una cuadrícula de 8x4 (32 fotogramas) en archivos TGA/BLP de 256 píxeles por casilla.
   - El cálculo de coordenadas UV debe realizarse mediante la función matemática `Casilla(f)` con `SetTexCoord()`.
   - Prohibido reemplazar la representación por iconos mediante widgets `Model` de FrameXML: los archivos M2 de `Item\ObjectComponents` en WoW 3.3.5a carecen de datos de cámara de visualización y resultan en marcos vacíos.

---

## 2. Invariantes de Red y Protocolo

* **Prefijos Soportados:**
  - Primario: `JAINA_VISUAL` (registrado con `RegisterAddonMessagePrefix`)
  - Alternativo: `WPVS`
  - Compatibilidad: `WP_VISUAL`
* **Comandos de Consola Oficiales:**
  `/visualshop`, `/alas`, `/jainavisual`, `/wpvs`.
* **Seguridad y Persistencia:**
  El AddOn opera en modo cliente ligero; la deducción de monedas y el registro de alas poseídas se realiza en el servidor en la tabla `acore_characters.jaina_visual_spells`.

---

## 3. Checklist Pre-Despliegue

- [ ] Verificado que `Catalog.lua` compila en Lua 5.1 con balance de bloques intacto.
- [ ] Comprobado que los nombres de texturas en `iconos/` no contengan espacios ni caracteres especiales incompatibles con el VFS de MPQ.
- [ ] Validado con `Tests/validate_visualshop.py` (cero advertencias de sintaxis).
