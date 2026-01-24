module PlutoNotesGJGB

    # Packages
    using HypertextLiteral # necesario para cita() y cuadro_base()
    using Markdown
    using Parameters
    using Preferences # for Language choice

    # Load structs
    include("./dep/Structs.jl")

    # Load language choice
    const IDIOMA = Dict(
        "español" => Español(),
        "english" => English(),
        "français" => Français()
    )[@load_preference("idioma", "español")]

    # Load other dependencies
    include("./dep/Functions.jl")
    export set_language!
    export lista, cita, resaltar, enlace, corregir
    export concepto, peligro, atencion, truco, recuerdo, consejo
    
end
