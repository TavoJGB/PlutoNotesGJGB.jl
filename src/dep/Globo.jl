#===========================================================================
	GLOBOS
===========================================================================#

# Estilos y scripts para globos (se cargan automáticamente)
const _GLOBO_ESTILOS = @htl("""
	<script>
		if (!window.positionTooltip) {
			window.positionTooltip = function(e) {
				const tooltip = e.currentTarget.querySelector('.tooltip-exp');
				if (tooltip) {
					const rect = e.currentTarget.getBoundingClientRect();
					const tooltipWidth = tooltip.offsetWidth;
					const tooltipHeight = tooltip.offsetHeight;
					
					// Centrar horizontalmente sobre el término
					let left = rect.left + (rect.width / 2) - (tooltipWidth / 2);
					// Evitar que se salga del borde izquierdo
					left = Math.max(10, left);
					// Evitar que se salga del borde derecho
					left = Math.min(left, window.innerWidth - tooltipWidth - 10);
					
					// Posicionar arriba del término
					let top = rect.top - tooltipHeight - 10;
					// Si no cabe arriba, ponerlo abajo
					if (top < 10) {
						top = rect.bottom + 10;
					}
					
					tooltip.style.left = left + 'px';
					tooltip.style.top = top + 'px';
				}
			}
		}
	</script>
	<style id="globo-styles">
		.tooltip-clave {
			position: relative;
			display: inline;
			cursor: help;
			border-bottom: 1px dotted var(--globo-borde-color, #666);
		}
		
		.tooltip-clave .tooltip-exp {
			visibility: hidden;
			width: var(--globo-ancho, 320px);
			max-width: 90vw;
			background-color: var(--globo-fondo, #555);
			color: var(--globo-texto, #fff);
			text-align: left;
			border-radius: var(--globo-radio, 8px);
			padding: var(--globo-padding, 10px);
			position: fixed;
			z-index: 9999;
			opacity: 0;
			transition: opacity 0.3s;
			font-size: var(--globo-fuente, 14px);
			line-height: 1.5;
			box-shadow: 0 4px 12px rgba(0,0,0,0.3);
			pointer-events: none;
			white-space: normal;
		}

		.tooltip-clave .tooltip-exp p {
			margin: 0;
		}
		
		.tooltip-clave:hover .tooltip-exp {
			visibility: visible;
			opacity: 1;
		}
	</style>
""")

# Convierte HTML de bloque (párrafos) a una versión inline para que permanezca
# dentro del tooltip oculto y no rompa el texto principal.
function _globo_inline_html(expansion)
	html = sprint(show, MIME"text/html"(), expansion)
	html = strip(html)
	html = replace(html, r"(?is)</p>\s*<p>" => "<br><br>")
	html = replace(html, r"(?is)</div>\s*<div>" => "<br><br>")
	html = replace(html, r"(?is)^<p>" => "")
	html = replace(html, r"(?is)</p>$" => "")
	html = replace(html, r"(?is)^<div>" => "")
	html = replace(html, r"(?is)</div>$" => "")
	html = replace(html, r"(?is)<p(\s[^>]*)?>" => "<span>")
	html = replace(html, r"(?is)</p>" => "</span>")
	html = replace(html, r"(?is)<div(\s[^>]*)?>" => "<span>")
	html = replace(html, r"(?is)</div>" => "</span>")
	return HTML(html)
end

_globo_contenido(expansion::AbstractString) = expansion
_globo_contenido(expansion::Markdown.MD) = _globo_inline_html(expansion)
_globo_contenido(expansion::HypertextLiteral.Result) = _globo_inline_html(expansion)
_globo_contenido(expansion) = expansion

# Función para crear globos (tooltips) interactivos
# `expansion` puede ser String, Markdown o HTML ya renderizado.
function globo(clave::AbstractString, expansion; 
	           negrita::Bool=true,
	           ancho::String="320px",
	           fondo::String="#555",
	           texto::String="#fff",
	           fuente::String="14px",
	           borde::String="#666",
	           radio::String="8px",
	           padding::String="10px")

	expansion = _globo_contenido(expansion)
	
	estilo_valor = "--globo-ancho:$ancho; --globo-fondo:$fondo; --globo-texto:$texto; --globo-fuente:$fuente; --globo-borde-color:$borde; --globo-radio:$radio; --globo-padding:$padding;"
	
	if negrita
		@htl("""
			$(_GLOBO_ESTILOS)
			<span class="tooltip-clave" style=$estilo_valor onmouseover="positionTooltip(event)" onmousemove="positionTooltip(event)"><b>$clave</b><span class="tooltip-exp">$expansion</span></span>
		""")
	else
		@htl("""
			$(_GLOBO_ESTILOS)
			<span class="tooltip-clave" style=$estilo_valor onmouseover="positionTooltip(event)" onmousemove="positionTooltip(event)">$clave<span class="tooltip-exp">$expansion</span></span>
		""")
	end
end