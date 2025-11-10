# PlutoNotesGJGB

Colección de utilidades para crear notas interactivas en Julia/Pluto: cuadros de texto estilizados, un formato especial para citas clave, listas y corrección de ejercicios.

## Qué incluye

- Componentes HTML/CSS para cuadros de texto consistentes (clase base + modificadores de color).
- Funciones simples para insertar citas (`cita`), resaltados (`resaltar`), enlaces (`enlace`).
- `lista(...)`: genera listas ordenadas o no ordenadas a partir de vectores o argumentos (acepta `String`, `Markdown.MD` y `HTML`).
- Preferencias de idioma (usa `Preferences.jl`).

## Instalación

Actualmente, el paquete no está oficialmente registrado, pero puede ser cargado directamente desde el repositorio GitHub. En una celda de tu cuaderno Pluto, escribe:

```julia
begin
    using Pkg
    Pkg.add(url="https://github.com/TavoJGB/PlutoNotesGJGB.jl")
    using PlutoNotesGJGB
end
```

## Uso

Cuadros de texto (ejemplos):

```julia
using PlutoNotesGJGB

concepto("Concepto", "La $(HTML(resaltar("paralelización"))) permite asignar tareas a distintos núcleos de tu ordenador, permitiendo ejecutar distintas partes de tu código (por ejemplo, distintas iteraciones de un bucle) de forma simultánea.")
truco("Truco", "La paralelización disminuye el tiempo de computación.")
consejo("Consejo", "Si tu código es lento, prueba a paralelizarlo.")
atencion("Atención", "Al parelizar, cada hilo se ejecuta de forma independiente.")
peligro("Peligro", "Si distintos hilos intentan cambiar la misma variable, tendrás problemas.")
```

`lista` — ejemplos:

```julia
lista(["Hola", "¿Cómo estás?", "Adiós"])            # lista ordenada
lista("Uno", "Dos", "Tres")                         # sintaxis varargs
lista([md"**Fuerte**", md"_Cursiva_"], tipo="ul")   # lista no ordenada con Markdown

# Quitar indent (margen izquierdo):
lista(["a","b"], tipo="ul", indent=false)
```

Nota: cuando quieras mostrar una lista dentro de una celda en una tabla Markdown, primero guarda la lista en una variable y luego interpólala:

```julia
l1 = lista("Punto A", "Punto B")
md"""
| Col A | Col B |
|:----:|:----:|
| $(l1) | Texto |
"""
```

## Preferencias de idioma

`PlutoNotesGJGB.jl` usa `Preferences.jl` para guardar la preferencia de idioma del usuario.

```julia
set_language!("en")   # cambiar a English (reinicia Julia para aplicar)
get_language()         # devuelve la preferencia actual (p. ej. "español")
```

El módulo carga automáticamente la preferencia `idioma` al iniciarse.

## Personalizar estilos

El CSS base está incluido en `src/dep/Functions.jl` (constante `CUADROS_CSS`). Si quieres cambiar padding, tamaños o colores, edita esa sección. Para desarrollo en notebooks puedes forzar la inclusión del CSS con:

```julia
inicializar_estilos()  # Inserta el bloque CSS (útil si reseteaste con resetear_css())
resetear_css()         # marca el CSS como no incluido (útil para pruebas)
```

Si prefieres reglas globales en lugar de estilos inline (por ejemplo para `lista(..., indent=false)`), puedes añadir una clase en `CUADROS_CSS` y usarla desde la función `lista`.

## Licencia

Revisa el fichero `LICENSE` en este repositorio para los términos de uso.