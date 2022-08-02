# Scaling on perlmutter

I went through and wrote some slurm scripts to be able to run the scaling tests without getting an interactive node. 

I ran some tests by niavley just running on all 256 threads without any srun options with some [mixed results](results.whole_node.ipynb). There were wide variations in results between the number of threads used. 

I found the `srun` option `--cpu_bind=ldoms` which should:

```
ldoms
Automatically generate masks binding tasks to NUMA locality domains. If the number of tasks differs from the number of allocated locality domains this can result in sub-optimal binding.
```

This seemed to help with scaling but when a full node is requested only allowed for a single NUMA locality (32 threads) to be used even with a full reservation and using extra srun options `srun -n 1 -c 256 --cpu_bind=rank_ldom --overlap`.

I tried a shared node setup which lets you get a reservation up to half a node (128 threads) and this seems to work with the `--cpu_bind=rank_ldom` option as expected at ranges from [32 threads](results.32threads_shared.ipynb), [64 threads](results.64threads_shared.ipynb), and [128 threads](results.128threads_shared.ipynb).

I'll investigate more with the differences in slurm setting between shared and exclusive nodes, but it looks like using a shared node will work well for clas12 reconstruction.
