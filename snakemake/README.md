# MGE via snakemake with added functionality for BGE #
## Requirements: ##
- snakefile (-standard or -fastpmerge)
- config.yaml (containing:)
  - Name of MitoGeneExtractor run (will be used for naming summary stats CSV output and concatenated consensus fasta file containing barcodes).
  - Path to 'MitoGeneExtractor-vx.y.z' file (see installation guidance on main readme)
  - Path to'samples.csv' (example below)
  - Path to 'protein_references.csv' (example below)
  - Path to output directory (new directories will be created)
  - Gene of interest (e.g. cox1)
  - Parameters: r (Exonerate relative score threshold) and s (Exonerate minimum score threshold). See guidance on main readme.
- Activated conda env - See mge_env.yaml
- Can be run on a cluster using 'snakemake.sh'



**protein_references.csv example** 
| ID | matched_term | accession_number | length | reference_path | reference_name | tax_validated | ncbi_taxonomy |
| --- | --- | --- | --- | --- | --- | --- | --- |
| BSNHM002-24  | Genus: Apatania | AHF21732.1 | 510 | abs/path/to/protein_references/BSNHM002-24.fasta | BSNHM002-24 | true | Eukaryota, Metazoa, Ecdysozoa, Arthropoda, Hexapoda, Insecta, Pterygota, Neoptera, Endopterygota, Trichoptera, Integripalpia, Plenitentoria, Limnephiloidea, Apataniidae, Apataniinae, Apatania |
| BSNHM038-24 | Genus: Ernodes | UPX88773.1 | 511 | abs/path/to/protein_references/BSNHM038-24.fasta | BSNHM038-24 | true | Eukaryota, Metazoa, Ecdysozoa, Arthropoda, Hexapoda, Insecta, Pterygota, Neoptera, Endopterygota, Trichoptera, Integripalpia, Brevitentoria, Sericostomatoidea, Beraeidae, Ernodes | 
| BSNHM046-24 | Genus: Polycentropus | QLY89541.1 | 511 | abs/path/to/protein_references/BSNHM046-24.fasta | BSNHM046-24 | true | Eukaryota, Metazoa, Ecdysozoa, Arthropoda, Hexapoda, Insecta, Pterygota, Neoptera, Endopterygota, Trichoptera, Annulipalpia, Psychomyioidea, Polycentropodidae, Polycentropodinae, Polycentropus |
  
  

## Running: ##
### 1. Clone github repository ###

### 2. Generate samples.csv ###
- Can be created via [sample-processing](https://github.com/bge-barcoding/sample-processing) workflow or manually.

**samples.csv example**
| ID | forward | reverse | taxid |
| --- | --- | --- | --- |
| BSNHM002-24  | abs/path/to/R1.fq.gz | abs/path/to/R2.fq.gz | 177658 |
| BSNHM038-24 | abs/path/to/R1.fq.gz | abs/path/to/R2.fq.gz | 177627 |
| BSNHM046-24 | abs/path/to/R1.fq.gz | abs/path/to/R2.fq.gz | 3084599 |

### 3. Fetch sample-specific protein references using 1_gene_fetch.py ###
- [1_gene_fetch.py](https://github.com/SchistoDan/MitoGeneExtractor/blob/main/snakemake/1_gene_fetch.py) fetches sample-specific protein (pseudo)references using taxonomic ids and creates protein_references.csv required in config.yaml 
1_gene_fetch.py usage:
 - *python 1_gene_fetch.py <gene_name> <output_directory> <samples.csv>*
    - <gene_name>: Name of gene to search for in NCBI RefSeq database (e.g., cox1/COX1).
    - <output_directory>: Path to directory to save output files (will save .fasta files and summary CSV in this directory). The directory will be created if it does not exist.
    - <samples.csv>: Path to input CSV file containing Process IDs (ID column) and TaxIDs (taxid column).
- 'Checkpointing' available: If the script fails during a run, it can be rerun using the same inputs and it will skip IDs with entries already in the protein_references.csv and with .fasta files already present in the output directory.
- Manually review the protein_references.csv after running as homonyms may possibly lead to incorrect protein references being fetched on occasion.

### 4. Edit config.yaml for run ###
- Update config.yaml with neccessary paths and variables.

### 5. Run snakefile ###
- Snakefile-standard = 'standard' MGE snakemake pipeline (based off of example-analysis-* snakemake pipeline)
- Snakefile-fastpmerge = Utilises a fastp merge step as a QC alternative to the 'standard' MGE pipeline.
- Locally: snakemake --snakefile <Snakefile> --configfile <config.yaml>
  - Optional: '-n' for dry run. '-p' to print shell commands to log.
- Cluster: See snakemake.sh
  - Optional: '--rerun-incomplete' to resume a previous run if failed.

### Test run ###
- Raw reads for 12 test samples can be downloaded [here](https://naturalhistorymuseum-my.sharepoint.com/personal/b_price_nhm_ac_uk/_layouts/15/onedrive.aspx?ct=1723035606962&or=Teams%2DHL&ga=1&LOF=1&id=%2Fpersonal%2Fb%5Fprice%5Fnhm%5Fac%5Fuk%2FDocuments%2F%5Ftemp%2F%5FBGEexamples4Felix%2F1%5Fraw%5Fdata). Each read pair must be in seperate subdirectories under a parent directory that can be called anything
- samples sheet (BGE_test_samples.csv) provided (paths to reads and references need to be altered to where you stored the reads)
- protein_references sheet (gene_fetch_BGE_test_data.csv) provided (in protein_references/).


## Scripts ##
- add_contam_refs.py = If running Snakefile/Snakefile-fastp using multi-fasta protein reference files containing target and contaminant protein reference sequences, this script will add  contmainant reference sequences to target reference fasta files (see script usage).
- mge_stats.py = This script (incorporated into 'rule extract_stats_to_csv') will use alignment fasta files and MGE.out files to generate summary statistics.

## To do ##
- Integrate 1_gene_fetch.py into snakefile.
- Make Workflow Hub compatible.
- Generate RO-crates.
  
