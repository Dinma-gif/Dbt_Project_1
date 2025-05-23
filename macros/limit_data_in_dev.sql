{% macro limit_data_in_dev(column_name, days=3) %}
    {{ log("Current target name is: " ~ target.name, info=True) }}
    
    {% if target.name == "default" %}
        where {{ column_name }} >= dateadd(day, -{{ days }}, current_date)
    {% else %}
        -- No filtering in non-dev environments
    {% endif %}
{% endmacro %}
