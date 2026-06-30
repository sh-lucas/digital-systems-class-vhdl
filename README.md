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




Os resultados detalhados de simulação de tempo de execução (latência) e síntese lógica real (área física para Xilinx 7-Series) foram compilados no arquivo [result_notes.txt](result_notes.txt).

### Resumo Comparativo:

| Métrica | Versão Paralela (`parallel_01`) | Versão Serial (`serial_01`) | Comparação |
|---|---|---|---|
| **Latência (Caminho A)** | 5 ciclos (75 ns) | 8 ciclos (105 ns) | **Paralelo 37.5% mais rápido** |
| **Latência (Caminho B)** | 4 ciclos (155 ns) | 6 ciclos (205 ns) | **Paralelo 33.3% mais rápido** |
| **Flip-Flops (FFs)** | 68 FFs | 68 FFs | **Empate** (mesmos registradores de 32 bits) |
| **Multiplicadores (DSPs)**| 6 DSPs | 3 DSPs | **Serial economiza 50% de DSPs** |
| **Lógica (LUTs)** | 4182 LUTs | 3933 LUTs | **Serial economiza 5.9% de LUTs** |
| **Células Totais** | 8014 células | 7871 células | **Serial é 1.8% menor no chip** |

### Rodando com o `vhdel`

Para compilar, rodar os testbenches e gerar as estatísticas de síntese lógica exatas de cada pasta, você pode usar o comando customizado:

```bash
# Para a versão serial
vhdel serial_01/

# Para a versão paralela
vhdel parallel_01/
```