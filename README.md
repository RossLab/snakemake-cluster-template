
Activate a snakemake conda enviroment (alternatively make your own)

```
conda activate snake_env
```

Then

```
snakemake_clust.sh
```

should excute the default target, which is a dummy text file for now.


### Snakemake tips

apparently I can produce a graph of the workflow (it's really pretty) :

```
snakemake --forceall --dag | dot -Tpng > dag1.png
```

Snakemake version of make clean (removed all downloaded and coputed data) is

```
rm $(snakemake --summary | tail -n+2 | cut -f1)
```

Snakemake version of GNU make dry run (show commands, don't execute them) is

```
snakemake -p --quiet -n
```
