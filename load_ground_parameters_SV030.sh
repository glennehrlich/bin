#!/usr/bin/env bash

cd ~/bc2/usr/bin

./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_bypass     --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_dataflag   --value 0
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_vcid       --value 0
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_0 --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_1 --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_2 --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_3 --value 1
