using System;
using System.Collections;
using System.Collections.Generic;

namespace compiled {
    class Program {
        static void Main (string[] args) {
            ulong factor_a = 16807;
            ulong factor_b = 48271;

            ulong gen_a_start = 722;
            ulong gen_b_start = 354;

            ulong shared_divisor = 2147483647;

            Hashtable hex = new Hashtable ();

            hex["0"] = "0000";
            hex["1"] = "0001";
            hex["2"] = "0010";
            hex["3"] = "0011";
            hex["4"] = "0100";
            hex["5"] = "0101";
            hex["6"] = "0110";
            hex["7"] = "0111";
            hex["8"] = "1000";
            hex["9"] = "1001";
            hex["a"] = "1010";
            hex["b"] = "1011";
            hex["c"] = "1100";
            hex["d"] = "1101";
            hex["e"] = "1110";
            hex["f"] = "1111";

            int count = 0;
            List<UInt64> a_val_list = new List<ulong> ();
            List<UInt64> b_val_list = new List<ulong> ();
            a_val_list.Add (Convert.ToUInt64 (gen_a_start));
            b_val_list.Add (Convert.ToUInt64 (gen_b_start));
            List<string> a_compare_list = new List<string> ();
            List<string> b_compare_list = new List<string> ();

            for (int i = 0; i < 40000000; i++) {

                int a_val_count = a_val_list.Count - 1;
                int b_val_count = b_val_list.Count - 1;

                ulong a_val = calc_value (a_val_list[a_val_count], factor_a, shared_divisor);

                ulong b_val = calc_value (b_val_list[b_val_count], factor_b, shared_divisor);

                a_val_list.Add (a_val);
                b_val_list.Add (b_val);

                string a_compare = convert_to_bin (a_val, hex);
                string b_compare = convert_to_bin (b_val, hex);

                a_compare_list.Add (a_compare);
                b_compare_list.Add (b_compare);

            }

            for (int i = 0; i < a_compare_list.Count; i++) {
                if (a_compare_list[i] == b_compare_list[i]) {
                    count++;
                }

            }

            Console.WriteLine (count);

        }

        public static UInt64 calc_value (ulong value, ulong multiple, ulong divisor) {
            System.UInt64 val = Convert.ToUInt64 ((value * multiple) % divisor);

            return val;
        }

        public static string convert_to_bin (UInt64 value, Hashtable hex_list) {
            List<int> binary_str_array = new List<int> ();
            string returner = string.Empty;

            foreach (char item in value.ToString ().ToCharArray ()) {
                string hexcode = hex_list[item.ToString ()].ToString ();

                returner += Convert.ToInt32 (hexcode);
            }

            returner = returner.Substring ((returner.Length - 16), 16);
            return returner;
        }
    }
}