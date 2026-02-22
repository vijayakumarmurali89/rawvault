{{ config(
        materialized = 'ephemeral',
) }}
   SELECT
    HK_H_PRCTNR
	 ,LOAD_TS
	 ,HDIFF_PRCTNR
	 ,REC_SRC
	 ,PRAC_ID
	 ,FNM,MNM
	 ,LNM
	 ,XNM
	 ,DEGR
	 ,SEX
	 ,DOB
	 ,DEL_IND 
     FROM 
        {{ ref ('s_prac') }}