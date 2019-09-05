view: zipcode_to_latlong_crosswalk {
  sql_table_name: tj_thesis_med.zipcode_to_latlong_crosswalk ;;

  parameter: zip_to_select {
    type: string
    suggest_dimension: zipcode
  }
  dimension: get_lat_value {
    type: string
    hidden: yes
    sql: CASE WHEN ${zipcode} = {{zip_to_select._parameter_value}} THEN ${lat} ELSE NULL END ;;
  }
  dimension: get_long_value {
    type: string
    hidden: yes
    sql: CASE WHEN ${zipcode} = {{zip_to_select._parameter_value}} THEN ${long} ELSE NULL END ;;
  }
  dimension: selected_lat {
    hidden: yes
    type: string
    sql: (SELECT ${get_lat_value} FROM tj_thesis_med.zipcode_to_latlong_crosswalk WHERE ${get_lat_value} IS NOT NULL);;
  }
  dimension: selected_long {
    hidden: yes
    type: string
    sql: (SELECT ${get_long_value} FROM tj_thesis_med.zipcode_to_latlong_crosswalk WHERE ${get_long_value} IS NOT NULL);;
  }
  dimension: selected_location {
    hidden: yes
    type: location
    sql_latitude: ${selected_lat} ;;
    sql_longitude: ${selected_long} ;;
  }
  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }
  dimension: long {
    type: number
    sql: ${TABLE}.long ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: LPAD(CAST(${TABLE}.zipcode as STRING), 5, '0');;
  }
  dimension: zipcode_lat_long {
    hidden: yes
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${long} ;;
  }

  dimension: distance_between_selected_city_and_user {
    label: "Distance in km"
    type: distance
    start_location_field: selected_location
    end_location_field: zipcode_lat_long
    units: kilometers
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
