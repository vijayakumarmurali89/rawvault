{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ["CO_CD","PRCTNR_ID","SS_CD"],
    merge_exclude_columns = ['INSRT_TS']
    )
}}
/* 
CTE to get the fields from wrk model of prctnr
*/
WITH SOURCE  AS 
(
SELECT
 CO_CD      
,PRCTNR_ID  
,SS_CD
,FIRST_NM    
,MID_NM  
,LAST_NM  
,FULL_NM       
,SUFX_NM  
,BTH_DT 
,DEL_IND 
,INSRT_TS 
,UPDT_TS 
FROM {{ ref('wrk_prac') }}
)
SELECT * FROM SOURCE 