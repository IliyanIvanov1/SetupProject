TAGS="TODO:|FIXME:"
echo "searching ${SRCROOT} for ${TAGS}"
find "${SRCROOT}" -path "${SRCROOT}/Pods" -prune -o \( -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($TAGS).*\$" | perl -p -e "s/($TAGS)/ warning: \$1/"

