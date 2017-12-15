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

                string a_compare = convert_to_bin (a_val);
                string b_compare = convert_to_bin (b_val);

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

        public static string convert_to_bin (UInt64 value) {

            string returner = Convert.ToString ((long) value, 2);

            int padding = 0;
            if (returner.Length < 16) {
                padding = 16 - (returner.Length);
                string pad = new string ('0', padding);
                returner = pad.ToString () + returner;
            }

            returner = returner.Substring ((returner.Length - 16), 16);

            return returner;

        }
    }
}