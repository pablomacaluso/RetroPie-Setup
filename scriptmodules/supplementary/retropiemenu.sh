rp_module_id="retropiemenu"
rp_module_desc="RetroPie configuration menu for EmulationStation"
rp_module_menus="2+ 3+"
rp_module_flags="nobin"

function depends_retropiemenu() {
    getDepends mc
}

function configure_retropiemenu()
{
    local rpdir="$home/RetroPie/retropiemenu"
    mkdir -p "$rpdir"

    files=(
        'raspiconfig.rp'
        'rpsetup.rp'
        'retroarchjoyconfig.rp'
        'audiosettings.rp'
        'dispmanx.rp'
        'retronetplay.rp'
        'splashscreen.rp'
        'filemanager.rp'
        'showip.rp'
    )

    for file in "${files[@]}"; do
        touch "$rpdir/$file"
    done
    chown -R pi:pi "$rpdir"

    # add some information
    mkdir -p "$home/.emulationstation/gamelists/retropie/"
    cat > "$home/.emulationstation/gamelists/retropie/gamelist.xml" <<_EOF_
<?xml version="1.0"?>
<gameList>
    <game>
        <path>$rpdir/raspiconfig.rp</path>
        <name>Raspberry Pi configuration tool raspi-config</name>
    </game>
    <game>
        <path>$rpdir/rpsetup.rp</path>
        <name>RetroPie-Setup</name>
    </game>
    <game>
        <path>$rpdir/filemanager.rp</path>
        <name>File Manager</name>
    </game>
    <game>
        <path>$rpdir/retroarchjoyconfig.rp</path>
        <name>Register RetroArch controller</name>
    </game>
    <game>
        <path>$rpdir/audiosettings.rp</path>
        <name>Configure audio settings</name>
    </game>
    <game>
        <path>$rpdir/dispmanx.rp</path>
        <name>Enable/Disable dispmanx SDL driver for SDL1.x emulators</name>
    </game>
    <game>
        <path>$rpdir/retronetplay.rp</path>
        <name>Configure RetroArch netplay</name>
    </game>
    <game>
        <path>$rpdir/splashscreen.rp</path>
        <name>Configure Splashscreen</name>
    </game>
    <game>
        <path>$rpdir/showip.rp</path>
        <name>Show IP address</name>
    </game>
</gameList>
_EOF_
    setESSystem "RetroPie" "retropie" "~/RetroPie/retropiemenu" ".rp .sh" "sudo $scriptdir/retropie_packages.sh retropiemenu launch %ROM%" "" "retropie"
}

function launch_retropiemenu() {
    clear
    local command="${md_params[0]}"
    local basename="${command##*/}"
    case $basename in
        rpsetup.rp)
            "$scriptdir/retropie_setup.sh"
            ;;
        raspiconfig.rp)
            raspi-config
            ;;
        filemanager.rp)
            mc
            ;;
        showip.rp)
            ip addr show
            sleep 5
            ;;
        *.rp)
            local no_ext=${basename%.rp}
            rp_callModule $no_ext
            ;;
        *.sh)
            cd "$home/RetroPie/retropiemenu"
            bash "$command"
            ;;
    esac
    clear
}
