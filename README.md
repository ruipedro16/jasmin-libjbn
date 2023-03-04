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
