#!/bin/bash
echo 'begin'
# leggo il file mettendo a capo
sed 's/{"id/\n{"id/g'  ./input/rtm_rememberthemilk.json >./partial/tmp_rememberthemilk_a_capo.json


# sposate i task con due:non vuota in un file specifico da caricare
grep \"date_due\": ./partial/tmp_rememberthemilk_a_capo.json | awk -F '\"date_due\":' '{print $2}' | awk -F ',' '{print $1}' > rememberthemilk_calendario.txt


#attivita_ripetitive
#repeat_every
##TODO
grep -v \"date_due\" ./partial/tmp_rememberthemilk_a_capo.json > ./partial/tmp_rememberthemilk_senza_calendario.json

# TODO spostare
# spostare i task con tag:progetto in un file specifico da caricare
grep "progetto" ./partial/tmp_rememberthemilk_senza_calendario.json > ./partial/rtm_progetti_tmp.txt
awk -F \"name\":  '{print $2 }'      ./partial/rtm_progetti_tmp.txt > ./partial/rtm_progetto_nome_tmp.txt
awk -F \"priority\":  '{print $1 }'  ./partial/rtm_progetto_nome_tmp.txt >  ./partial/rtm_progetto_nome.txt
#TODO puo' esserci \"tag:Aabcfd\"
awk -F \"tags\": '{print $2 }'       ./partial/rtm_progetto_nome_tmp.txt >  ./partial/rtm_progetto_tag.txt

paste  ./partial/rtm_progetto_nome.txt  ./partial/rtm_progetto_tag.txt | column -s $';\t' -t > rtm_progetto.txt



# spostare le note di archivio in un file specifico da caricare
grep -v "progetto" ./partial/tmp_rememberthemilk_senza_calendario.json > ./partial/tmp_rememberthemilk_senza_progetti.json
grep "archivio_evernote" ./partial/tmp_rememberthemilk_senza_progetti.json > ./partial/rtm_archivio_note_tmp.txt
awk -F \"name\":  '{print $2 }'      ./partial/rtm_archivio_note_tmp.txt > ./partial/rtm_archivio_note_nome_tmp.txt
awk -F \"priority\":  '{print $1 }'  ./partial/rtm_archivio_note_nome_tmp.txt >  ./partial/rtm_archivio_note_nome.txt
#TODO puo' esserci \"tag:Aabcfd\"
awk -F \"tags\": '{print $2 }'       ./partial/rtm_archivio_note_nome_tmp.txt >  ./partial/rtm_archivio_note_tag.txt

paste  ./partial/rtm_archivio_note_nome.txt  ./partial/rtm_archivio_note_tag.txt | column -s $';\t' -t > rtm_archivio_note.txt

# link
grep -v "archivio_evernote" ./partial/tmp_rememberthemilk_senza_progetti.json > ./partial/tmp_rememberthemilk_senza_archivio_note.json
grep "archivio_diigo" ./partial/tmp_rememberthemilk_senza_archivio_note.json > ./partial/rtm_archivio_link_tmp.txt

awk -F \"name\":  '{print $2 }'      ./partial/rtm_archivio_link_tmp.txt >      ./partial/rtm_archivio_link_nome_tmp.txt
awk -F \"priority\":  '{print $1 }'  ./partial/rtm_archivio_link_nome_tmp.txt > ./partial/rtm_archivio_link_nome.txt
awk -F \"tags\": '{print $2 }'       ./partial/rtm_archivio_link_nome_tmp.txt >     ./partial/rtm_archivio_link_tag.txt

paste ./partial/rtm_archivio_link_nome.txt  ./partial/rtm_archivio_link_tag.txt | column -s $';\t' -t > rtm_archivio_link.txt

grep -v  "archivio_diigo" ./partial/tmp_rememberthemilk_senza_archivio_note.json > ./partial/tmp_rememberthemilk_senza_archivio_link.json



# spostare i task con le varie 
cp ./partial/tmp_rememberthemilk_senza_archivio_link.json  ./partial/tmp_rememberthemilk_solo_azioni.json

#declare -A array=([sem1,0]="first name" [sem1,1]="second name" [sem2,0]="third name" [sem3,0]="foo bar")
declare -A array_position
array_position["1339734"]="youtube"
# 1368077 
array_position["1368077"]="casa-milano"
array_position["1378628"]="boh1"
array_position["1368633"]="computer"
array_position["1368634"]="telefono"
array_position["1368636"]="stampante"
array_position["1382160"]="citta_milano"
array_position["1382163"]="sesto_san_giovanni"
array_position["1368632"]="mail"
array_position["1382675"]="segrate_novegro"
array_position["1403887"]="pc_lavoro"
# 1368628 
# 1368632 
# 1368633 
# 1368634 
# 1368636 
# 1382160 
# 1382163 
# 1382675 
# 1403887
# )


array_priority=(P1  P2 P3 PN)

array_time=(0M 10M 12H 15M 1H 20M 2H 2M 30M 3H 45M 5M 6H)

for priority in "${array_priority[@]}"
do
   echo "/***********priorita_$priority"
	for position in "${array_position[@]}"
	do
	    for time in ${array_time[@]}
	    do
		echo "$priority-$position-$time"
		grep $priority ./partial/tmp_rememberthemilk_solo_azioni.json | grep $position | grep $time > ./partial/rtm-$priority-$position-$time.txt

		awk -F '\"name\":'  '{print $2 }' ./partial/rtm-$priority-$position-$time.txt > ./partial/rtm-$priority-$position-$time-tmp.txt
		awk -F '\"priority\"' '{print $1}' ./partial/rtm-$priority-$position-$time-tmp.txt > ./partial/rtm-$priority-$position-$time-only-name.txt
		awk -F '"tags":' '{print $2 }' ./partial/rtm-$priority-$position-$time-tmp.txt > ./partial/rtm-$priority-$position-$time-tag.txt
		paste ./partial/rtm-$priority-$position-$time-only-name.txt ./partial/rtm-$priority-$position-$time-tag.txt | column -s $'\t' -t > rtm-$priority-$position-$time-task.txt

		
		rm ./partial/rtm-$priority-$position-$time.txt
		rm ./partial/rtm-$priority-$position-$time-tmp.txt
		rm ./partial/rtm-$priority-$position-$time-tag.txt
		rm ./partial/rtm-$priority-$position-$time-only-name.txt
#	        rm ./partial/rtm-$priority.txt	
	    done # time
	done # position
done #priority

i = 0
for position in "${array_position[@]}"
do
	grep -v $position ./partial/tmp_rememberthemilk_solo_azioni.json > ./output/scarto_$i_esimo.txt
	$i = $i+1
done
#delete empty files
find . -size 0 -print -delete
#delete partial files

echo 'eliminati file vuoti'
echo 'end'
