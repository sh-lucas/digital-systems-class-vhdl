# Dataflow e descrição das operações

Esse documento descreve o comportamento da máquina de estados e descreve as operações que devem ser feitas em cada um dos estados até a finalização do sistema digital.

O sistema digital deverá calcular a expressão:
    `se (a > b), fazer (-ab + 3a^4 + 6c^2) /a; senão fazer ((b^3 + a^2)/ (c + b))`
em hardware.
O documento em sí descreve apenas o comportamento da FSM e do Dataflow graph.


## Estados

- idle
- load/clear
- select
    A1: a^2 and c^2 
    A2: a^4 and 6c^2
    A3: 3a^4
    A4: 3a^4 + 6c^2 and ab
    A5: 3a^4 + 6c^2 - ab
    B1: b^2
    B2: b^3 and a^2
    B3: b^3 + a^2 and c+b
- division


# Fluxo

Começamos com `idle`, quando recebemos valores e um input de `start`, vamos para `load/clear`, onde os dados são todos carregados para registradores.
Depois, o `select` verifica se `a > b`, se sim, vamos para o caminho A, se não, vamos para o caminho B.
O caminho A vai fazer as operações A1 até A5, e o caminho B vai fazer as operações B1 até B3. Depois disso, fazemos sempre uma divisão entre os registradores/memórias temporárias, e o resultado será dado na saída, com o estado voltando para `idle`.


# Operações/Datapath

Algumas operações serão feitas em paralelo, em ULA's separadas. Acredito que seja possível guardar os valores das operações em apenas 2 registradores. 

select: `a` > `b`
A1: `a^2` and `c^2` 
A2: `a^4` and `6c^2`
A3: `3a^4`
A4: `3a^4 + 6c^2` and `ab`
A5: `3a^4 + 6c^2 - ab`
B1: `b^2`
B2: `b^3` and `a^2`
B3: `b^3 + a^2` and `c+b`


# Pseudo-python

```python
# Registradores
reg1 = 0
reg2 = 0

# Inputs
a, b, c = 10, 5, 2
start = True
is_idle = True

# FSM
if is_idle and start:
    is_idle = False
    
    if a > b:
        reg1 = c * c; reg2 = a * a
        reg1 = 6 * reg1; reg2 = reg2 * reg2
        reg2 = 3 * reg2
        reg1 = reg1 + reg2; reg2 = a
        reg1 = reg1 - a * b
    else:
        reg1 = b * b
        reg1 = reg1 * b; reg2 = a * a
        reg1 = reg1 + reg2; reg2 = c + b

    reg1 = reg1 // reg2
        
    result = reg1
    is_idle = True
```

# Observações

Temos sempre 2 ulas e 2 registradores no nosso databapth, então não precisamos fazer um select para o output das ulas: cada ula sempre salva em um registrador. 
Pode-se observar, também, que a ula2/reg2 nunca realiza a maioria dos cálculos, e por isso o datapath pode ser reduzido.    
Para isso, é necessário implementar alguma forma de disable para a ula2, já que as vezes ela não pode sobreescrever o valor do registrador. Implementamos isso usando uma op_code a mais de "bypass".   
