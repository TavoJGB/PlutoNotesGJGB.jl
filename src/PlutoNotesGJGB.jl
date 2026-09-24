module PlutoNotesGJGB

    # Packages
    using HypertextLiteral # necesario para cita() y cuadro_base()
    using Markdown
    using Parameters
    using Preferences # for Language choice

    # Load structs
    include("./dep/Structs.jl")
        export Ejercicio

    # Normaliza preferencias antiguas o inválidas para evitar errores al cargar el paquete.
    function _resolve_language(pref::String)
        pref_norm = lowercase(strip(pref))
        aliases = Dict(
            "es" => "español",
            "espanol" => "español",
            "español" => "español",
            "en" => "english",
            "english" => "english",
            "fr" => "français",
            "francais" => "français",
            "français" => "français"
        )

        selected = get(aliases, pref_norm, "español")
        if selected == "español" && pref_norm ∉ keys(aliases)
            @warn "Idioma '$pref' no reconocido en preferencias. Usando español por defecto."
        end
        return selected
    end

    # Load language choice
    _pref_language = @load_preference("idioma", "español")
    const IDIOMA = Dict(
        "español" => Español(),
        "english" => English(),
        "français" => Français()
    )[_resolve_language(_pref_language)]

    # Load other dependencies
    include(joinpath("dep","Cita.jl"))
        export cita
    include(joinpath("dep","Cuadros.jl"))
        export concepto, peligro, atencion, truco, recuerdo, consejo
    include(joinpath("dep","Ejercicios.jl"))
        export corregir
    include(joinpath("dep","Globo.jl"))
        export globo
    include(joinpath("dep","Idiomas.jl"))
        export set_language!
    include(joinpath("dep","Listas.jl"))
        export lista
    include(joinpath("dep","Texto.jl"))
        export resaltar, enlace
    
end
