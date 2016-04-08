#!/bin.bash

file1=$1
file2=$2
out_file=$3

plink --bfile ../data/working/typed_overlap/${file1} \
      --bmerge ../data/working/typed_overlap/${file2}.bed \
      ../data/working/typed_overlap/${file2}.bim \
      ../data/working/typed_overlap/${file2}.fam \
      --make-bed --out ../data/working/typed_overlap/dummy_merge

if [ -e "../data/working/typed_overlap/dummy_merge-merge.missnp" ]
then
    plink --bfile ../data/working/typed_overlap/${file2} \
          --flip ../data/working/typed_overlap/dummy_merge-merge.missnp \
          --make-bed --out ../data/working/typed_overlap/tmp_flipped
    rm ../data/working/typed_overlap/dummy_merge-merge.missnp
    plink --bfile ../data/working/typed_overlap/${file1} \
          --bmerge ../data/working/typed_overlap/tmp_flipped.bed \
          ../data/working/typed_overlap/tmp_flipped.bim \
          ../data/working/typed_overlap/tmp_flipped.fam \
          --make-bed --out ../data/working/typed_overlap/dummy_merge
fi

if [ -e "../data/working/typed_overlap/dummy_merge-merge.missnp" ]
then
    cat ../data/working/typed_overlap/dummy_merge-merge.missnp >> ../data/working/typed_overlap/del_snps.txt
    plink --bfile ../data/working/typed_overlap/tmp_flipped \
          --exclude ../data/working/typed_overlap/dummy_merge-merge.missnp \
          --make-bed --out ../data/working/typed_overlap/tmp_del
    plink --bfile ../data/working/typed_overlap/${file1} \
          --bmerge ../data/working/typed_overlap/tmp_del.bed \
          ../data/working/typed_overlap/tmp_del.bim \
          ../data/working/typed_overlap/tmp_del.fam \
          --make-bed --out ../data/working/typed_overlap/dummy_merge
fi

plink --bfile ../data/working/typed_overlap/dummy_merge \
      --exclude ../data/working/typed_overlap/del_snps.txt \
      --make-bed --out ../data/working/typed_overlap/${out_file}

rm ../data/working/typed_overlap/dummy_merge*
