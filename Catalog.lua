--[[--------------------------------------------------------------------------
  Project Jaina - Tienda de Visuales : CATALOGO
  Version: 2026-08-26

  FUENTE UNICA DE VERDAD.
  Este archivo se despliega IDENTICO en dos sitios:
     servidor -> lua/active/59_SpellVisualCatalog.lua
     cliente  -> Interface/AddOns/WowPeruVisualShop/Catalog.lua

  Para agregar un visual nuevo basta con UNA linea en C.items.
  No hay que tocar ni el servidor ni la interfaz: la paginacion se recalcula sola.

  Campos de cada entrada:
    id     Numero unico y ESTABLE. Es lo que se guarda en la base de datos.
           Nunca reciclar el id de un visual borrado: un jugador podria
           terminar con un visual distinto al que compro.
    name   Texto grande de la tarjeta.
    cat    Categoria. Subtitulo azul de la tarjeta.
    model  Ruta del .m2 dentro del MPQ. Ya NO se usa para pintar la tarjeta
           (ver `icon`), pero se deja porque documenta que modelo es cada
           entrada y lo necesita quien regenere los iconos.
           Va entre corchetes dobles a proposito: en una cadena larga de Lua
           la barra invertida es literal, asi que no hay que duplicarla ni
           hay riesgo de que se rompa el escapado al copiar el archivo.
    icon   Nombre del .tga en WowPeruVisualShop/iconos/, sin extension.
           Es lo que se ve en la tarjeta. Se intento con el widget Model de
           3.3.5 y no hay forma: estos M2 no traen datos de camara y el marco
           no los encuadra. Los iconos se generan renderizando el propio
           modelo, asi que la tarjeta ensena exactamente lo que se va a llevar
           puesto.
    spell  Hechizo del MODELO: el aura que dibuja las alas. Debe existir en
           spell_dbc (servidor) y en Spell.dbc del parche (cliente).
           Vive en 943001-943018. Estuvo en 940001-940018 hasta el 3-sep-2026 y
           hubo que moverlo: Inti tiene ahi un pack de 49 titulos y las alas
           habrian borrado 18 de ellos. Las auras combinadas (941xxx) y las de
           forma (942xxx) NO se movieron, porque su id sale del `id` del ala y
           no de este campo; por eso el cambio no le toco el buff a nadie.
    bonus  OPCIONAL. Hechizo aparte con el efecto de juego (estadisticas,
           velocidad, lo que sea). Va separado del `spell` a proposito: en
           forma de druida hay que esconder el modelo, y si el efecto viviera
           en la misma aura el jugador perderia su bonus al transformarse.
           El servidor quita y devuelve solo el `spell`; el `bonus` no se
           toca nunca mientras el visual siga equipado.
           OJO: las filas de `spell` se clonaron de Ira vengadora, asi que su
           TEXTO de tooltip aun promete "+20% de dano y sanacion". Es solo
           texto heredado: server-side son auras dummy que no hacen nada. Al
           definir bonus de verdad hay que corregir tambien esa descripcion en
           el Spell.dbc del parche, o el tooltip mentira.
    fx     Hechizo puramente visual que se lanza al COMPRAR el ala: una
           nova acorde a su familia. Son hechizos de Blizzard elegidos por
           tener solo efectos inertes, ninguna aura y objetivo "uno mismo",
           asi que no danan, no curan ni meten en combate.
    cost   Cuantas unidades de la moneda cuesta.
----------------------------------------------------------------------------]]

WowPeruVisualCatalog = {}
local C = WowPeruVisualCatalog

-- Version del catalogo. Subirla si algun dia hace falta invalidar cache.
C.version = 1

-- Moneda de la tienda.
C.currency = {
    item = 910000,
    name = "Fichas de evento",
}

-- Cuanto dura una compra, en dias. El ala caduca sola y se puede volver a
-- comprar; al renovar se elige el bonus otra vez, asi que puede cambiarse.
-- Este numero lo leen el servidor Y el cliente del MISMO fichero, para que lo
-- que se cobra y lo que se ensena no puedan separarse.
C.dias = 3

-- Cuadricula de la ventana: 4 columnas x 2 filas = 8 por pagina.
C.columns = 4
C.rows    = 2
C.perPage = 8

--[[
  LOS BONUS.

  Al comprar un ala se elige UNO, y queda pegado a esa ala para siempre: solo
  cuenta el de la que llevas puesta. Comprar otra ala es la via para tener otro
  bonus.

  El multiplicador va POR ENCIMA de las tasas del reino. Los enganches del
  servidor reciben la cantidad ya calculada por el core, que ya incluye las
  tasas, asi que duplicarla deja el resultado en "lo del reino x2": si el reino
  da x3 de experiencia, con este bonus da x6.

  Viven aqui, en el catalogo, y no en el modulo del servidor, porque este
  archivo se despliega IDENTICO en ambos lados. Asi es imposible que el precio
  que ve el jugador y el que cobra el servidor se separen.

    spell   Aura que se le pone al jugador para que VEA el bonus activo con el
            icono de las alitas. No hace nada por si misma: el efecto lo
            aplican los enganches del servidor.
    price   Fichas de evento. Las profesiones valen 5; oro, experiencia y reputacion, 6.
    class/subclass  Solo en los de materiales: identifican que objetos duplicar
            por su clase y subclase, no por listas de ids. Comprobado contra el
            item_template del propio reino.
]]
C.bonus = {
    oro        = { spell = 940101, price = 6, name = "Oro x2",            desc = "Duplica el oro que recibes." },
    exp        = { spell = 940102, price = 6, name = "Experiencia x2",    desc = "Duplica la experiencia que ganas." },
    rep        = { spell = 940103, price = 6, name = "Reputacion x2",     desc = "Duplica la reputacion que ganas." },
    prof       = { spell = 940104, price = 5, name = "Profesiones x2",    desc = "Tus profesiones suben el doble." },
    desuello   = { spell = 940105, price = 5, name = "Desuello x2",       desc = "El doble de cueros al despellejar.", class = 7, subclass = 6 },
    herbo      = { spell = 940106, price = 5, name = "Herboristeria x2",  desc = "El doble de hierbas al recoger.",   class = 7, subclass = 9 },
    mineria    = { spell = 940107, price = 5, name = "Mineria x2",        desc = "El doble de mineral al extraer.",   class = 7, subclass = 7 },
    prospectar = { spell = 940108, price = 5, name = "Prospeccion x2",    desc = "El doble de gemas al prospectar.",  class = 3 },
    moler      = { spell = 940109, price = 5, name = "Molienda x2",       desc = "El doble de pigmentos al moler.",   class = 7, subclass = 11 },
    -- La opcion barata: solo el aspecto, sin ventaja de juego. No lleva
    -- `class` ni `subclass`, asi que ningun enganche del servidor la reconoce
    -- y no hace nada. Su `spell` es 0 porque no existe aura suelta para ella:
    -- como todas, usa la combinada de (ala, bonus).
    -- Este texto se usa en la tarjeta y en el panel de compra, pero NO en el
    -- buff: alli el aura de "ninguno" va sin descripcion, para que encima del
    -- personaje se lea solo el nombre del ala.
    ninguno    = { spell = 0,      price = 4, name = "Sin bonus",         desc = "Solo el aspecto, sin ventaja." },
}

-- Orden estable para la lista. Un `pairs` sobre una tabla no garantiza orden,
-- y los bonus deben salir siempre en el mismo sitio. El orden ADEMAS decide el
-- id del hechizo combinado, asi que no se reordena nunca: mover una clave aqui
-- cambiaria el buff de todo el que ya lo tenga.
-- "ninguno" va AL FINAL a proposito. El indice de esta lista decide el id del
-- hechizo combinado, asi que meterlo en medio le cambiaria el buff a todo el
-- que ya hubiera comprado algo.
C.bonusOrder = { "oro", "exp", "rep", "prof",
                 "desuello", "herbo", "mineria", "prospectar", "moler",
                 "ninguno" }

-- Cuanto multiplica cada bonus.
C.bonusFactor = 2

--[[
  EL AURA COMBINADA.

  Antes habia dos auras encima del jugador: la del ala, con el icono heredado
  de Ira vengadora, y la del bonus. Ahora hay UNA por cada pareja (ala, bonus):
  dibuja las alas igual que antes, pero se llama como el ala, lleva el icono de
  las alitas, explica el bonus en su descripcion y no es disipable ni robable.

  Son 17 x 9 = 153 hechizos generados, y su id sale de esta formula, que
  conocen tanto el cliente como el servidor.
]]
C.bonusIndex = {}
for i, clave in ipairs(C.bonusOrder) do
    C.bonusIndex[clave] = i
end

function C.ComboSpell(wingId, bonusKey)
    local i = C.bonusIndex[bonusKey or ""]
    if not i or not wingId then return nil end
    return 941000 + wingId * 10 + i
end

--[[
  EL AURA "EN FORMA": la misma, pero sin alas.

  Transformado (oso, felino, arbol, fantasma de lobo...) las alas se dibujan
  fatal: cada forma es un modelo con su propio esqueleto y el enganche de la
  espalda solo admite UNA posicion. Por eso hay que esconderlas.

  El problema es que desde que ala y bonus comparten aura, esconderlas se
  llevaba por delante el icono del bonus. Estos clones se llaman igual, llevan
  el mismo icono y dicen el mismo bonus; lo unico que les falta es el modelo
  (`SpellVisualID` a 0). Al transformarse se cambia una por otra.

  "Sin bonus" no tiene clon: su aura no anuncia nada, asi que en forma no hay
  nada que ensenar y el jugador se queda sin buff, que es lo correcto.
]]
function C.FormaSpell(wingId, bonusKey)
    if bonusKey == "ninguno" then return nil end
    local i = C.bonusIndex[bonusKey or ""]
    if not i or not wingId then return nil end
    return 942000 + wingId * 10 + i
end

--[[
  Assets del pack "D3-like wings for WotLK V2".
  3 formas base (Angel, Demon, TwoTone) con sus variantes de color.
  Cada .m2 trae su .skin y su .blp propios.
]]
C.items = {
    -- Angelicales
    { id =  1, name = "Alas Angelicales Blancas",  cat = "Angelicales", model = [[Item\ObjectComponents\Wings\D3AngelWing_White.m2]],    icon = "wing01_angel_white", frames = 32, ms = 1667, fx = 35740, spell = 943001, cost = 1 },
    { id =  2, name = "Alas Angelicales Naranjas", cat = "Angelicales", model = [[Item\ObjectComponents\Wings\D3AngelWing_Orange.m2]],   icon = "wing02_angel_orange", frames = 32, ms = 1667, fx = 35740, spell = 943002, cost = 1 },
    { id =  3, name = "Alas Angelicales Rojas",    cat = "Angelicales", model = [[Item\ObjectComponents\Wings\D3AngelWing_Red.m2]],      icon = "wing03_angel_red", frames = 32, ms = 1667, fx = 35740, spell = 943003, cost = 1 },

    -- Demoniacas
    { id =  4, name = "Alas Demoniacas Rojas",     cat = "Demoniacas",  model = [[Item\ObjectComponents\Wings\D3DemonWing_Red.m2]],      icon = "wing04_demon_red", frames = 32, ms = 1667, fx = 24459, spell = 943004, cost = 1 },
    { id =  5, name = "Alas Demoniacas Azules",    cat = "Demoniacas",  model = [[Item\ObjectComponents\Wings\D3DemonWing_Blue.m2]],     icon = "wing05_demon_blue", frames = 32, ms = 1667, fx = 24459, spell = 943005, cost = 1 },
    { id =  6, name = "Alas Demoniacas Cian",      cat = "Demoniacas",  model = [[Item\ObjectComponents\Wings\D3DemonWing_Cyan.m2]],     icon = "wing06_demon_cyan", frames = 32, ms = 1667, fx = 24459, spell = 943006, cost = 1 },
    { id =  7, name = "Alas Demoniacas Amarillas", cat = "Demoniacas",  model = [[Item\ObjectComponents\Wings\D3DemonWing_Yellow.m2]],   icon = "wing07_demon_yellow", frames = 32, ms = 1667, fx = 24459, spell = 943007, cost = 1 },

    -- Bicolores
    { id =  8, name = "Alas Bicolor Doradas",      cat = "Bicolores",   model = [[Item\ObjectComponents\Wings\D3TwoToneWing_Gold.m2]],   icon = "wing08_two_gold", frames = 32, ms = 1667, fx = 35426, spell = 943008, cost = 1 },
    { id =  9, name = "Alas Bicolor Azules",       cat = "Bicolores",   model = [[Item\ObjectComponents\Wings\D3TwoToneWing_Blue.m2]],   icon = "wing09_two_blue", frames = 32, ms = 1667, fx = 35426, spell = 943009, cost = 1 },
    { id = 10, name = "Alas Bicolor Verdes",       cat = "Bicolores",   model = [[Item\ObjectComponents\Wings\D3TwoToneWing_Green.m2]],  icon = "wing10_two_green", frames = 32, ms = 1667, fx = 35426, spell = 943010, cost = 1 },
    { id = 11, name = "Alas Bicolor Purpuras",     cat = "Bicolores",   model = [[Item\ObjectComponents\Wings\D3TwoToneWing_Purple.m2]], icon = "wing11_two_purple", frames = 32, ms = 1667, fx = 35426, spell = 943011, cost = 1 },

    -- Del Vacio. Sacada de retail con wow.export, ya en M2 v264 (WotLK).
    -- A diferencia de las D3, esta trae una pasada OPACA (render flags=16,
    -- blend=0) ademas de las aditivas, asi que tiene geometria solida de
    -- verdad y no se ve como un haz de luz. Mide 2.06 de ancho por 1.77 de
    -- alto, bastante mas pequena que las D3 (3.81 x 2.96).
    { id = 12, name = "Alas del Vacio",            cat = "Del Vacio",   model = [[item\objectcomponents\collections\collections_armor_voidelf_d_01_wo_f.m2]], icon = "wing12_void", frames = 32, ms = 2000, fx = 24459, spell = 943012, cost = 1 },

    -- Venidas de patch-k. Ese pack NO anadia filas: pisaba filas de Blizzard
    -- ('Shadow Fury Impact' 7088/7089 y 'Demon Wings' 9293), asi que rompia
    -- esos efectos del juego y solo funcionaba si su parche ganaba prioridad.
    -- Aqui sus modelos viven en patch-wowpeA con IDs propios y patch-k ya no
    -- hace falta.
    { id = 13, name = "Alas de Hielo",             cat = "Tera",        model = [[spells\Tera_wings_Ice.m2]],   icon = "wing13_ice",    fx = 32992, spell = 943013, cost = 1 },
    { id = 14, name = "Alas de Fuego",             cat = "Tera",        model = [[spells\Tera_wings_Fire.m2]],  icon = "wing14_fire",   fx = 19823, spell = 943014, cost = 1 },
    { id = 15, name = "Alas de Dragon",            cat = "Dragon",      model = [[spells\Capewingsdragon.m2]],  icon = "wing15_dragon", frames = 32, ms = 2000, fx = 19823, spell = 943015, cost = 1 },

    -- Las alas del paladin. No hubo que importar nada: el modelo ya vive en
    -- common-2.MPQ, el cliente base. Su cadena se clono de la ORIGINAL (efecto
    -- 3146, kit 6840, visual 7880), no de nuestra plantilla, para que se vea
    -- igual que la habilidad: misma escala y mismo enganche al pecho. Por eso
    -- es la unica, junto con Dragon, sin fila propia en
    -- SpellVisualKitModelAttach; la colocacion original ya es la buena.
    { id = 16, name = "Alas de Ira Vengadora",     cat = "Sagradas",    model = [[spells\avengingwrath_state_chest.m2]], icon = "wing16_ira", frames = 32, ms = 367, fx = 35740, spell = 943016, cost = 1 },

    -- Los ids 17 y 19-28 estan RETIRADOS y no se reutilizan: si un id vuelve
    -- con otro visual, quien lo hubiera comprado acabaria con algo distinto a
    -- lo que pago. El 19-28 fueron variantes de color que no convencieron.
    -- El id 17 fue "Alas de Espiritu Guardian" (sacerdote) y se retiro: ese
    -- modelo son 11 emisores de particulas y 0 vertices, asi que giraba
    -- siempre con la camara y no habia forma de dejarlo fijo.
    -- El id 17 NO se reutiliza: un jugador que lo hubiera comprado acabaria
    -- con un visual distinto al que pago.

    -- Venida de patch-C. Ese parche llamaba a su modelo
    -- `Spells\Shadowdance_state.m2`, que es ruta del juego base: instalarlo tal
    -- cual sobrescribia el efecto de Danza de las Sombras del picaro. Aqui vive
    -- renombrado dentro de patch-wowpeA, asi que la habilidad queda intacta.
    -- 851 vertices de malla real (no particulas) mas 6 emisores de brasas.
    { id = 18, name = "Alas de Brasas",            cat = "Demoniacas",  model = [[Spells\WowPeruWings_FoF.m2]], icon = "wing18_brasas", frames = 32, ms = 3750, fx = 19823, spell = 943018, cost = 1 },

}

-- Indice por id. Se construye una sola vez, sirve a servidor y cliente.
C.byId = {}
for _, entry in ipairs(C.items) do
    C.byId[entry.id] = entry
end

function C.PageCount()
    local n = #C.items
    if n == 0 then return 1 end
    return math.ceil(n / C.perPage)
end
