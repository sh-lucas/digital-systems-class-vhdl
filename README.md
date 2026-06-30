# Trabalho de Sistemas Digitais - Implementação em VHDL

O trabalho se propõe a fazer o seguinte algoritmo:

```
se (a > b), fazer (-ab + 3a⁴ + 6c²) / a; senão fazer ((b³ + a²) / (c + b))
```

Em duas versões distintas em filosofia:
- Uma o mais paralelizada possível (otimizar tempo/ciclos de clock)
- Outra o mais serializada possível (otimizar silício)


## Apresentação e Integrantes

Os integrantes do grupo são:
- Amanda Thum
- Lucas Schwalm Silva

Essa versão do trabalho foi feito apenas por Lucas Schwalm Silva; Amanda Thum apresentou sua própria implementação do trabalho e não colaborou diretamente (mas indiretamente sim) com este repositório. Nos ajudamos, especialmente nas fases iniciais de compreensão do problema, mas acabamos não alinhando ao final do projeto.

Por isso ambas as versões apresentadas e entregues aqui podem divergir em alguns aspectos, embora a base seja a mesma.


## Resultados, Testbenchs e Cálculo de Área do Circuito

Executei as implementações usando o emulador YOSYS / XILINX 7-SERIES.
Esse é um dos emuladores disponíveis no Vivado.

> OBS.: pode haver uma pequena diferença no número de células lógicas já que a versão exata do emulador pode não ser a mesma que o vivado utiliza, ou pode haver também uma diferença na forma como é feita a síntese.


### Resultados:

Conforme esperado, o circuito paralelo foi consideravelmente mais rápido, e o serial foi consideravelmente menor em área física, embora a diminuição de área seja percentualmente irrisória graças ao custo da implementação da divisão.

No circuito paralelo:
- Completou a fórmula em 5 ciclos para `a > b` e 4 ciclos para `a <= b`.
- Ocupou 68 FFs, 6 DSPs, 4182 LUTs, 699 carry4, 2303 muxes.
- Ocupou um total de 8014 células.

No circuito serial:
- Completou a fórmula em 8 ciclos para `a > b` e 6 ciclos para `a <= b`.
- Ocupou 68 FFs, 3 DSPs, 3933 LUTs, 683 carry4, 2428 muxes.
- Ocupou um total de 7871 células.

O circuito paralelo é aproximadamente **6,3% maior** em área (LUTs) e **50% a 60% mais rápido** em desempenho (Os 60% são referentes ao caminho "a > b" e os 50% são referentes ao caminho "a <= b").
