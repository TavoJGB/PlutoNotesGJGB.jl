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
    # Constructor
    Ejercicio(respuesta_usuario::T, respuesta_correcta::T; texto_acierto="", texto_ayuda="") where {T<:Any} = new{T}(respuesta_usuario, respuesta_correcta, texto_acierto, texto_ayuda)
    # Constructor cuando respuesta viene de Multicheck (o la respuesta no se ajusta al tipo esperado)
    function Ejercicio(respuesta_usuario::Any, respuesta_correcta::Any; texto_acierto="", texto_ayuda="", maxresp::Int=length(respuesta_correcta))
        if length(respuesta_usuario) == 0
            return new{Any}(nothing, respuesta_correcta, texto_acierto, texto_ayuda)
        elseif length(respuesta_usuario) == 1
            return Ejercicio(respuesta_usuario[1], respuesta_correcta; texto_acierto, texto_ayuda)
        elseif length(respuesta_usuario) <= maxresp
            return Ejercicio(respuesta_usuario[1:maxresp], respuesta_correcta; texto_acierto, texto_ayuda)
        end
    end
end