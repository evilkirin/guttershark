function usage {
	echo "usage: flashproject [projectname]";
}

if [ -z $1 ]; then
	usage
	exit
fi

if [ $1 = "h" ]; then
	usage
	exit
fi

if [ $1 = "-h" ]; then
	usage
	exit
fi

if [ $1 = "." ]; then
	usage
	exit
fi

if [ $1 != '.' ]; then
	mkdir -p ${1} 2>&1 >> /dev/null
	cd ${1}
fi

mkdir assets
mkdir -p deploy/audio
mkdir deploy/flv
mkdir deploy/img
mkdir deploy/js
mkdir deploy/swf
mkdir deploy/xml
mkdir source
mkdir source/classes
mkdir -p source/fla/imports