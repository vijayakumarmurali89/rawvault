--{{ config(tags=['sat'])}}
{{ config(materialized = 'table') }}
{%- set yaml_metadata -%}
source_model: "stg_prac"
src_pk: "HK_H_PRCTNR"
source_hashdiff: "HDIFF_PRCTNR"
src_ldts: "LOAD_TS"
src_eff: "LOAD_TS"
src_payload:
   - 'REC_SRC'
   - 'PRAC_ID' 
   - 'FNM'
   - 'MNM'
   - 'LNM'
   - 'XNM'
   - 'DEGR'
   - 'SEX'
   - 'DOB'
   - 'DEL_IND'
{%- endset -%}

{%- set metadata_dict=fromyaml(yaml_metadata) -%}

{{ automate_dv.sat(src_pk=metadata_dict["src_pk"],
                   src_hashdiff=metadata_dict["source_hashdiff"],
                   src_payload=metadata_dict["src_payload"],
                   src_ldts = metadata_dict["src_ldts"],
                   src_eff=metadata_dict["src_eff"],
                   source_model=metadata_dict["source_model"]) }}