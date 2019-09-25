cd `readlink -f $0 | xargs dirname`
cd ..
for i in `find . -iname *k.npy`
do
	basename $i | sed 's/\.npy//'
done
