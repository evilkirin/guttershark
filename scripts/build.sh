#!/usr/bin/env bash
./scripts/gendocs.sh
RSWC=`which swc_link_report_remove.py`
ruby scripts/genlinkreport.rb
python ${RSWC} -l libs/report.xml -m "/Users/aaronsmith/Development/git/guttershark" -o libs/gsreport.xml
ruby scripts/genswc.rb
rm -rf libs/report.xml
rm -rf libs/gsreport.xml