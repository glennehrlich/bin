#!/usr/bin/env bash

cd ~/bc2/usr/bin

# Context parameters.
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_bypass     --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_dataflag   --value 0
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_0 --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_1 --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_2 --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_sequence_3 --value 1
./set_parameter --asset SV030 --parameter bc2_ccsds_tc_frame_vcid       --value 0

# Ground parameters.
./set_parameter --asset SV030 --parameter ALTAIR_TC_PKT_LENGTH --value 0
./set_parameter --asset SV030 --parameter ALTAIR_TC_PKT_PECW   --value 0
./set_parameter --asset SV030 --parameter ALTAIR_TC_PKT_SYNC   --value 46092
./set_parameter --asset SV030 --parameter ALTAIR_TC_PKT_TIME   --value 0


