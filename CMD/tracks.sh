cd `readlink -f $0 | xargs dirname`
cd ../simulation
for i in `find . -iname *.npy`
do
	basename $i | sed 's/\.npy//'
done
