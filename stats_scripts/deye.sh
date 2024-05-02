#!/bin/bash


DIR="$(dirname "$(readlink -f "$0")")"

source $DIR/../translator.conf

stats=`deye-read $inverter_ip $inverter_sn`

vars=`echo "$stats" | tr -d '[]:' | grep -v "'" | awk '{print $1"="$2}'`
eval "$vars"

#printf "$vars"

advertised_data=

case $Inverter_State in
    ("StandBy") Inverter_State_numeric=1 ;;
    ("Normal") Inverter_State_numeric=2 ;;
    ("*") Inverter_State_numeric=9 ;;
esac

# General
advertised_data+="$inverter_name{stats=\"state\"} $Inverter_State_numeric\n"
advertised_data+="$inverter_name{stats=\"dc_transformer_temp\"} $Dc_Transformer_Temp\n"
advertised_data+="$inverter_name{stats=\"heatsink_temp\"} $Heatsink_Temp\n"


# AC Powers grid/load/generated per Phase
advertised_data+="$inverter_name{ac=\"frequency\"} $Grid_In_Frequency\n"

advertised_data+="$inverter_name{ac=\"voltage\", phase=\"A\"} $Grid_Phase_A_Volt\n"
advertised_data+="$inverter_name{ac=\"voltage\", phase=\"B\"} $Grid_Phase_B_Volt\n"
advertised_data+="$inverter_name{ac=\"voltage\", phase=\"C\"} $Grid_Phase_C_Volt\n"

advertised_data+="$inverter_name{ac=\"grid_power\", phase=\"A\"} $Grid_Phase_A_Out_Of_Grid_Power\n"
advertised_data+="$inverter_name{ac=\"grid_power\", phase=\"B\"} $Grid_Phase_B_Out_Of_Grid_Power\n"
advertised_data+="$inverter_name{ac=\"grid_power\", phase=\"C\"} $Grid_Phase_C_Out_Of_Grid_Power\n"

advertised_data+="$inverter_name{ac=\"generated_power\", phase=\"A\"} $Inverter_Phase_A_Out_Power\n"
advertised_data+="$inverter_name{ac=\"generated_power\", phase=\"B\"} $Inverter_Phase_B_Out_Power\n"
advertised_data+="$inverter_name{ac=\"generated_power\", phase=\"C\"} $Inverter_Phase_C_Out_Power\n"

advertised_data+="$inverter_name{ac=\"load_power\", phase=\"A\"} $Load_Phase_A_Power\n"
advertised_data+="$inverter_name{ac=\"load_power\", phase=\"B\"} $Load_Phase_B_Power\n"
advertised_data+="$inverter_name{ac=\"load_power\", phase=\"C\"} $Load_Phase_C_Power\n"

advertised_data+="$inverter_name{ac=\"total_grid_power\"} $Grid_Total_Out_Of_Grid_Power\n"
advertised_data+="$inverter_name{ac=\"total_generated_power\"} $Inverter_Total_Out_Power\n"
advertised_data+="$inverter_name{ac=\"total_load_power\"} $Load_Total_Power\n"

# Energy Count
advertised_data+="$inverter_name{energy=\"total_from_pv\"} $Total_From_Pv\n"
advertised_data+="$inverter_name{energy=\"total_from_grid\"} $Total_Bought_From_Grid\n"
advertised_data+="$inverter_name{energy=\"total_to_load\"} $Total_To_Load\n"

# Solar PV Data
advertised_data+="$inverter_name{dc=\"pv_voltage\", string=\"mppt1\"} $Pv1_Volt\n"
advertised_data+="$inverter_name{dc=\"pv_voltage\", string=\"mppt2\"} $Pv2_Volt\n"
advertised_data+="$inverter_name{dc=\"pv_power\", string=\"mppt1\"} $Pv1_In_Power\n"
advertised_data+="$inverter_name{dc=\"pv_power\", string=\"mppt2\"} $Pv2_In_Power\n"
advertised_data+="$inverter_name{dc=\"pv_current\", string=\"mppt1\"} $Pv1_Current\n"
advertised_data+="$inverter_name{dc=\"pv_current\", string=\"mppt2\"} $Pv2_Current\n"

# Battery data
advertised_data+="$inverter_name{batt=\"batt_temp\"} $Battery_Temperature\n"
advertised_data+="$inverter_name{batt=\"batt_soc\"} $Battery_Soc\n"

advertised_data+="$inverter_name{batt=\"voltage\"} $Battery_Voltage\n"
advertised_data+="$inverter_name{batt=\"out_power\"} $Battery_Out_Power\n"
advertised_data+="$inverter_name{batt=\"out_current\"} $Battery_Out_Current\n"

advertised_data+="$inverter_name{batt=\"in_tatal_energy\"} $Battery_Charge_Total\n"
advertised_data+="$inverter_name{batt=\"out_total_energy\"} $Battery_Discharge_Total\n"



printf "$advertised_data"
