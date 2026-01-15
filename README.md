# EDTA_gff3_finer

Get level-clearer TE annotation file based on EDTA-outputted gff3 and manuel-curated TE classification.

## Usage
```bash
EDTA_gff3_finer.sh \
-g EDTA.gff3 \
-o TE_ontology_plant.txt \
-t TE_classification_plant.txt \
-out output.EDTA.bed
```

## Output
TE annotation and classification in `bed`-like format
`$1: chromosome`
`$2: start site (base-1 compared to gff3 format)`
`$3: end site`
`$4: classification extracted from EDTA gff3 column $9`
`$5: Superfamily in TE_classification_plant.txt`
`$6: Order in TE_classification_plant.txt`
`$7: Classification in TE_classification_plant.txt`

```bash
01	0	34960	DNA/Mutator/MITE	DNA/TIR/Mutator	DNA/TIR	DNA
01	35111	35640	LTR/Copia/Angela	RT/LTR/Copia	RT/LTR	RT
01	35324	35681	LTR	RT/LTR/other	RT/LTR	RT
01	35576	35694	LTR/Copia	RT/LTR/Copia	RT/LTR	RT
01	35706	36054	DNA/hAT/nMITE	DNA/TIR/hAT	DNA/TIR	DNA
01	36153	36321	nMITE	DNA/other	DNA/other	DNA
```