using GLib;

namespace Pasgen {

    public class PasswordGenerator {
    
        private int length;
        
        private string allowed_characters;
    
        public PasswordGenerator (int len, bool alphabet, bool numeric, bool special) {
            length = len;
            
            allowed_characters = "";
            if (alphabet) {
                allowed_characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                allowed_characters += "abcdefghijklmnopqrstuvwxyz";
            }
            if (numeric) {
                allowed_characters += "1234567890";
            }
            if (special){
                allowed_characters += "@#$%&?!(){}+";
            }
        }
        
        public string generate_password () {
            if (length == 0) {
                return _("Enter a valid password length value");
            } else if (length < 0){
                return _("Password length cannot be less than zero");
            } else if (allowed_characters.length == 0) {
                return _("You need to activate at least one switch");
            }    

            var random_index = 0;     
            var password_builder = new StringBuilder ();
            
            for (var i = 0; i < length; i++) {
                random_index = Random.int_range(0, allowed_characters.length);
                password_builder.append_c (allowed_characters[random_index]);        
            }
            return password_builder.str;
        }
    }
}