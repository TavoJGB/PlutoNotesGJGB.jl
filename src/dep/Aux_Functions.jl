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

/* Cuidado - Rojo */
.cuadro-cuidado {
    border-color: #dc2626;
    background-color: #fef2f2;
}
.cuadro-cuidado .cuadro-base-header {
    background-color: #dc2626;
}
.cuadro-cuidado .cuadro-base-content {
    color: #7f1d1d;
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
    
    .cuadro-cuidado {
        background-color: #450a0a;
        border-color: #ef4444;
    }
    .cuadro-cuidado .cuadro-base-header {
        background-color: #ef4444;
        color: #1a1a1a;
    }
    .cuadro-cuidado .cuadro-base-content {
        color: #fbcfcf;
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
    :cuidado => (clase="cuadro-cuidado", icono="⚠️"),
    :truco => (clase="cuadro-truco", icono="💡"),
    :concepto => (clase="cuadro-concepto", icono="📝")
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

# Funciones específicas optimizadas - VERSIÓN RÁPIDA
# Estas son más rápidas porque evitan el overhead de cuadro_base()

# Función ultra-rápida para truco (sin CSS dinámico)
function truco(titulo, contenido)
    contenido_html = contenido isa String ? HTML(contenido) : contenido
    @htl("""
    $(incluir_css_cuadros())
    <div class="cuadro-base cuadro-truco">
        <div class="cuadro-base-header">💡 $(titulo)</div>
        <div class="cuadro-base-content">$(contenido_html)</div>
    </div>
    """)
end

function cuidado(titulo, contenido)
    contenido_html = contenido isa String ? HTML(contenido) : contenido
    @htl("""
    $(incluir_css_cuadros())
    <div class="cuadro-base cuadro-cuidado">
        <div class="cuadro-base-header">⚠️ $(titulo)</div>
        <div class="cuadro-base-content">$(contenido_html)</div>
    </div>
    """)
end

function recuerdo(titulo, contenido)
    contenido_html = contenido isa String ? HTML(contenido) : contenido
    @htl("""
    $(incluir_css_cuadros())
    <div class="cuadro-base cuadro-recuerdo">
        <div class="cuadro-base-header">💭 $(titulo)</div>
        <div class="cuadro-base-content">$(contenido_html)</div>
    </div>
    """)
end

function concepto(titulo, contenido)
    contenido_html = contenido isa String ? HTML(contenido) : contenido
    @htl("""
    $(incluir_css_cuadros())
    <div class="cuadro-base cuadro-concepto">
        <div class="cuadro-base-header">📝 $(titulo)</div>
        <div class="cuadro-base-content">$(contenido_html)</div>
    </div>
    """)
end

# Mantener cuadro_base para casos especiales si es necesario
# concepto_avanzado(titulo, contenido) = cuadro_base(titulo, contenido, :concepto)
