{% macro ref(model_name) %}

{% do return(builtins.ref(model_name).include(database=false)) %}

{% endmacro %}

{% macro source(source_name, table_name) %}

    {% do return(builtins.source(source_name, table_name).include(database=false)) %}

{% endmacro %}

{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = target.database -%}
    {%- if custom_database_name is none -%}

        {{ default_database }}

    {%- else -%}

        {{ custom_database_name | trim }}

    {%- endif -%}




{%- endmacro %}

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}