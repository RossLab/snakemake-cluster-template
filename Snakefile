# Space for preprocessing

localrules: all, help, get_results

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
	shadow: "shallow"
	output : "data/{sp}.txt"
	shell : "scripts/get_data.sh {wildcards.sp} > {output}"

rule get_results :
	threads : 1
	input : "data/hummingbird.txt", "data/mealybug.txt"
	output : "data/final_result.txt"
	shell : "wc -l {input} 1> {output}"
