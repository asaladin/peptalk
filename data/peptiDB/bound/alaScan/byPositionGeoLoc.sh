#! /bin/csh
set list=$1

rm -rf tmp
touch tmp

foreach i (`cat $list`)
set len=`cat $i.res | grep DDG_B | awk 'BEGIN{tot=0}{if (substr($24,length($24),1)=="B") tot++;}END{print tot}'`
if ($len>5) then
cat $i.res | grep DDG_B | awk 'BEGIN{n=0; n1=0; n2=0; c=0; c1=0; c2=0; mid=0; pos=0; numOfMid=0;}{if (substr($24,length($24),1)=="B") {pos=pos+1; if ((pos>3) && (pos<('$len'-2))) numOfMid++; if  ($14 > 1) {place=pos/'$len'; if (pos==1) n++; else {if (pos==2) n1++; else {if (pos==3) n2++; else {if (pos=='$len') c++; else {if(pos=='$len-1') c1++; else {if (pos=='$len-2') c2++; else {mid++}}}}}} }}}END{print n,n1,n2,mid,c2,c1,c,numOfMid}' >> tmp
endif
end

cat tmp | /vol/ek/londonir/scripts/sumColumns.sh
