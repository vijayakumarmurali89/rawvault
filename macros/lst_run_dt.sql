{% macro get_ldts(ldts_col='LOAD_TS', prefix=None) %}

    {# Query the max load timestamp from the source table #}
    {% set ldts_query %}
        select coalesce(max(LAST_RUN_DT), current_timestamp())::timestamp_ntz(9) as rtv
        from {{source('dbt_vm','dbt_dt_log')}}
    {% endset %}

    {# Execute the query #}
    {% set ldts = run_query(ldts_query).columns[0].values()[0] %}

    {# Build the WHERE clause #}
    {% if prefix %}
        {{ prefix }}.{{ ldts_col }} > '{{ ldts }}'
    {% else %}
        {{ ldts_col }} > '{{ ldts }}'
    {% endif %}
    
    {%- set insert_entry -%}
      insert into {{ source('dbt_vm','dbt_dt_log') }}
      (LAST_RUN_DT,
      TBL_NAME)
      values ( CURRENT_TIMESTAMP()::TIMESTAMP_NTZ(9),
               'PRAC');
    {%- endset -%}

    {% do run_query(insert_entry) %} 

{% endmacro %}



{% macro active_record(part_col, ord_by_col) %}
      qualify
            row_number() over (
                partition by 
                {% if part_col is string %} 
                   {{part_col}}
                {% else %}
                    {{part_col | join(', ')}}
                {% endif %}
                order by {{ord_by_col}} desc
            )
            = 1
{% endmacro %}