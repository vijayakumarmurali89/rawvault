-- depends_on: {{ ref('e_s_prac') }}
-- depends_on: {{ ref('e_h_prac') }}
-- depends_on: {{ ref('s_prac') }}

{{ config (
    pre_hook = ["truncate table {{ this }}"], 
    tags=["load"],
    materialized='incremental',
    target_table='prac'
) }}

WITH S_PRAC AS 
(
    SELECT 
         HK_H_PRCTNR
        ,PRAC_ID
        ,FNM
        ,MNM
        ,LNM
        ,XNM
        ,SEX
        ,DOB
        ,DEGR
        ,REC_SRC
        ,DEL_IND
        ,LOAD_TS
    FROM {{ ref('s_prac') }}
    {{ active_record('PRAC_ID','LOAD_TS') }}

    {% if is_incremental() %}
        AND {{ get_ldts('LOAD_TS','S_PRAC') }}
    {% endif %}
),

H_PRAC AS 
(
    SELECT 
         HK_H_PRCTNR
        ,LOAD_TS
        ,REC_SRC
        ,CO_CD
        ,BK_PRCTNR_ID
        ,BKCC_PRCTNR
    FROM {{ ref('h_prac') }}
),

FINAL AS 
(
    SELECT
         S_PRAC.PRAC_ID AS PRCTNR_ID
        ,S_PRAC.FNM AS FIRST_NM
        ,S_PRAC.MNM AS MID_NM
        ,S_PRAC.LNM AS LAST_NM
        ,S_PRAC.XNM AS SUFX_NM
        ,CONCAT(
            IFF(S_PRAC.FNM IS NULL,'',S_PRAC.FNM||' '),
            IFF(S_PRAC.MNM IS NULL,'',S_PRAC.MNM||' '),
            IFF(S_PRAC.LNM IS NULL,'',S_PRAC.LNM)
        ) AS FULL_NM
        ,S_PRAC.SEX AS RPRT_GNDR_CD
        ,S_PRAC.DEGR AS PRCTNR_DEGR_CD
        ,H_PRAC.CO_CD AS CO_CD
        ,H_PRAC.REC_SRC AS SS_CD
        ,TO_DATE(S_PRAC.DOB,'MM-DD-YYYY')  AS BTH_DT
        ,CASE WHEN S_PRAC.DEL_IND = 'Y' THEN 1 ELSE 0 END AS DEL_IND 
        ,CURRENT_TIMESTAMP() AS INSRT_TS
        ,CURRENT_TIMESTAMP() AS UPDT_TS
    FROM S_PRAC 
    INNER JOIN H_PRAC 
        ON S_PRAC.HK_H_PRCTNR = H_PRAC.HK_H_PRCTNR
)

SELECT
     PRCTNR_ID                 ::VARCHAR(80)      AS PRCTNR_ID
    ,SS_CD                     ::VARCHAR(20)      AS SS_CD
    ,CO_CD                     ::VARCHAR(20)      AS CO_CD
    ,FIRST_NM                  ::VARCHAR(200)     AS FIRST_NM
    ,MID_NM                    ::VARCHAR(100)     AS MID_NM
    ,LAST_NM                   ::VARCHAR(200)     AS LAST_NM
    ,FULL_NM                   ::VARCHAR(400)     AS FULL_NM
    ,SUFX_NM                   ::VARCHAR(70)      AS SUFX_NM
    ,BTH_DT                    ::DATE             AS BTH_DT
    ,RPRT_GNDR_CD              ::VARCHAR(25)      AS RPRT_GNDR_CD
    ,PRCTNR_DEGR_CD            ::VARCHAR(25)      AS PRCTNR_DEGR_CD
    ,DEL_IND                   ::NUMBER(1)        AS DEL_IND
    ,INSRT_TS                  ::TIMESTAMP_NTZ(9) AS INSRT_TS
    ,UPDT_TS                   ::TIMESTAMP_NTZ(9) AS UPDT_TS
FROM FINAL
