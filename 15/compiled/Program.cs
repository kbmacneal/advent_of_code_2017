using System;
using System.Collections;
using System.Collections.Generic;

namespace compiled {
    class Program {
        static void Main (string[] args) {
            if (args.Length > 0) {
                if (args[0] == "2") {
                    int part2 = compiled.Program.part2 ();
                    Console.WriteLine (part2);
                    return;
                }
            }

            long factor_a = 16807;
            long factor_b = 48271;

            long gen_a_start = 722;
            long gen_b_start = 354;

            long shared_divisor = 2147483647;

            int count = 0;

            long last_a = gen_a_start;
            long last_b = gen_b_start;

            long bitmask = 65535;

            for (int i = 0; i < 40000000; i++) {

                long temp = 0;

                temp = calc_value (last_a, factor_a, shared_divisor);
                last_a = temp;
                temp = calc_value (last_b, factor_b, shared_divisor);
                last_b = temp;

                if ((last_a & bitmask) == (last_b & bitmask)) {
                    count++;
                }

            }

            Console.WriteLine (count);

        }

        public static long calc_value (long value, long multiple, long divisor) {
            long val = Convert.ToInt64 ((value * multiple) % divisor);

            return val;
        }

        public static int part2 () {
            long factor_a = 16807;
            long factor_b = 48271;

            long gen_a_start = 722;
            long gen_b_start = 354;

            long shared_divisor = 2147483647;

            int count = 0;

            long last_a = gen_a_start;
            long last_b = gen_b_start;

            long bitmask = 65535;

            List<long> list_a = new List<long> ();
            List<long> list_b = new List<long> ();

            for (int i = 0; i < 5000000; i++) {

                long temp = 0;

                temp = calc_value (last_a, factor_a, shared_divisor);
                last_a = temp;
                temp = calc_value (last_b, factor_b, shared_divisor);
                last_b = temp;

                if (last_a % 4 == 0) {
                    list_a.Add (last_a);
                }

                if (last_b % 8 == 0) {
                    list_b.Add (last_b);
                }

                for (int j = 0; j < list_a.Count && j < list_b.Count; j++) {
                    if ((list_a[j] & bitmask) == (list_b[j] & bitmask)) {
                        count++;
                    }
                }

            }

            return count;
        }
    }
}