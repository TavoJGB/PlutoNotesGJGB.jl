module PlutoNotesGJGB

    # Packages
    using HypertextLiteral # necesario para cita() y cuadro_base()
    using Markdown
    using Parameters
    using Preferences # for Language choice

    # Load structs
    include("./dep/Structs.jl")
        export Ejercicio

    # Load language choice
    const IDIOMA = Dict(
        "español" => Español(),
        "english" => English(),
        "français" => Français()
    )[@load_preference("idioma", "español")]

    # Load other dependencies
    include(joinpath("dep","Cita.jl"))
        export cita
    include(joinpath("dep","Cuadros.jl"))
        export concepto, peligro, atencion, truco, recuerdo, consejo
    include(joinpath("dep","Ejercicios.jl"))
        export corregir
    include(joinpath("dep","Idiomas.jl"))
        export set_language!
    include(joinpath("dep","Listas.jl"))
        export lista
    include(joinpath("dep","Texto.jl"))
        export resaltar, enlace
    
end
