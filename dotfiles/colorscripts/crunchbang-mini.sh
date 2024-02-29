#!/bin/sh

# ANSI ESCAPES
black="$(printf '\e[30m')"
redf="$(printf '\e[31m')"
greenf="$(printf '\e[32m')"
yellowf="$(printf '\e[33m')"
bluef="$(printf '\e[34m')"
purplef="$(printf '\e[35m')"
cyanf="$(printf '\e[36m')"
whitef="$(printf '\e[37m')"

blackfbright="$(printf '\e[90m')"
redfbright="$(printf '\e[91m')"
greenfbright="$(printf '\e[92m')"
yellowfbright="$(printf '\e[93m')"
bluefbright="$(printf '\e[94m')"
purplefbright="$(printf '\e[95m')"
cyanfbright="$(printf '\e[96m')"
whitefbright="$(printf '\e[97m')"

blackb="$(printf '\e[40m')"
redb="$(printf '\e[41m')"
greenb="$(printf '\e[42m')"
yellowb="$(printf '\e[43m')"
blueb="$(printf '\e[44m')"
purpleb="$(printf '\e[45m')"
cyanb="$(printf '\e[46m')"
whiteb="$(printf '\e[47m')"

boldon="$(printf '\e[1m')"
boldoff="$(printf '\e[22m')"
italicson="$(printf '\e[3m')"
italicsoff="$(printf '\e[23m')"
ulon="$(printf '\e[4m')"
uloff="$(printf '\e[24m')"
invon="$(printf '\e[7m')"
invoff="$(printf '\e[27m')"

reset="$(printf '\e[0m')"

#### CONTENT #####

# Crunchbang Mini
# echo -e " ${reset}${boldon}${redfbright}n${reset}${greenfbright}d${reset}${cyanfbright}o${reset}${yellowfbright}m${reset}${purplefbright}9${reset}${greenfbright}1${reset}${boldoff}"
# echo -e " ${reset}${redf}▄█▄█▄ ${reset}${boldon}${redfbright}█ ${reset}${greenf}▄█▄█▄ ${reset}${boldon}${greenfbright}█ ${reset}${yellowf}▄█▄█▄ ${reset}${boldon}${yellowfbright}█ ${reset}${bluef}▄█▄█▄ ${reset}${boldon}${bluefbright}█ ${reset}${purplef}▄█▄█▄ ${reset}${boldon}${purplefbright}█ ${reset}${cyanf}▄█▄█▄ ${reset}${boldon}${cyanfbright}█${reset}"
# echo -e " ${reset}${redf}▄█▄█▄ ${reset}${boldon}${redfbright}▀ ${reset}${greenf}▄█▄█▄ ${reset}${boldon}${greenfbright}▀ ${reset}${yellowf}▄█▄█▄ ${reset}${boldon}${yellowfbright}▀ ${reset}${bluef}▄█▄█▄ ${reset}${boldon}${bluefbright}▀ ${reset}${purplef}▄█▄█▄ ${reset}${boldon}${purplefbright}▀ ${reset}${cyanf}▄█▄█▄ ${reset}${boldon}${cyanfbright}▀${reset}"
# echo -e " ${reset}${redf} ▀ ▀  ${reset}${boldon}${redfbright}▀ ${reset}${greenf} ▀ ▀  ${reset}${boldon}${greenfbright}▀ ${reset}${yellowf} ▀ ▀  ${reset}${boldon}${yellowfbright}▀ ${reset}${bluef} ▀ ▀  ${reset}${boldon}${bluefbright}▀ ${reset}${purplef} ▀ ▀  ${reset}${boldon}${purplefbright}▀ ${reset}${cyanf} ▀ ▀  ${reset}${boldon}${cyanfbright}▀${reset}"

# Crunchbang Large
echo -e " ${reset}"
echo -e "   ${reset}${redf}  ██  ██   ${reset}${boldon}${redfbright}██    ${reset}${greenf}  ██  ██   ${reset}${boldon}${greenfbright}██    ${reset}${yellowf}  ██  ██   ${reset}${boldon}${yellowfbright}██    ${reset}${bluef}  ██  ██   ${reset}${boldon}${bluefbright}██    ${reset}${purplef}  ██  ██   ${reset}${boldon}${purplefbright}██    ${reset}${cyanf}  ██  ██   ${reset}${boldon}${cyanfbright}██"
echo -e "   ${reset}${redf}██████████ ${reset}${boldon}${redfbright}██    ${reset}${greenf}██████████ ${reset}${boldon}${greenfbright}██    ${reset}${yellowf}██████████ ${reset}${boldon}${yellowfbright}██    ${reset}${bluef}██████████ ${reset}${boldon}${bluefbright}██    ${reset}${purplef}██████████ ${reset}${boldon}${purplefbright}██    ${reset}${cyanf}██████████ ${reset}${boldon}${cyanfbright}██"
echo -e "   ${reset}${redf}  ██  ██   ${reset}${boldon}${redfbright}██    ${reset}${greenf}  ██  ██   ${reset}${boldon}${greenfbright}██    ${reset}${yellowf}  ██  ██   ${reset}${boldon}${yellowfbright}██    ${reset}${bluef}  ██  ██   ${reset}${boldon}${bluefbright}██    ${reset}${purplef}  ██  ██   ${reset}${boldon}${purplefbright}██    ${reset}${cyanf}  ██  ██   ${reset}${boldon}${cyanfbright}██"
echo -e "   ${reset}${redf}██████████       ${reset}${greenf}██████████       ${reset}${yellowf}██████████       ${reset}${bluef}██████████       ${reset}${purplef}██████████       ${reset}${cyanf}██████████   "
echo -e "   ${reset}${redf}  ██  ██   ${reset}${boldon}${redfbright}██    ${reset}${greenf}  ██  ██   ${reset}${boldon}${greenfbright}██    ${reset}${yellowf}  ██  ██   ${reset}${boldon}${yellowfbright}██    ${reset}${bluef}  ██  ██   ${reset}${boldon}${bluefbright}██    ${reset}${purplef}  ██  ██   ${reset}${boldon}${purplefbright}██    ${reset}${cyanf}  ██  ██   ${reset}${boldon}${cyanfbright}██ "
echo -e " ${reset}"
