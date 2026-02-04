#===========================================================================
    TEST
===========================================================================#

saluda(::Español) = "¡Hola! Estás usando PlutoNotesGJGB en español."
saluda(::English) = "Hello! You are using PlutoNotesGJGB in English."
saluda(::Français) = "Bonjour! Vous utilisez PlutoNotesGJGB en français."
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
            "español" => "Has seleccionado cambiar PlutoNotesGJGB a español. Ahora reinicia Julia para aplicar los cambios.",
            "english" => "You selected to change PlutoNotesGJGB to English. Please restart Julia to apply the changes.",
            "français" => "Vous avez sélectionné de changer PlutoNotesGJGB à français. Redémarrez Julia pour appliquer les changements."
        )[idioma_sel]
        println(mostrar)
    end
    @set_preferences!("idioma" => idioma_sel)
    return nothing
end