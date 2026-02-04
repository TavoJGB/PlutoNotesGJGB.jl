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

    # Atributos para eliminar el margen izquierdo (cadena para insertar en la etiqueta)
    attrhtml = indent ? "" : " style='margin:0;padding-left:0;margin-left:0;'"

    # Construir la cadena HTML final concatenando los <li> ya procesados por @htl
    # (li_items son objetos que al convertirlos a string devuelven su HTML)
    inner = join(string.(li_items), "")
    full = "<" * tipo * attrhtml * ">" * inner * "</" * tipo * ">"

    return HTML(full)
end

# Versión más permisiva que acepta cualquier vector y convierte a string cuando sea necesario
lista(puntos::AbstractVector; kwargs...) = lista([p isa String ? p : (p isa Markdown.MD || p isa HTML ? p : string(p)) for p in puntos]; kwargs...)
lista(args...; kwargs...) = lista(collect(args); kwargs...)