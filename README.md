# jasmin-libjbn

**CPU:** AMD Ryzen 7 4700U ()

## Benchmark bn para 7 limbs

- `cd bench_bn`
- `sudo ./bench.sh` (é preciso sudo por causa do `echo 3 > /proc/sys/vm/drop_caches`)
- executar o notebook `bench-notebook.ipynb` para ver o gráfico

## Benchmark para bn antes e depois da protecao (para 4 < limbs < 50)

- `cd bench_bn_limbs`
- `sudo ./bench.sh` (é preciso sudo por causa do `echo 3 > /proc/sys/vm/drop_caches`) (demora ~20min)
- executar o notebook `bench-notebook.ipynb` para ver os gráfico

## Fp

- Erro "speculative constant type checker: constraints caused by the loop cannot be satisfied" na função
  `_fp_exp` (fp/amd64/ref/fp_generic_export.jinc)
- Nos benchmarks, os resultados para as funcoes `fp_inv` e `fp_expm_noct` sao inuteis pq dependem da funcao
  de exponenciacao, que ainda nao esta protegida
