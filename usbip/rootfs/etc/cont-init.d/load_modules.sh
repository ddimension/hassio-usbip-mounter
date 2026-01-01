#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: USBIP Mounter
# Load client kernel module
# ==============================================================================

/sbin/rmmod vhci-hcd || true
/sbin/modprobe vhci-hcd
