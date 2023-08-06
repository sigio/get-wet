#!/bin/bash
set -euo pipefail

# Wet-ID        First-Date      Name
# BWBR0002656   2002-01-01      Burgerlijk wetboek 1 (Personen en familierecht)
# BWBR0003045   2002-04-23      Burgerlijk wetboek 2 (Rechtspersonen)
# BWBR0005291   2002-01-01      Burgerlijk wetboek 3 (Vermogensrecht)
# BWBR0002761   2002-01-01      Burgerlijk wetboek 4 (Erfrecht)
# BWBR0005288   2002-01-01      Burgerlijk wetboek 5 (Zakelijke rechten)
# BWBR0005289   2002-04-12      Burgerlijk wetboek 6 (Verbintenisrecht)
# BWBR0005290   2002-04-01      Burgerlijk wetboek 7 (Bijzondere overeenkomsten)
# BWBR0006000   2002-01-01      Burgerlijk wetboek 7A (Bijzondere overeenkomsten; vervolg)
# BWBR0005034   2002-01-01      Burgerlijk wetboek 8 (Verkeersmiddelen)
# BWBR0030068   2012-01-01      Burgerlijk wetboek 10 (Internationaal privaatrecht)

# URL="wget https://wetten.overheid.nl/${WET}/YYYY-MM-DD/0/txt"
export WET="$1"
export BASEURL="https://wetten.overheid.nl/${WET}"
export DATUM="$2"

while true; do
    curl "https://wetten.overheid.nl/${WET}/${DATUM}/0/txt" -o "${WET}.txt"

    ENDDATE=`grep "^Geldend van" ${WET}.txt  | head -1 | awk '{print $5}' | sed -E 's/([0-9]+)-([0-9]+)-([0-9]+)/\3-\2-\1/' | tr -d `

    if [ "$ENDDATE" = "heden" ]; then
        NEWDATE=heden
    else
        NEWDATE=`date -d "${ENDDATE} +1 day" +%Y-%m-%d`
    fi

    echo "Enddate: '$ENDDATE'"
    echo "NewDate: '$NEWDATE'"

    git add ${WET}.txt
    GIT_COMMITTER_DATE="`date -d ${DATUM}`" git commit --date "`date -d ${DATUM}`" -m "${WET}-geldend_van_${DATUM}_tot_${NEWDATE}"
    mv "${WET}.txt" "${WET}.${DATUM}-${ENDDATE}.txt"

    if [ "$ENDDATE" = "heden" ]; then
        echo "Last version..."
        exit 1;
    fi

    export DATUM=${NEWDATE}
    echo "New fetch date: '$DATUM'"
done
