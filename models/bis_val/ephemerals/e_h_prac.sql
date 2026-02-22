{ config(
        materialized = 'ephemeral'
           ) }}
   SELECT 
     HK_H_PRCTNR,
     LOAD_TS,
     REC_SRC,
     CO_CD,
     BK_PRCTNR_ID,
     BKCC_PRCTNR FROM 
         {{ ref('h_prac') }}