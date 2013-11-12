# Sun Grid Engine translator
submit() {
	for ARG in $ARGS
	do
		ANAME=`echo $ARG | cut -d ':' -f1`
		AVAL=`echo $ARG | cut -d ':' -f2`
		if [ $ANAME = "cpu" ]
		then
			SUBARGS="$SUBARGS -pe $SGE_PE $AVAL"
		fi
	done

	HOLDFOR=""
	if [ ${#REQS} -ne "0" ]
	then
		#echo $REQS
		#HOLDFOR="-hold_jid"
		for REQ in $REQS
		do
			REQNODE=`arrayGet PROVIDES $REQ`
			HOLDID=`arrayGet ${SAMPLE}_JOBIDS ${REQNODE}`
			HOLDFOR="$HOLDFOR -hold_jid $HOLDID"
		done
	fi

	# Submit to SGE
	JOBID=`qsub \
		$HOLDFOR \
		-V \
		-N $JOB_NAME \
		-e $FILE_LOG_ERR \
		-o $FILE_LOG_OUT \
		$SUBARGS \
		$NODE \
		$ADDS`
		
	#echo $JOBID
	# Fix the JobID
	JOBID=`echo $JOBID | cut -d\  -f3`
}

# RoStr, back to you!
