{{ config( tags=['hub']) }}

{% set yaml_metadata %}
source_model: stg_prac
src_pk: HK_H_PRCTNR
src_nk: 
- CO_CD
- BK_PRCTNR_ID
- BKCC_PRCTNR
src_ldts: LOAD_TS
src_source: REC_SRC
{% endset %}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.hub(src_pk=metadata_dict["src_pk"],
                   src_nk=metadata_dict["src_nk"], 
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"]) }}