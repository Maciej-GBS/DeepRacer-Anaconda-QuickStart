cd `readlink -f $0 | xargs dirname`
cd ..
for i in `find . -iname *track.npy`
do
	basename $i | sed 's/\.npy//'
done
