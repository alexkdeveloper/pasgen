using Gtk;

namespace Pasgen {

    public class MainWindow : Gtk.ApplicationWindow {

        Box box;
        Label password_text;
        Entry password_length_entry;
        Switch switch_alphabet;
        Switch switch_numeric;
        Switch switch_special;
   


        public MainWindow(Gtk.Application application) {
            GLib.Object(application: application,
                         title: "Pasgen",
                         window_position: WindowPosition.CENTER,
                         resizable: true,
                         height_request: 350,
                         width_request: 400,
                         border_width: 10);
        }

      construct {
        var css_provider = new CssProvider();
        try {
                 css_provider.load_from_data(".password {font-size: 18px}");
                 StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
             } catch (Error e) {
                 error ("Cannot load CSS stylesheet: %s", e.message);
         }
          get_style_context().add_class("rounded");
          HeaderBar headerbar = new HeaderBar();
          headerbar.get_style_context().add_class("flat");
          headerbar.show_close_button = true;
          set_titlebar(headerbar);
          box = new Box (Orientation.VERTICAL, 1);  
            create_switches ();          
            create_entry_and_button ();  
            create_password_text (); 
            add (box);       
        }

        private void create_password_text () {
            password_text = new Label (_("Your password will be here"));
            password_text.selectable = true;
            password_text.margin = 12;
            password_text.wrap = true;
            password_text.wrap_mode = Pango.WrapMode.CHAR;
            password_text.get_style_context().add_class("password");
            box.add (password_text);
        }
       
        private void create_switches () {
            create_switch_alphabet ();
            create_switch_numeric ();
            create_switch_special ();    
        }
        
        private void create_switch_alphabet () {
            var switch_box = new Box (Orientation.HORIZONTAL, 0);
            switch_box.halign = Align.CENTER;
            var switch_label = new Label(_("Alphabet characters"));
            switch_alphabet = new Switch ();    
            switch_alphabet.margin = 12;
            switch_alphabet.active = true;
            
            switch_box.add (switch_label);
            switch_box.add (switch_alphabet);
            box.add (switch_box);
        }
        
        private void create_switch_numeric () {
            var switch_box = new Box (Orientation.HORIZONTAL, 0);
            switch_box.halign = Align.CENTER;
            var switch_label = new Label(_("Numeric characters"));
            switch_numeric = new Switch ();
            switch_numeric.margin = 12;
            switch_numeric.active = true;
            
            switch_box.add (switch_label);
            switch_box.add (switch_numeric);
            box.add (switch_box);
        }
        
        private void create_switch_special() {
            var switch_box = new Box (Orientation.HORIZONTAL, 0);
            switch_box.halign = Align.CENTER;
            var switch_label = new Label(_("Special characters"));
            switch_special = new Switch ();
            switch_special.margin = 12;
            
            switch_box.add (switch_label);
            switch_box.add (switch_special);
            box.add (switch_box);
        }
        
        private void create_entry_and_button () {
            var hbox = new Box(Orientation.HORIZONTAL, 12);
            hbox.halign = Align.CENTER;
            hbox.margin = 12;
            var password_length_label = new Label(_("Password length:"));
            password_length_label.xalign = 0;
            password_length_entry = new Entry();
            password_length_entry.set_text ("18");
            
            var vbox = new Box(Orientation.VERTICAL,5);
            vbox.add(password_length_label);
            vbox.add(password_length_entry);
            var button_generate_password = new Button.with_label (_("GENERATE\nPASSWORD"));
            button_generate_password.get_style_context().add_class("suggested-action");
            button_generate_password.clicked.connect (() => {
                generate_password();
            });       
            
            hbox.add(vbox);
            hbox.add(button_generate_password);
            box.add (hbox);
        }

   private void generate_password () {
          if (password_length_entry.get_text().strip().length == 0){
              password_text.label = _("The input field cannot be empty");
              password_length_entry.grab_focus();
              return;
          }
            var length = int.parse(password_length_entry.get_text ());
            var allow_alpha = switch_alphabet.active;
            var allow_numeric = switch_numeric.active;
            var allow_special = switch_special.active;
            var password_generator = new PasswordGenerator(length, allow_alpha,
                                                           allow_numeric, allow_special);
            var generated_password = password_generator.generate_password ();
            password_text.label = generated_password;
        }
    }
}

