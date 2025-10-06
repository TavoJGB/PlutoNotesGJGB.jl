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

function recuerdo(titulo, contenido)
	@htl("""
	<style>
	.reminder-box {
		border: 4px solid #9d4edd;
		background-color: #f8f4ff;
		border-radius: 4px;
		margin: 1em 0;
		overflow: hidden;
	}
	
	.reminder-header {
		background-color: #9d4edd;
		color: white;
		padding: 6px 12px;
		font-weight: bold;
		font-size: 1.1em;
		margin: 0;
	}
	
	.reminder-content {
		padding: 12px;
		color: #2d3748;
		line-height: 1.6;
	}
	
	/* Dark mode styles */
	@media (prefers-color-scheme: dark) {
		.reminder-box {
			background-color: #2a1f3d;
			border-color: #b794f6;
			border-left-color: #b794f6;
		}
		
		.reminder-header {
			background-color: #b794f6;
			color: #1a1a1a;
		}
		
		.reminder-content {
			color: #e2e8f0;
		}
	}
	</style>
	<div class="reminder-box">
		<div class="reminder-header">
			💭 $(titulo)
		</div>
		<div class="reminder-content">
			$(HTML(contenido))
		</div>
	</div>
	""")
end