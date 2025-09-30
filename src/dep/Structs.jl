#===========================================================================
    IDIOMAS
===========================================================================#

abstract type Idioma end
struct Español <: Idioma end
struct English <: Idioma end
struct Français <: Idioma end



#===========================================================================
    EJERCICIOS
===========================================================================#

struct Ejercicio{T}
    respuesta_usuario::T
    respuesta_correcta::T
    texto_acierto::Union{String, Markdown.MD}
    texto_ayuda::Union{String, Markdown.MD}
end