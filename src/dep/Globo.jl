#===========================================================================
	GLOBOS
===========================================================================#

# Estilos y scripts para globos (se cargan automáticamente)
const _GLOBO_ESTILOS = @htl("""
	<script>
		if (!window.__globoEnsureTooltip) {
			window.__globoEnsureTooltip = function() {
				let tooltip = document.getElementById('globo-tooltip-floating');
				if (!tooltip) {
					tooltip = document.createElement('div');
					tooltip.id = 'globo-tooltip-floating';
					tooltip.className = 'tooltip-exp-floating';
					document.body.appendChild(tooltip);
				}
				return tooltip;
			};

			window.hideTooltip = function() {
				const tooltip = document.getElementById('globo-tooltip-floating');
				if (tooltip) {
					tooltip.classList.remove('visible');
					tooltip.innerHTML = '';
				}
			};

			window.positionTooltip = function(e) {
				const host = e.currentTarget;
				const template = host.querySelector('.tooltip-exp-template');
				if (!template) return;

				const tooltip = window.__globoEnsureTooltip();
				tooltip.innerHTML = template.innerHTML;

				if (window.MathJax && typeof window.MathJax.typesetPromise === 'function') {
					window.MathJax.typesetPromise([tooltip]).catch(function () {});
				} else if (typeof window.renderMathInElement === 'function') {
					window.renderMathInElement(tooltip, {
						delimiters: [
							{left: '\$\$', right: '\$\$', display: true},
							{left: '\$', right: '\$', display: false}
						]
					});
				}

				const cs = getComputedStyle(host);
				tooltip.style.setProperty('--globo-ancho', cs.getPropertyValue('--globo-ancho'));
				tooltip.style.setProperty('--globo-fondo', cs.getPropertyValue('--globo-fondo'));
				tooltip.style.setProperty('--globo-texto', cs.getPropertyValue('--globo-texto'));
				tooltip.style.setProperty('--globo-fuente', cs.getPropertyValue('--globo-fuente'));
				tooltip.style.setProperty('--globo-radio', cs.getPropertyValue('--globo-radio'));
				tooltip.style.setProperty('--globo-padding', cs.getPropertyValue('--globo-padding'));

				tooltip.classList.add('visible');

				const rect = host.getBoundingClientRect();
				const tooltipWidth = tooltip.offsetWidth;
				const tooltipHeight = tooltip.offsetHeight;

				let left = rect.left + (rect.width / 2) - (tooltipWidth / 2);
				left = Math.max(10, left);
				left = Math.min(left, window.innerWidth - tooltipWidth - 10);

				let top = rect.top - tooltipHeight - 10;
				if (top < 10) {
					top = rect.bottom + 10;
				}

				tooltip.style.left = left + 'px';
				tooltip.style.top = top + 'px';
			};
		}
	</script>
	<style id="globo-styles">
		.tooltip-clave {
			position: relative;
			display: inline;
			cursor: help;
			border-bottom: 1px dotted var(--globo-borde-color, #666);
		}

		.tooltip-exp-floating {
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
			font-family: inherit;
			line-height: 1.5;
			box-shadow: 0 4px 12px rgba(0,0,0,0.3);
			pointer-events: none;
			white-space: normal;
		}

		.tooltip-exp-floating p {
			margin: 0;
		}

		.tooltip-exp-floating.visible {
			visibility: visible;
			opacity: 1;
		}
	</style>
""")

_globo_contenido(expansion::Markdown.MD) = HTML(sprint(show, MIME"text/html"(), expansion))
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
			<span class="tooltip-clave" style=$estilo_valor onmouseover="positionTooltip(event)" onmousemove="positionTooltip(event)" onmouseout="hideTooltip()"><b>$clave</b><template class="tooltip-exp-template">$expansion</template></span>
		""")
	else
		@htl("""
			$(_GLOBO_ESTILOS)
			<span class="tooltip-clave" style=$estilo_valor onmouseover="positionTooltip(event)" onmousemove="positionTooltip(event)" onmouseout="hideTooltip()">$clave<template class="tooltip-exp-template">$expansion</template></span>
		""")
	end
end