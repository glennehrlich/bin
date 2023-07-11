#!/usr/bin/env bash

cd ~/bc2/usr/bin

# Context parameters (none).

# Ground parameters.
./set_parameter --asset O3b_F01 --parameter CR_Address         --value '"Universal"'
./set_parameter --asset O3b_F01 --parameter Command_All_SCEs   --value '"Single_SCE"'
./set_parameter --asset O3b_F01 --parameter Dest_Address       --value '"SCE_1"'
./set_parameter --asset O3b_F01 --parameter Hold_Bit           --value '"Execute_Immediately"'
./set_parameter --asset O3b_F01 --parameter Polycode           --value 0
./set_parameter --asset O3b_F01 --parameter Port_ID            --value 0
./set_parameter --asset O3b_F01 --parameter SCE_SW_Cmd_Type    --value '"Single_Command"'
./set_parameter --asset O3b_F01 --parameter Spacecraft_Address --value 55
./set_parameter --asset O3b_F01 --parameter Uplink_Address     --value '"SCE_1"'
