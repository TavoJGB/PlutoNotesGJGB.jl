using Test
using Markdown
using HypertextLiteral
using PlutoNotesGJGB

@testset "HTML helpers" begin
    @test resaltar("hi") == "<span style=color:orange><strong>hi</strong></span>"
    @test enlace("docs", "https://example.com") == """<a href="https://example.com" target="_blank">docs</a>"""

    lista_html = lista(["one", "two"]; tipo = "ul", indent = false)
    @test occursin("<ul", string(lista_html))
    @test occursin("<li>one</li>", string(lista_html))
    @test occursin("</ul>", string(lista_html))

    cita_html = cita("Texto", "Autor", "Obra")
    @test occursin("nice-blockquote", string(cita_html))
end

@testset "Corrección" begin
    ejer_ok = PlutoNotesGJGB.Ejercicio("a", "a"; texto_acierto = "bien", texto_ayuda = "ayuda")
    @test corregir(ejer_ok) isa Markdown.MD

    ejer_fail = PlutoNotesGJGB.Ejercicio("b", "c"; texto_acierto = "bien", texto_ayuda = "ayuda")
    @test corregir(ejer_fail) isa Markdown.MD
end

@testset "Cuadros" begin
    cuadro = truco("Tip", "contenido")
    @test occursin("cuadro-truco", string(cuadro))
end
