#! /bin/csh
set list=$1

rm -rf tmp
touch tmp
foreach i (`cat $list`)
set len=`cat $i.res | grep DDG_B | awk 'BEGIN{tot=0}{if (substr($24,length($24),1)=="B") tot++;}END{print tot}'`
cat $i.res | grep DDG_B | awk 'BEGIN{tot=0; hs=0}{if (substr($24,length($24),1)=="B") {tot++; if  ($14 > 1) {hs++}}}END{print tot,hs}' >> tmp
end

foreach i ( 5 6 7 8 9 10 11 12 13 14 15 )
set avg=`cat tmp | awk '$1=='$i'' | /vol/ek/londonir/scripts/avgNstd.sh | head -1`
set std=`cat tmp | awk '$1=='$i'' | /vol/ek/londonir/scripts/avgNstd.sh | tail -1`
echo "$avg $std" 
end
