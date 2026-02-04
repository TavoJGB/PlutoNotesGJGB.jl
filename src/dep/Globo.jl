#===========================================================================
	GLOBOS
===========================================================================#

# Función para crear globos (tooltips) interactivos (incluye estilos automáticamente)
globo(clave::String, expansion::String) = @htl("""
	<script>
		if (!window.positionTooltip) {
			window.positionTooltip = function(e) {
				const tooltip = e.currentTarget.querySelector('.tooltip-text');
				if (tooltip) {
					const rect = e.currentTarget.getBoundingClientRect();
					tooltip.style.left = Math.max(10, rect.left + (rect.width / 2) - 160) + 'px';
					tooltip.style.top = (rect.top - tooltip.offsetHeight - 10) + 'px';
				}
			}
		}
	</script>
	<style id="globo-styles">
		.tooltip-clave {
			position: relative;
			display: inline;
			cursor: help;
			border-bottom: 1px dotted #666;
		}
		
		.tooltip-clave .tooltip-exp {
			visibility: hidden;
			width: 320px;
			max-width: 90vw;
			background-color: #555;
			color: #fff;
			text-align: left;
			border-radius: 8px;
			padding: 0px 0px;
			position: fixed;
			z-index: 9999;
			opacity: 0;
			transition: opacity 0.3s;
			font-size: 14px;
			line-height: 1.5;
			box-shadow: 0 4px 12px rgba(0,0,0,0.3);
			pointer-events: none;
			white-space: normal;
			left: 50%;
			top: 50%;
		}
		
		.tooltip-clave:hover .tooltip-exp {
			visibility: visible;
			opacity: 1;
		}
	</style>
	<b><span class="tooltip-clave" onmouseover="positionTooltip(event)" onmousemove="positionTooltip(event)">$clave<span class="tooltip-exp">$expansion</span></span></b>
""")