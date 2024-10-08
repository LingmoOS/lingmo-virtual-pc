// This file is part of LINGMO VirtualPC. License: LGPLv2+

using Gtk;

[GtkTemplate (ui = "/org/lingmo/VirtualPC/ui/icon-view-child.ui")]
private class VirtualPC.IconViewChild : Gtk.Box {
    public CollectionItem item { get; private set; }
    private Machine machine {
        get { return item as Machine; }
    }

    [GtkChild]
    public unowned VirtualPC.Thumbnail thumbnail;
    [GtkChild]
    private unowned Gtk.Label machine_name;
    [GtkChild]
    private unowned Gtk.Label machine_status;

    public IconViewChild (CollectionItem item) {
        this.item = item;

        update_thumbnail ();
        machine.notify["under-construction"].connect (update_thumbnail);
        machine.notify["is-stopped"].connect (update_thumbnail);
        machine.notify["pixbuf"].connect (update_thumbnail);

        machine.bind_property ("name", machine_name, "label", BindingFlags.SYNC_CREATE);
        machine.bind_property ("status", machine_status, "label", BindingFlags.SYNC_CREATE);
    }

    private void update_thumbnail () {
        thumbnail.update (machine);
    }
}
