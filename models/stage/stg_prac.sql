
{{ config( tags= ['stage'] ) }}

{%- set yaml_metadata -%}
source_model: raw_prac
derived_columns:
  LOAD_TS: CURRENT_TIMESTAMP()
hashed_columns:
  hk_h_prctnr:
    - 'PRAC_ID'
    - 'CO_CD'
    - 'BKCC_PRCTNR'
  hdiff_prctnr:
    is_hashdiff : true
    columns:
     - 'FNM'
     - 'MNM'
     - 'LNM'
     - 'XNM'
     - 'DEGR'
     - 'SEX'
     - 'DOB'
     - 'DEL_IND'
{%- endset -%}

{% set metadata_dict=fromyaml(yaml_metadata) %}

WITH STAGING AS (
{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns = none,
                     null_columns = none) }}
), 
FINAL AS (
    SELECT 
    HK_H_PRCTNR ::BINARY(16)  AS HK_H_PRCTNR
,LOAD_TS ::TIMESTAMP_NTZ(9)  AS LOAD_TS
,REC_SRC ::VARCHAR(20)  AS REC_SRC
,CO_CD ::VARCHAR(20)  AS CO_CD
,BK_PRCTNR_ID ::VARCHAR(20) AS BK_PRCTNR_ID
,BKCC_PRCTNR ::VARCHAR(20) AS BKCC_PRCTNR
,HDIFF_PRCTNR ::BINARY(16)  AS HDIFF_PRCTNR
,PRAC_ID ::VARCHAR(20) AS PRAC_ID
,FNM ::VARCHAR(25) AS FNM
,MNM ::VARCHAR(25) AS MNM
,LNM ::VARCHAR(25) AS LNM
,XNM ::VARCHAR(7) AS XNM
,DEGR ::VARCHAR(25) AS DEGR
,SEX ::VARCHAR(1) AS SEX
,DOB ::VARCHAR(20) AS DOB
,DEL_IND ::VARCHAR(1)  AS DEL_IND
FROM STAGING
)
SELECT * FROM FINAL