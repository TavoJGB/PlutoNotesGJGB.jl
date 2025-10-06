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


#===========================================================================
    FORMATO DE TEXTO
===========================================================================#

resaltar(texto; color="orange") = "<span style=color:$color><strong>" * texto * "</strong></span>"
enlace(texto, url) = """<a href="$url" target="_blank">$texto</a>"""



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
/* Truco - Morado */
.reminder-box {
    border: 4px solid #9d4edd;
    background-color: #f8f4ff;
    border-radius: 4px;
    margin: 1em 0;
    overflow: hidden;
    box-shadow: 0 2px 4px #9d4edd20;
}
.reminder-header {
    background-color: #9d4edd;
    color: white;
    padding: 8px 12px;
    font-weight: bold;
    font-size: 1.1em;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}
.reminder-content {
    padding: 12px;
    color: #2d3748;
    line-height: 1.6;
}

/* Cuidado - Rojo */
.warning-box {
    border: 4px solid #dc2626;
    background-color: #fef2f2;
    border-radius: 4px;
    margin: 1em 0;
    overflow: hidden;
    box-shadow: 0 2px 4px #dc262620;
}
.warning-header {
    background-color: #dc2626;
    color: white;
    padding: 8px 12px;
    font-weight: bold;
    font-size: 1.1em;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}
.warning-content {
    padding: 12px;
    color: #7f1d1d;
    line-height: 1.6;
    font-weight: 500;
}

/* Recuerdo - Rosa */
.memory-box {
    border: 4px solid #ec4899;
    background-color: #fdf2f8;
    border-radius: 4px;
    margin: 1em 0;
    overflow: hidden;
    box-shadow: 0 2px 4px #ec489920;
}
.memory-header {
    background-color: #ec4899;
    color: white;
    padding: 8px 12px;
    font-weight: bold;
    font-size: 1.1em;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}
.memory-content {
    padding: 12px;
    color: #831843;
    line-height: 1.6;
    font-style: italic;
}

/* Concepto - Azul */
.concept-box {
    border: 4px solid #2563eb;
    background-color: #eff6ff;
    border-radius: 4px;
    margin: 1em 0;
    overflow: hidden;
    box-shadow: 0 2px 4px #2563eb20;
}
.concept-header {
    background-color: #2563eb;
    color: white;
    padding: 8px 12px;
    font-weight: bold;
    font-size: 1.1em;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}
.concept-content {
    padding: 12px;
    color: #1e3a8a;
    line-height: 1.6;
    border-left: 4px solid #93c5fd;
    margin-left: 8px;
    padding-left: 16px;
}

/* Dark mode styles */
@media (prefers-color-scheme: dark) {
    .reminder-box { background-color: #2a1f3d; border-color: #b794f6; }
    .reminder-header { background-color: #b794f6; color: #1a1a1a; }
    .reminder-content { color: #e2e8f0; }
    
    .warning-box { background-color: #450a0a; border-color: #f87171; }
    .warning-header { background-color: #ef4444; color: #1a1a1a; }
    .warning-content { color: #fca5a5; }
    
    .memory-box { background-color: #500724; border-color: #f472b6; }
    .memory-header { background-color: #f472b6; color: #1a1a1a; }
    .memory-content { color: #fbcfe8; }
    
    .concept-box { background-color: #1e3a8a; border-color: #60a5fa; }
    .concept-header { background-color: #3b82f6; color: #1a1a1a; }
    .concept-content { color: #bfdbfe; border-left-color: #3b82f6; }
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

# Configuración de temas (solo metadatos)
const TEMAS_CONFIG = Dict(
    :recuerdo => (clase="memory", icono="💭"),
    :cuidado => (clase="warning", icono="⚠️"),
    :truco => (clase="reminder", icono="💡"),
    :concepto => (clase="concept", icono="📝")
)

# Función base optimizada - solo genera HTML, no CSS
function cuadro_base(titulo::String, contenido::Union{String,Markdown.MD,HTML}, tema::Symbol)
    config = TEMAS_CONFIG[tema]
    
    # Convertir contenido a HTML si es necesario
    contenido_html = contenido isa String ? HTML(contenido) : contenido
    
    @htl("""
    $(incluir_css_cuadros())
    <div class="$(config.clase)-box">
        <div class="$(config.clase)-header">
            $(config.icono) $(titulo)
        </div>
        <div class="$(config.clase)-content">
            $(contenido_html)
        </div>
    </div>
    """)
end

# Funciones específicas que utilizan la función base
concepto(titulo, contenido) = cuadro_base(titulo, contenido, :concepto)
cuidado(titulo, contenido) = cuadro_base(titulo, contenido, :cuidado)
truco(titulo, contenido) = cuadro_base(titulo, contenido, :truco)
recuerdo(titulo, contenido) = cuadro_base(titulo, contenido, :recuerdo)