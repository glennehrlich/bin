#!/usr/bin/env bash

RPM=$1

rpm2cpio $RPM | cpio -idmv
