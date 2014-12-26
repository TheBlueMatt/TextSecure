#!/bin/sh
PACKAGE=2

function replace() {
	tac "$1" | sed '0,/^import.*$/s//import org.thoughtcrime.securesms'"$PACKAGE"'.R;\n\n&/' | tac > "$1"2 && mv "$1"2 "$1";
}
function grep_file() {
	if [ -n "$(grep 'R\.' $1)" ]; then
		replace "$1"
	fi
}
for FILE in $(find . -name "*.java"); do
	grep_file $FILE
done

find . -type f -name *.java | xargs -n1 sed -i 's/import org.thoughtcrime.securesms.R;/import org.thoughtcrime.securesms'"$PACKAGE"'.R;/g'

head -n5 AndroidManifest.xml | sed 's/package="org.thoughtcrime.securesms/package="org.thoughtcrime.securesms'"$PACKAGE"'/g' > am-head
tail -n +6 AndroidManifest.xml >> am-head
mv am-head AndroidManifest.xml

sed -i 's/"app_name">TextSecure/"app_name">TextSecure S'"$PACKAGE"'/g' res/values/strings.xml

sed -i 's/textsecure-service/textsecure-service-staging/g' src/org/thoughtcrime/securesms/Release.java
