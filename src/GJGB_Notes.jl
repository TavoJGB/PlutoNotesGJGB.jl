module GJGB_Notes

    # Packages
    using HypertextLiteral: @htl, @htl_str # necesario para cita()
    using Markdown
    using PlutoUI

    # Load dependencies
    include("./dep/Structs.jl")
    export Español, English, Français
    include("./dep/Aux_Functions.jl")
    export cita, resaltar, enlace, correcto, mejorable
    
end
