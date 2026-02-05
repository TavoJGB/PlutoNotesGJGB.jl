#===========================================================================
    LISTAS
===========================================================================#

# Generador de listas a partir de un vector de items.
# Acepta String, Markdown.MD o HTML para cada punto.
function lista(puntos::AbstractVector{T}; tipo::String="ol", indent::Bool=true) where {T<:Union{String,Markdown.MD,HTML}}
    @assert tipo ∈ ["ol", "ul"] "Tipo de lista '$tipo' no reconocido. Use 'ol' o 'ul'."

    # Normalizar cada elemento: si es String lo convertimos a HTML;
    # Markdown.MD y HTML se mantienen para que @htl los procese correctamente.
    items = [p isa String ? HTML(p) : p for p in puntos]

    # Construir una lista de elementos <li> usando @htl para preservar tipos
    li_items = [ @htl("""<li>$(it)</li>""") for it in items ]

    # Construir las etiquetas de apertura y cierre como strings
    attrhtml = indent ? "" : " style='margin:0;padding-left:0;margin-left:0;'"
    tag_open = "<" * tipo * attrhtml * ">"
    tag_close = "</" * tipo * ">"
    
    # Usar @htl con Bypass para las etiquetas dinámicas
    return @htl("""$(HypertextLiteral.Bypass(tag_open))$(li_items...)$(HypertextLiteral.Bypass(tag_close))""")
end

# Versión más permisiva que acepta cualquier vector y convierte a string cuando sea necesario
lista(puntos::AbstractVector; kwargs...) = lista([p isa String ? p : (p isa Markdown.MD || p isa HTML ? p : string(p)) for p in puntos]; kwargs...)
lista(args...; kwargs...) = lista(collect(args); kwargs...)