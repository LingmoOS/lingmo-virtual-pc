// This file is part of LINGMO VirtualPC. License: LGPLv2+
using Gtk;

[GtkTemplate (ui = "/org/lingmo/VirtualPC/ui/preferences/devices-page.ui")]
private class VirtualPC.DevicesPage : Hdy.PreferencesPage {
    private LibvirtMachine machine;

    [GtkChild]
    private unowned Gtk.ListBox listbox;
    [GtkChild]
    private unowned VirtualPC.SharedFoldersWidget shared_folders_widget;
    [GtkChild]
    private unowned VirtualPC.CdromRow cdrom_row;

    public void setup (LibvirtMachine machine) {
        this.machine = machine;

        setup_usb_devices_list ();
        cdrom_row.setup (machine);
        shared_folders_widget.setup (machine.config.uuid);
    }

    private void setup_usb_devices_list () {
        if (App.is_running_in_flatpak ()) {
            var msg = new Gtk.Label (_("The Flatpak version of LINGMO VirtualPC does not support USB redirection.")) {
                visible = true,
                margin = 10,
                wrap = true
            };
            msg.get_style_context ().add_class ("dim-label");
            listbox.add (msg);

            return;
        }

        if (!machine.is_running) {
            var msg = new Gtk.Label (_("Turn on your box to see the USB devices available for redirection.")) {
                visible = true,
                margin = 10
            };
            msg.get_style_context ().add_class ("dim-label");
            listbox.add (msg);

            return;
        }

        if (!(machine.display is SpiceDisplay) || App.is_running_in_flatpak ())
            return;

        var spice_display = machine.display as SpiceDisplay;
        var model = spice_display.get_usb_devices_model ();
        listbox.bind_model (model, add_usb_device_row);
    }

    private Gtk.Widget add_usb_device_row (GLib.Object item) {
        var device = item as VirtualPC.UsbDevice;

        return new VirtualPC.DeviceListRow (device);
    }
}
