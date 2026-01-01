#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: USBIP Mounter
# Configures USBIP devices
# ==============================================================================

# Configure mount script for all usbip devices
declare server_address
declare bus_id
declare script_directory
declare mount_script

script_directory="/usr/local/bin"
mount_script="/usr/local/bin/mount_devices"

bashio::log.info  "Stop script"
msg="$(/usr/bin/usbip port)"
bashio::log.info  "msg"

 
exit

for device in $(bashio::config 'devices|keys'); do
    server_address=$(bashio::config "devices[${device}].server_address")
    bus_id=$(bashio::config "devices[${device}].bus_id")
    bashio::log.info "Detaching device from server ${server_address} on bus ${bus_id}"
    echo "/usr/sbin/usbip --debug dettach -r ${server_address} -b ${bus_id}" >> "${mount_script}"
done
