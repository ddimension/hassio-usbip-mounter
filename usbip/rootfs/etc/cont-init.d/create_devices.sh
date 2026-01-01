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
umount_script="/usr/local/bin/umount_devices"

if ! bashio::fs.directory_exists "${script_directory}"; then
  bashio::log.info  "Creating script directory"
  mkdir -p "${script_directory}" || bashio::exit.nok "Could not create bin folder"
fi

if bashio::fs.file_exists "${mount_script}"; then
  rm "${mount_script}"
fi

if bashio::fs.file_exists "${umount_script}"; then
  rm "${umount_script}"
fi

if ! bashio::fs.file_exists "${mount_script}"; then
  touch ${mount_script}
  chmod +x ${mount_script}
  echo '#!/command/with-contenv bashio' > "${mount_script}"
  echo 'set -x' >> "${mount_script}"
  echo 'mount -o remount -t sysfs sysfs /sys' >> "${mount_script}"
  for device in $(bashio::config 'devices|keys'); do
    server_address=$(bashio::config "devices[${device}].server_address")
    bus_id=$(bashio::config "devices[${device}].bus_id")
    bashio::log.info "Adding device from server ${server_address} on bus ${bus_id}"
    echo "/usr/sbin/usbip --debug attach -r ${server_address} -b ${bus_id}" >> "${mount_script}"
  echo 'lsusb' >> "${mount_script}"
  done
fi

if ! bashio::fs.file_exists "${umount_script}"; then
  touch ${umount_script}
  chmod +x ${umount_script}
  echo '#!/command/with-contenv bashio' > "${umount_script}"
  echo 'set -x' >> "${umount_script}"
  echo 'mount -o remount -t sysfs sysfs /sys' >> "${umount_script}"
  echo '/sbin/rmmod vhci-hcd || true' >> "${umount_script}"
  echo '/sbin/lsmod || true' >> "${umount_script}"
  echo 'mount || true' >> "${umount_script}"
  #echo 'ls / /dev || true' >> "${umount_script}"
  #echo 'find /sys |grep vhci || true' >> "${umount_script}"
  #echo '/usr/sbin/usbip port' >> "${umount_script}"
  echo 'lsusb' >> "${umount_script}"
fi
