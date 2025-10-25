#===========================================================================
    TEST
===========================================================================#

saluda(::Español) = "¡Hola! Estás usando GJGB_Notes en español."
saluda(::English) = "Hello! You are using GJGB_Notes in English."
saluda(::Français) = "Bonjour! Vous utilisez GJGB_Notes en français."
saluda() = saluda(IDIOMA)



#===========================================================================
    SELECCIÓN DE IDIOMA
===========================================================================#

# Let the user select language
function set_language!(idioma::String)::Nothing
    # Preparación
    idioma_min = lowercase(idioma)
    N_car = length(idioma_min)
    @assert N_car ≥ 2 "El idioma debe tener al menos 2 caracteres: 'es', 'en', 'fr'"
    idiomas_disp = [x for x in ["español", "english", "français"] if startswith(x, idioma_min)]
    # Selección
    idioma_sel = idiomas_disp[startswith.(idiomas_disp,idioma_min)]
    if length(idioma_sel) == 0
        @warn "Idioma '$idioma' no reconocido. Usando español por defecto."
        idioma_sel = "español"
    elseif length(idioma_sel) > 1
        @warn "Idioma '$idioma' ambiguo. Usando español por defecto."
        idioma_sel = "español"
    else
        idioma_sel = idioma_sel[1]
        mostrar = Dict(
            "español" => "Has seleccionado cambiar GJGB_Notes a español. Ahora reinicia Julia para aplicar los cambios.",
            "english" => "You selected to change GJGB_Notes to English. Please restart Julia to apply the changes.",
            "français" => "Vous avez sélectionné de changer GJGB_Notes à français. Redémarrez Julia pour appliquer les changements."
        )[idioma_sel]
        println(mostrar)
    end
    @set_preferences!("idioma" => idioma_sel)
    return nothing
end



#===========================================================================
    CORREGIR EJERCICIOS
===========================================================================#

# Mensajes para el usuario
apoyos(::Español) = ["¡Espléndido!", "¡Fabuloso!", "¡Eres un máquina!", "¡Estás en racha!", "¡Bien hecho! 🎉", "¡Me has leído el pensamiento!"];
correcto(::Español; texto=md"Sigue así 💪") = Markdown.MD(Markdown.Admonition("correct", rand(apoyos(Español())), [texto]))
mejorable(::Español; texto=md"¡Concéntrate!") = Markdown.MD(Markdown.Admonition("danger", "Sigue intentándolo", [texto]))

# Corregir ejercicio
function corregir(ejer::Ejercicio, idioma::Idioma)
	@unpack respuesta_usuario, respuesta_correcta, texto_acierto, texto_ayuda = ejer
	if respuesta_usuario==respuesta_correcta
		return correcto(idioma; texto=texto_acierto)
	else
		if isnothing(respuesta_usuario)
			return nothing
		else
			return mejorable(idioma; texto=texto_ayuda)
		end
	end
end
corregir(ejer::Ejercicio) = corregir(ejer, IDIOMA)


#===========================================================================
    FORMATO DE TEXTO
===========================================================================#

resaltar(texto; color="orange") = "<span style=color:$color><strong>" * texto * "</strong></span>"
enlace(texto, url) = """<a href="$url" target="_blank">$texto</a>"""


#===========================================================================
    LISTAS ORDENADAS
===========================================================================#

# Generador de listas ordenadas a partir de un vector de items.
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



#===========================================================================
    CITACIÓN
===========================================================================#

function cita(texto, autor="", obra="")
	 # Construir la línea del autor condicionalmente
    linea_autor = if obra != ""
        """<span class="nice-blockquote__obra"> $obra </span> &nbsp; &mdash; &nbsp; $autor"""
    else
        autor
    end
    @htl("""
		<div class="nice-blockquote--quoted">
			<div class="nice-blockquote__text">
				$(HTML(texto))
			</div>
		</div>
		<div class="nice-blockquote__author">
			$(HTML(linea_autor))
		</div>
		<style> 
			.nice-blockquote--quoted::before{
				content:'«';
				font-size:70px;
				font-family: Arial;
				font-style: italic;
				font-weight:bold;
				color:#ccc;
				display:block;
				margin-top:-20px;
				font-family: Arial;
			}
			.nice-blockquote--quoted::after{
				content:'»';
				font-size:70px;
				font-family: Arial;
				font-style: italic;
				font-weight:bold;
				color:#ccc;
				display:block;
				text-align:right;
				font-family: Arial;
			}
			.nice-blockquote__text{
				font-family: Arial;
				font-style: italic;
				font-size: 1.5em;
				margin:45px;
				line height: 1.5;
				text-align:center;
				margin-top:-40px;
				margin-bottom:-50px;
			}
			.nice-blockquote__author{
				font-weight:bold;
				font-style: normal;
				text-align:right;
				fontsize: 2em;
				margin-bottom:10px;
			}
			.nice-blockquote__obra{
				font-style: italic;
			}
		</style>
    """)
end



#===========================================================================
    CUADROS DE TEXTO
===========================================================================#

# CSS global - se define una sola vez
const CUADROS_CSS = """
<style>
/* CLASE BASE - Estructura común para todos los cuadros */
.cuadro-base {
    border: 4px solid;
    border-radius: 8px;
    margin: 1em 0;
    overflow: hidden;
}

.cuadro-base-header {
    color: white;
    padding: 2px 2px;
    font-weight: bold;
    font-size: 1.2em;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}

.cuadro-base-content {
    padding: 6px;
    line-height: 1.6;
}

/* MODIFICADORES DE COLOR - Solo definen colores específicos */

/* Truco - Morado */
.cuadro-truco {
    border-color: #9d4edd;
    background-color: #f8f4ff;
}
.cuadro-truco .cuadro-base-header {
    background-color: #9d4edd;
}
.cuadro-truco .cuadro-base-content {
    color: #2d3748;
}

/* Peligro - Rojo */
.cuadro-peligro {
    border-color: #dc2626;
    background-color: #fef2f2;
}
.cuadro-peligro .cuadro-base-header {
    background-color: #dc2626;
}
.cuadro-peligro .cuadro-base-content {
    color: #7f1d1d;
}

/* Atención - Naranja */
.cuadro-atencion {
    border-color: #f59e0b;
    background-color: #fffbeb;
}
.cuadro-atencion .cuadro-base-header {
    background-color: #f59e0b;
}
.cuadro-atencion .cuadro-base-content {
    color: #78350f;
}

/* Recuerdo - Rosa */
.cuadro-recuerdo {
    border-color: #ec4899;
    background-color: #fdf2f8;
}
.cuadro-recuerdo .cuadro-base-header {
    background-color: #ec4899;
}
.cuadro-recuerdo .cuadro-base-content {
    color: #831843;
}

/* Concepto - Azul */
.cuadro-concepto {
    border-color: #2563eb;
    background-color: #eff6ff;
}
.cuadro-concepto .cuadro-base-header {
    background-color: #2563eb;
}
.cuadro-concepto .cuadro-base-content {
    color: #1e3a8a;
}

/* Consejo - Verde Menta/Cyan */
.cuadro-consejo {
    border-color: #06b6d4;
    background-color: #ecfeff;
}
.cuadro-consejo .cuadro-base-header {
    background-color: #06b6d4;
}
.cuadro-consejo .cuadro-base-content {
    color: #164e63;
}

/* Dark mode styles - Solo modificadores de color */
@media (prefers-color-scheme: dark) {
    .cuadro-truco {
        background-color: #2a1f3d;
        border-color: #b794f6;
    }
    .cuadro-truco .cuadro-base-header {
        background-color: #b794f6;
        color: #1a1a1a;
    }
    .cuadro-truco .cuadro-base-content {
        color: #e2e8f0;
    }
    
    .cuadro-peligro {
        background-color: #450a0a;
        border-color: #ef4444;
    }
    .cuadro-peligro .cuadro-base-header {
        background-color: #ef4444;
        color: #1a1a1a;
    }
    .cuadro-peligro .cuadro-base-content {
        color: #fbcfcf;
    }

    .cuadro-atencion {
        background-color: #45350a;
        border-color: #f59e0b;
    }
    .cuadro-atencion .cuadro-base-header {
        background-color: #f59e0b;
        color: #1a1a1a;
    }
    .cuadro-atencion .cuadro-base-content {
        color: #fef3c7;
    }
    
    .cuadro-recuerdo {
        background-color: #732a51;
        border-color: #f472b6;
    }
    .cuadro-recuerdo .cuadro-base-header {
        background-color: #f472b6;
        color: #1a1a1a;
    }
    .cuadro-recuerdo .cuadro-base-content {
        color: #fbcfe8;
    }
    
    .cuadro-concepto {
        background-color: #2a4973;
        border-color: #5c8ccd;
    }
    .cuadro-concepto .cuadro-base-header {
        background-color: #5c8ccd;
        color: #1a1a1a;
    }
    .cuadro-concepto .cuadro-base-content {
        color: #bfdbfe;
    }
    
    .cuadro-consejo {
        background-color: #164e63;
        border-color: #67e8f9;
    }
    .cuadro-consejo .cuadro-base-header {
        background-color: #67e8f9;
        color: #1a1a1a;
    }
    .cuadro-consejo .cuadro-base-content {
        color: #cffafe;
    }
}
</style>
"""

# Variable para controlar si ya se incluyó el CSS
const CSS_INCLUIDO = Ref(false)

# Función para incluir CSS solo una vez
function incluir_css_cuadros()
    if !CSS_INCLUIDO[]
        CSS_INCLUIDO[] = true
        return HTML(CUADROS_CSS)
    else
        return HTML("")  # No incluir CSS adicional
    end
end

# Función para inicializar estilos manualmente (opcional)
function inicializar_estilos()
    CSS_INCLUIDO[] = true
    return HTML(CUADROS_CSS)
end

# Función para resetear CSS (útil en desarrollo)
function resetear_css()
    CSS_INCLUIDO[] = false
    return nothing
end

# Configuración de temas (solo metadatos)
const TEMAS_CONFIG = Dict(
    :recuerdo => (clase="cuadro-recuerdo", icono="💭"),
    :peligro => (clase="cuadro-peligro", icono="☢️"),
    :atención => (clase="cuadro-atencion", icono="⚠️"),
    :truco => (clase="cuadro-truco", icono="💡"),
    :concepto => (clase="cuadro-concepto", icono="📝"),
    :consejo => (clase="cuadro-consejo", icono="🤓")
)

# Función base optimizada - solo genera HTML, no CSS
function cuadro_base(titulo::String, contenido::Union{String,Markdown.MD,HTML}, tema::Symbol)
    config = TEMAS_CONFIG[tema]
    
    # Convertir contenido a HTML si es necesario
    contenido_html = contenido isa String ? HTML(contenido) : contenido
    
    @htl("""
    $(incluir_css_cuadros())
    <div class="cuadro-base $(config.clase)">
        <div class="cuadro-base-header">
            $(config.icono) $(titulo)
        </div>
        <div class="cuadro-base-content">
            $(contenido_html)
        </div>
    </div>
    """)
end

# Funciones específicas - wrappers simples alrededor de cuadro_base
# Toda la configuración (iconos, colores) está centralizada en TEMAS_CONFIG
truco(titulo, contenido) = cuadro_base(titulo, contenido, :truco)
peligro(titulo, contenido) = cuadro_base(titulo, contenido, :peligro)
atencion(titulo, contenido) = cuadro_base(titulo, contenido, :atención)
recuerdo(titulo, contenido) = cuadro_base(titulo, contenido, :recuerdo)
concepto(titulo, contenido) = cuadro_base(titulo, contenido, :concepto)
consejo(titulo, contenido) = cuadro_base(titulo, contenido, :consejo)
