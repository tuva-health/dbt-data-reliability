{% macro get_common_test_config_by_flattened_test(flattened_test) %}
  {% set test_name = flattened_test['short_name'] %}
  {% set test_namespace = flattened_test['test_namespace'] %}
  {% do return(elementary.get_common_test_config_by_namespace_and_name(test_namespace, test_name)) %}
{% endmacro %}

{% macro get_common_test_config_by_namespace_and_name(test_namespace, test_name) %}
  {% set common_tests_configs_mapping = elementary.get_common_tests_configs_mapping() %}
  {% if test_namespace is none %}
    {% set test_namespace = 'dbt' %}
  {% endif %}
  {% if test_namespace in common_tests_configs_mapping %}
    {% if test_name in common_tests_configs_mapping[test_namespace] %}
      {% do return(common_tests_configs_mapping[test_namespace][test_name]) %}
    {% endif %}
  {% endif %}
  {% do return(none) %}
{% endmacro %}

{% macro get_common_tests_configs_mapping() %}
  {#
    Configurations for common tests (dbt builtins, dbt_utils, dbt_expectations, etc)
    The format of the mapping is:
    {
      <package_name>: {
        <test_name>: <config>
      }
    }
    The config may contain:
      description: A human readable description of the test.
      failed_count: Configuration to get the number of failed rows from the test result, see handle_failed_test_result_count.sql for details.
  #}
  {% set common_tests_configs_mapping = {
      "dbt": {
        "not_null": {
          "failed_count": {
            "method": "count"
          },
          "description": "This test validates that there are no `null` values present in a column."
        },
        "relationships": {
          "failed_count": {
            "method": "count"
          },
          "description": "This test validates that all of the records in a child table have a corresponding record in a parent table. This property is referred to as \"referential integrity\"."
        },
        "unique": {
          "failed_count": {
            "method": "sum",
            "parameters": ["n_records"]
          },
          "description": "This test validates that there are no duplicate values present in a field."
        },
        "accepted_values": {
          "failed_count": {
            "method": "sum",
            "parameters": ["n_records"]
          },
          "description": "This test validates that all of the values in a column are present in a supplied list of `values`. If any values other than those provided in the list are present, then the test will fail."
        }
      },
      "dbt_expectations": {
        "expect_column_values_to_not_be_null": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column values to not be null."
        },
        "expect_column_values_to_be_null": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column values to be null."
        },
        "expect_column_values_to_be_in_set": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect each column value to be in a given set."
        },
        "expect_column_values_to_be_between": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect each column value to be between two values."
        },
        "expect_column_values_to_not_be_in_set": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect each column value not to be in a given set."
        },
        "expect_column_values_to_be_increasing": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column values to be increasing. If `strictly: True`, then this expectation is only satisfied if each consecutive value is strictly increasing \u2013 equal values are treated as failures."
        },
        "expect_column_values_to_be_decreasing": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column values to be decreasing. If `strictly=True`, then this expectation is only satisfied if each consecutive value is strictly decreasing \u2013 equal values are treated as failures."
        },
        "expect_column_value_lengths_to_be_between": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column entries to be strings with length between a min_value value and a max_value value (inclusive)."
        },
        "expect_column_value_lengths_to_equal": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column entries to be strings with length equal to the provided value."
        },
        "expect_column_values_to_match_regex": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column entries to be strings that match a given regular expression. Valid matches can be found anywhere in the string, for example \"[at]+\" will identify the following strings as expected: \"cat\", \"hat\", \"aa\", \"a\", and \"t\", and the following strings as unexpected: \"fish\", \"dog\". Optionally, `is_raw` indicates the `regex` pattern is a \"raw\" string and should be escaped. The default is `False`."
        },
        "expect_column_values_to_not_match_regex": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column entries to be strings that do NOT match a given regular expression. The regex must not match any portion of the provided string. For example, \"[at]+\" would identify the following strings as expected: \"fish\u201d, \"dog\u201d, and the following as unexpected: \"cat\u201d, \"hat\u201d. Optionally, `is_raw` indicates the `regex` pattern is a \"raw\" string and should be escaped. The default is `False`."
        },
        "expect_column_values_to_match_regex_list": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect the column entries to be strings that can be matched to either any of or all of a list of regular expressions. Matches can be anywhere in the string. Optionally, `is_raw` indicates the `regex` patterns are \"raw\" strings and should be escaped. The default is `False`."
        },
        "expect_column_values_to_not_match_regex_list": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect the column entries to be strings that do not match any of a list of regular expressions. Matches can be anywhere in the string. Optionally, `is_raw` indicates the `regex` patterns are \"raw\" strings and should be escaped. The default is `False`."
        },
        "expect_column_values_to_match_like_pattern": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column entries to be strings that match a given SQL like pattern."
        },
        "expect_column_values_to_not_match_like_pattern": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect column entries to be strings that do not match a given SQL like pattern."
        },
        "expect_column_values_to_match_like_pattern_list": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect the column entries to be strings that match any of a list of SQL like patterns."
        },
        "expect_column_values_to_not_match_like_pattern_list": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect the column entries to be strings that do not match any of a list of SQL like patterns."
        },
        "expect_column_pair_values_A_to_be_greater_than_B": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect values in column A to be greater than column B."
        },
        "expect_column_pair_values_to_be_equal": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect the values in column A to be the same as column B."
        },
        "expect_column_pair_values_to_be_in_set": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect paired values from columns A and B to belong to a set of valid pairs. Note: value pairs are expressed as lists within lists"
        },
        "expect_select_column_values_to_be_unique_within_record": {
          "failed_count": {
            "method": "count"
          },
          "description": "Expect the values for each record to be unique across the columns listed. Note that records can be duplicated."
        },
        "expect_column_values_to_be_unique": {
          "description": "Expect each column value to be unique."
        },
        "expect_compound_columns_to_be_unique": {
          "description": "Expect that the columns are unique together, e.g. a multi-column primary key."
        },
        "expect_column_to_exist": {
          "description": "Expect the specified column to exist."
        },
        "expect_row_values_to_have_recent_data": {
          "description": "Expect the model to have rows that are at least as recent as the defined interval prior to the current timestamp. Optionally gives the possibility to apply filters on the results."
        },
        "expect_grouped_row_values_to_have_recent_data": {
          "description": "Expect the model to have grouped rows that are at least as recent as the defined interval prior to the current timestamp. Use this to test whether there is recent data for each grouped row defined by `group_by` (which is a list of columns) and a `timestamp_column`. Optionally gives the possibility to apply filters on the results."
        },
        "expect_table_column_count_to_be_between": {
          "description": "Expect the number of columns in a model to be between two values."
        },
        "expect_table_column_count_to_equal_other_table": {
          "description": "Expect the number of columns in a model to match another model."
        },
        "expect_table_columns_to_not_contain_set": {
          "description": "Expect the columns in a model not to contain a given list."
        },
        "expect_table_columns_to_contain_set": {
          "description": "Expect the columns in a model to contain a given list."
        },
        "expect_table_column_count_to_equal": {
          "description": "Expect the number of columns in a model to be equal to `expected_number_of_columns`."
        },
        "expect_table_columns_to_match_ordered_list": {
          "description": "Expect the columns to exactly match a specified list."
        },
        "expect_table_columns_to_match_set": {
          "description": "Expect the columns in a model to match a given list."
        },
        "expect_table_row_count_to_be_between": {
          "description": "Expect the number of rows in a model to be between two values."
        },
        "expect_table_row_count_to_equal_other_table": {
          "description": "Expect the number of rows in a model match another model."
        },
        "expect_table_row_count_to_equal_other_table_times_factor": {
          "description": "Expect the number of rows in a model to match another model times a preconfigured factor."
        },
        "expect_table_row_count_to_equal": {
          "description": "Expect the number of rows in a model to be equal to expected_number_of_rows."
        },
        "expect_column_values_to_be_of_type": {
          "description": "Expect a column to be of a specified data type."
        },
        "expect_column_values_to_be_in_type_list": {
          "description": "Expect a column to be one of a specified type list."
        },
        "expect_column_values_to_have_consistent_casing": {
          "description": "Expect a column to have consistent casing. By setting `display_inconsistent_columns` to true, the number of inconsistent values in the column will be displayed in the terminal whereas the inconsistent values themselves will be returned if the SQL compiled test is run."
        },
        "expect_column_distinct_count_to_equal": {
          "description": "Expect the number of distinct column values to be equal to a given value."
        },
        "expect_column_distinct_count_to_be_greater_than": {
          "description": "Expect the number of distinct column values to be greater than a given value."
        },
        "expect_column_distinct_count_to_be_less_than": {
          "description": "Expect the number of distinct column values to be less than a given value."
        },
        "expect_column_distinct_values_to_be_in_set": {
          "description": "Expect the set of distinct column values to be contained by a given set."
        },
        "expect_column_distinct_values_to_contain_set": {
          "description": "Expect the set of distinct column values to contain a given set. In contrast to `expect_column_values_to_be_in_set` this ensures not that all column values are members of the given set but that values from the set must be present in the column."
        },
        "expect_column_distinct_values_to_equal_set": {
          "description": "Expect the set of distinct column values to equal a given set. In contrast to `expect_column_distinct_values_to_contain_set` this ensures not only that a certain set of values are present in the column but that these and only these values are present."
        },
        "expect_column_distinct_count_to_equal_other_table": {
          "description": "Expect the number of distinct column values to be equal to number of distinct values in another model."
        },
        "expect_column_mean_to_be_between": {
          "description": "Expect the column mean to be between a min_value value and a max_value value (inclusive)."
        },
        "expect_column_median_to_be_between": {
          "description": "Expect the column median to be between a min_value value and a max_value value (inclusive)."
        },
        "expect_column_quantile_values_to_be_between": {
          "description": "Expect specific provided column quantiles to be between provided min_value and max_value values."
        },
        "expect_column_stdev_to_be_between": {
          "description": "Expect the column standard deviation to be between a min_value value and a max_value value. Uses sample standard deviation (normalized by N-1)."
        },
        "expect_column_unique_value_count_to_be_between": {
          "description": "Expect the number of unique values to be between a min_value value and a max_value value."
        },
        "expect_column_proportion_of_unique_values_to_be_between": {
          "description": "Expect the proportion of unique values to be between a min_value value and a max_value value. For example, in a column containing [1, 2, 2, 3, 3, 3, 4, 4, 4, 4], there are 4 unique values and 10 total values for a proportion of 0.4."
        },
        "expect_column_most_common_value_to_be_in_set": {
          "description": "Expect the most common value to be within the designated value set."
        },
        "expect_column_max_to_be_between": {
          "description": "Expect the column max to be between a min and max value."
        },
        "expect_column_min_to_be_between": {
        "expect_column_sum_to_be_between": {
          "description": "Expect the column min to be between a min and max value."
        },
          "description": "Expect the column to sum to be between a min and max value."
        },
        "expect_multicolumn_sum_to_equal": {
          "description": "Expects that sum of all rows for a set of columns is equal to a specific value"
        },
        "expect_column_values_to_be_within_n_moving_stdevs": {
          "description": "A simple anomaly test based on the assumption that differences between periods in a given time series follow a log-normal distribution. Thus, we would expect the logged differences (vs N periods ago) in metric values to be within Z sigma away from a moving average. By applying a list of columns in the `group_by` parameter, you can also test for deviations within a group."
        },
        "expect_column_values_to_be_within_n_stdevs": {
          "description": "Expects (optionally grouped & summed) metric values to be within Z sigma away from the column average"
        },
        "expect_row_values_to_have_data_for_every_n_datepart": {
          "description": "Expects model to have values for every grouped `date_part`."
        }
      },
      "dbt_utils": {
        "equal_rowcount": {
          "failed_count": {
            "method": "sum",
            "parameters": ["diff_count"]
          }
        },
        "fewer_rows_than": {
          "failed_count": {
            "method": "sum",
            "parameters": ["row_count_delta"]
          }
        },
        "expression_is_true": {
          "failed_count": {
            "method": "count"
          }
        },
        "not_empty_string": {
          "failed_count": {
            "method": "count"
          }
        },
        "cardinality_equality": {
          "failed_count": {
            "method": "sum",
            "parameters": ["num_rows"]
          }
        },
        "sequential_values": {
          "failed_count": {
            "method": "count"
          }
        },
        "accepted_range": {
          "failed_count": {
            "method": "count"
          }
        }
      },
      "elementary": {
        "json_schema": {
          "failed_count": {
            "method": "count"
          }
        }
      }
    } %}
    {% do return(common_tests_configs_mapping) %}
{% endmacro %}