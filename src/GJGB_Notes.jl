module GJGB_Notes

    # Packages
    using HypertextLiteral: @htl, @htl_str # necesario para cita()
    using Markdown
    using PlutoUI
    using Reexport

    # Load dependencies
    include("./dep/Structs.jl")
    export Español, English, Français
    include("./dep/Aux_Functions.jl")
    export cita, resaltar, enlace, correcto, mejorable

    # Reexport PlutoUI
    @reexport using PlutoUI
    
end
