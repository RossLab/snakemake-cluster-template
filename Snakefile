# Space for preprocessing

### if environmental variable USE_LOCAL contains anything, it will compute on /scratch/local
cluster_script = os.environ.get("USE_LOCAL")
if cluster_script == None :
	cluster_script = ""
else :
	cluster_script = "scripts/use_local.sh "


### rules for calling
## all
rule all :
	input : "data/final_result.txt"

##
## help : print this help
rule help :
	shell :
		"sed -n 's/^##//p' Snakefile"

rule get_data :
	threads : 1
	output : "data/{sp}.txt"
	shell : cluster_script + "scripts/get_data.sh {wildcards.sp}"

rule get_results :
	threads : 1
	input : "data/hummingbird.txt", "data/mealybug.txt"
	output : "data/final_result.txt"
	shell : "wc -l {input} 1> {output}"
