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

# Función base modular para crear cuadros de texto estilizados
cuadro_base(titulo::String, contenido, tema::Symbol) = cuadro_base(titulo, HTML(contenido), tema)
function cuadro_base(titulo::String, contenido::Union{Markdown.MD,HTML}, tema::Symbol)
    # Configuraciones de temas
    temas = Dict(
        :truco => Dict(
            :clase => "reminder",
            :color_borde => "#9d4edd",
            :color_fondo => "#f8f4ff",
            :color_header => "#9d4edd",
            :color_texto => "#2d3748",
            :fondo_dark => "#2a1f3d",
            :borde_dark => "#b794f6",
            :header_dark => "#b794f6",
            :texto_dark => "#e2e8f0",
            :icono => "💡",
            :estilo_contenido => ""
        ),
        :cuidado => Dict(
            :clase => "warning",
            :color_borde => "#dc2626",
            :color_fondo => "#fef2f2",
            :color_header => "#dc2626",
            :color_texto => "#7f1d1d",
            :fondo_dark => "#450a0a",
            :borde_dark => "#f87171",
            :header_dark => "#ef4444",
            :texto_dark => "#fca5a5",
            :icono => "⚠️",
            :estilo_contenido => "font-weight: 500;"
        ),
        :recuerdo => Dict(
            :clase => "memory",
            :color_borde => "#ec4899",
            :color_fondo => "#fdf2f8",
            :color_header => "#ec4899",
            :color_texto => "#831843",
            :fondo_dark => "#500724",
            :borde_dark => "#f472b6",
            :header_dark => "#f472b6",
            :texto_dark => "#fbcfe8",
            :icono => "💭",
            :estilo_contenido => "font-style: italic;"
        ),
        :concepto => Dict(
            :clase => "concept",
            :color_borde => "#2563eb",
            :color_fondo => "#eff6ff",
            :color_header => "#2563eb",
            :color_texto => "#1e3a8a",
            :fondo_dark => "#1e3a8a",
            :borde_dark => "#60a5fa",
            :header_dark => "#3b82f6",
            :texto_dark => "#bfdbfe",
            :icono => "📝",
            :estilo_contenido => "border-left: 4px solid #93c5fd; margin-left: 8px; padding-left: 16px;"
        )
    )
    
    config = temas[tema]
    clase = config[:clase]
    
    # Generar CSS específico para el tema
    css_extra = tema == :concepto ? 
        """
        .$(clase)-content {
            border-left-color: $(config[:header_dark]) !important;
        }
        """ : ""
    
    @htl("""
    <style>
    .$(clase)-box {
        border: 4px solid $(config[:color_borde]);
        background-color: $(config[:color_fondo]);
        border-radius: 4px;
        margin: 1em 0;
        overflow: hidden;
        box-shadow: 0 2px 4px $(config[:color_borde])20;
    }
    
    .$(clase)-header {
        background-color: $(config[:color_header]);
        color: white;
        padding: 8px 12px;
        font-weight: bold;
        font-size: 1.1em;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .$(clase)-content {
        padding: 12px;
        color: $(config[:color_texto]);
        line-height: 1.6;
        $(config[:estilo_contenido])
    }
    
    /* Dark mode styles */
    @media (prefers-color-scheme: dark) {
        .$(clase)-box {
            background-color: $(config[:fondo_dark]);
            border-color: $(config[:borde_dark]);
        }
        
        .$(clase)-header {
            background-color: $(config[:header_dark]);
            color: #1a1a1a;
        }
        
        .$(clase)-content {
            color: $(config[:texto_dark]);
        }
    }
    
    $(css_extra)
    </style>
    <div class="$(clase)-box">
        <div class="$(clase)-header">
            $(config[:icono]) $(titulo)
        </div>
        <div class="$(clase)-content">
            $(contenido)
        </div>
    </div>
    """)
end

# Funciones específicas que utilizan la función base
concepto(titulo, contenido) = cuadro_base(titulo, contenido, :concepto)
cuidado(titulo, contenido) = cuadro_base(titulo, contenido, :cuidado)
truco(titulo, contenido) = cuadro_base(titulo, contenido, :truco)
recuerdo(titulo, contenido) = cuadro_base(titulo, contenido, :recuerdo)