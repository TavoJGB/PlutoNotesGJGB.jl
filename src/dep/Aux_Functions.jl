#===========================================================================
    CORRECCIÓN DE RESPUESTAS
===========================================================================#

apoyos(::Español) = ["¡Espléndido!", "¡Fabuloso!", "¡Eres un máquina!", "¡Estás en racha!", "¡Bien hecho! 🎉", "¡Me has leído el pensamiento!"];
correcto(::Español; texto=md"Sigue así 💪") = Markdown.MD(Markdown.Admonition("correct", rand(apoyos(Español())), [texto]))
mejorable(::Español; texto=md"¡Concéntrate!") = Markdown.MD(Markdown.Admonition("danger", "Sigue intentándolo", [texto]))



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