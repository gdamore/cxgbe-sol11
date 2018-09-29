#!/bin/ksh

# We don't have SVR4 packaging nor do we want it on modern Solaris.
# So, we are going to install these drivers the hardware.

if grep -l cxgbe /etc/name_to_major
then
	rem_drv cxgbe
fi

if grep -l t4nex /etc/name_to_major
then
	rem_drv t4nex
fi

if modinfo -i t4nex > /dev/null 2>&1
then
	echo "Cannot unload cxgbe or t4nex driver."
	echo "Reboot and then come back here."
	exit
fi

compat2alias()
{
	alias=
	while [[ -n "$1" ]]
	do
		alias="$alias \"$1\"";
		shift
	done
	print $alias
}


SAFE=echo

installdrv()
{
	drv=$1

	if grep -l $drv /etc/name_to_major >/dev/null 2>&1
	then
		cmd=update_drv
	else
		cmd=add_drv
	fi

	if [[ ! -f obj.$(isainfo -k)/$drv ]]
	then
		echo "No module built for $drv."
		echo "Build it first!"
		return 1
	fi

	${SAFE} modunload -i $drv >/dev/null 2>&1

	if modinfo -i $drv >/dev/null 2>&1
	then
		echo "Driver is currently loaded."
		echo "A reboot may be needed."
	fi

	drvpath=/kernel/drv/$(isainfo -k)/$drv
	stamp=$(env TZ=UTC date +%FT%T)

	# make a backup
	if [[ -f $drvpath ]]
	then
		${SAFE} cp $drvpath $drvpath.$stamp
	fi

	${SAFE} cp obj.$(isainfo -k)/$drv $drvpath

	drvalias=$(compat2alias $(eval echo '$'${drv}_COMPAT))
	${SAFE} ${cmd} -i "${drvalias}" ${drv}
}

cxgbe_COMPAT=cxgbe
cxgbe_PERM='* 0666 root sys'

t4nex_PERM='* 0666 root sys'
t4nex_COMPAT="
	pciex1425,4400
	pciex1425,4401
	pciex1425,4402
	pciex1425,4403
	pciex1425,4404
	pciex1425,4405
	pciex1425,4406
	pciex1425,4407
	pciex1425,4408
	pciex1425,4409
	pciex1425,440a
	pciex1425,440d
	pciex1425,440e
	pciex1425,5400
	pciex1425,5401
	pciex1425,5402
	pciex1425,5403
	pciex1425,5404
	pciex1425,5405
	pciex1425,5406
	pciex1425,5407
	pciex1425,5408
	pciex1425,5409
	pciex1425,540a
	pciex1425,540b
	pciex1425,540c
	pciex1425,540d
	pciex1425,540e
	pciex1425,540f
	pciex1425,5410
	pciex1425,5411
	pciex1425,5412
	pciex1425,5413
	pciex1425,5414
	pciex1425,5415
	pciex1425,5416
	pciex1425,5417
	pciex1425,5418
	pciex1425,5480
	pciex1425,5481
	pciex1425,5482
	pciex1425,5486
	pciex1425,5487
	pciex1425,5488
	pciex1425,5489
	pciex1425,5490
	pciex1425,5491
	pciex1425,5492
	pciex1425,5493
	pciex1425,5494
	pciex1425,5495
	pciex1425,5496
	pciex1425,5497
	pciex1425,5498
	pciex1425,5499
	pciex1425,549a
	pciex1425,549b
	pciex1425,549c
	pciex1425,549d
	pciex1425,549e
	pciex1425,549f
	pciex1425,54a0
	pciex1425,54a1
	pciex1425,6400
	pciex1425,6401
	pciex1425,6402
	pciex1425,6403
	pciex1425,6404
	pciex1425,6405
	pciex1425,6406
	pciex1425,6407
	pciex1425,6408
	pciex1425,6409
	pciex1425,640d
	pciex1425,6410
	pciex1425,6411
	pciex1425,6414
	pciex1425,6415
	pciex1425,6480
	pciex1425,6481"

DRVS="cxgbe t4nex"
for DRV in ${DRVS}
do

	drvpath=/kernel/drv/$(isainfo -k)
	stamp=$(env TZ=UTC date +%FT%T)

	# make a backup
	if [[ -f $drvpath/$DRV ]]
	then
		echo cp $drvpath/$DRV $drvpath/$DRV.$stamp
	fi

	echo cp obj.$(isainfo -k)/$DRV $drvpath

	drvalias=$(compat2alias $(eval echo '$'${DRV}_COMPAT))
	echo add_drv -i "${drvalias}" ${DRV}
done
