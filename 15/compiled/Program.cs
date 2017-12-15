using System;
using System.Collections;
using System.Collections.Generic;

namespace compiled {
    class Program {
        static void Main (string[] args) {
            if (args[0] == "2") {
                int part2 = compiled.Program.part2 ();
                Console.WriteLine (part2);
                return;
            }

            ulong factor_a = 16807;
            ulong factor_b = 48271;

            ulong gen_a_start = 722;
            ulong gen_b_start = 354;

            ulong shared_divisor = 2147483647;

            int count = 0;

            ulong last_a = gen_a_start;
            ulong last_b = gen_b_start;

            List<string> a_compare_list = new List<string> ();
            List<string> b_compare_list = new List<string> ();

            for (int i = 0; i < 40000000; i++) {

                last_a = calc_value (last_a, factor_a, shared_divisor);
                last_b = calc_value (last_b, factor_b, shared_divisor);

                string a_compare = convert_to_bin (last_a);
                string b_compare = convert_to_bin (last_b);

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

        public static int part2 () {
            ulong factor_a = 16807;
            ulong factor_b = 48271;

            ulong gen_a_start = 722;
            ulong gen_b_start = 354;

            ulong shared_divisor = 2147483647;

            int count = 0;

            ulong last_a = gen_a_start;
            ulong last_b = gen_b_start;

            List<string> a_compare_list = new List<string> ();
            List<string> b_compare_list = new List<string> ();

            for (int i = 0; i < 5000000; i++) {

                last_a = calc_value (last_a, factor_a, shared_divisor);
                last_b = calc_value (last_b, factor_b, shared_divisor);

                if (last_a % (ulong) 4 == 0) {
                    string a_compare = convert_to_bin (last_a);
                    a_compare_list.Add (a_compare);
                }

                if (last_b % (ulong) 8 == 0) {
                    string b_compare = convert_to_bin (last_b);
                    b_compare_list.Add (b_compare);
                }

            }

            for (int i = 0; i < a_compare_list.Count; i++) {
                if (a_compare_list[i] == b_compare_list[i]) {
                    count++;
                }

            }

            return count;
        }
    }
}