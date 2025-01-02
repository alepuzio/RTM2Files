#!/bin/bash
echo 'begin'
# leggo il file mettendo a capo
sed 's/{"id/\n{"id/g'  ./input/rtm_rememberthemilk.json> tmp_rememberthemilk_a_capo.json
# sposate i task con due:non vuota in un file specifico da caricare

grep \"date_due\": tmp_rememberthemilk_a_capo.json | awk -F '\"date_due\":' '{print $2}' | awk -F ',' '{print $1}' >tmp_rememberthemilk_calendario.json

#attivita_ripetitive
#repeat_every

grep -v \"date_due\" tmp_rememberthemilk_a_capo.json > tmp_rememberthemilk_senza_calendario.json

# spostare i task con tag:progetto in un file specifico da caricare
grep "progetto" tmp_rememberthemilk_senza_calendario.json > tmp_rememberthemilk_solo_progetti.json
grep -v "progetto" tmp_rememberthemilk_senza_calendario.json > tmp_rememberthemilk_senza_progetti.json

# spostare le note di archivio in un file specifico da caricare
#testo
grep "archivio_evernote" tmp_rememberthemilk_senza_progetti.json > tmp_rememberthemilk_solo_archivio_note.json
grep -v "archivio_evernote" tmp_rememberthemilk_senza_progetti.json> tmp_rememberthemilk_senza_archivio_note.json
# testo
grep "archivio_diigo" tmp_rememberthemilk_senza_archivio_note.json > tmp_rememberthemilk_solo_archivio_link.json
grep -v  "archivio_diigo" tmp_rememberthemilk_senza_archivio_note.json > tmp_rememberthemilk_senza_archivio_link.json

# spostare i task con le varie 
cp tmp_rememberthemilk_senza_archivio_link.json  tmp_rememberthemilk_solo_azioni.json

 array_position=(1339734 
1368077 
1368628 
1368632 
1368633 
1368634 
1368636 
1382160 
1382163 
1382675 
1403887
)


array_priority=(P1 P2 P3 PN)

array_time=(0M 10M 12H 15M 1H 20M 2H 2M 30M 3H 45M 5M 6H)

for priority in "${array_priority[@]}"
do
    echo "/***********priorita_$priority"
	for position in "${array_position[@]}"
	do
	    for time in ${array_time[@]}
	    do
		echo "$priority-$position-$time"
		grep $priority tmp_rememberthemilk_solo_azioni.json | grep $position | grep $time > rtm-$priority-$position-$time.txt

		awk -F '\"name\":'  '{print $2 }' rtm-$priority-$position-$time.txt > rtm-$priority-$position-$time-tmp.txt
		awk -F '\"priority\"' '{print $1}' rtm-$priority-$position-$time-tmp.txt >  rtm-$priority-$position-$time-only-name.txt
		awk -F '"tags":' '{print $2 }' rtm-$priority-$position-$time-tmp.txt > rtm-$priority-$position-$time-tag.txt
		paste rtm-$priority-$position-$time-only-name.txt rtm-$priority-$position-$time-tag.txt | column -s $'\t' -t > rtm-$priority-$position-$time-task.txt

		
		rm rtm-$priority-$position-$time.txt
		rm rtm-$priority-$position-$time-tmp.txt
		rm rtm-$priority-$position-$time-tag.txt
		rm rtm-$priority-$position-$time-only-name.txt
#	        rm rtm-$priority.txt	
	    done # time
	done # position
done #priority


#delete empty files
find . -size 0 -print -delete
#delete partial files

echo 'eliminati file vuoti'
echo 'end'
