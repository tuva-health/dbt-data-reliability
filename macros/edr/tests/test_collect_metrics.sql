{% test collect_metrics(
    model,
    column_name=none,
    timestamp_column=none,
    time_bucket=none,
    days_back=64,
    backfill_days=none,
    where_expression=none,
    dimensions=none
) %}

    {{ config(
        tags=['elementary-tests'],
        meta={"elementary": {"include": false}}
    ) }}

    {% if not execute or not elementary.is_test_command() or not elementary.is_elementary_enabled() %}
        {% do return(elementary.no_results_query()) %}
    {% endif %}

    {% if not dimensions %}
        {% set dimensions = [] %}
    {% endif %}

    {% set model_relation = elementary.get_model_relation_for_test(model, context["model"]) %}
    {% if not model_relation %}
        {% do exceptions.raise_compiler_error("Unsupported model: " ~ model ~ " (this might happen if you override 'ref' or 'source')") %}
    {% endif %}

    {% if column_name %}
        {% do elementary.collect_column_metrics(model, model_relation, column_name, timestamp_column, time_bucket, days_back, backfill_days, where_expression, dimensions) %}
    {% else %}
        {% do elementary.collect_table_metrics(model, model_relation, timestamp_column, time_bucket, days_back, backfill_days, where_expression) %}
    {% endif %}

    {# This test always passes. #}
    {% do return(elementary.no_results_query()) %}
{% endtest %}
