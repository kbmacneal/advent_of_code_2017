using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace get_groups {
    class Program {

        private class cell {
            public bool Occupied { get; set; }
            public int Link_Num { get; set; }
        }

        static void Main (string[] args) {
            string input = "jzgqcdpd";

            object[, ] grid = new object[128, 128];
            for (int i = 0; i < 128; i++) {
                for (int j = 0; j < 128; j++) {
                    cell cell = new cell ();
                    cell.Occupied = false;
                    cell.Link_Num = 0;
                    grid[i, j] = cell;
                }
            }
            string binarystring = string.Empty;

            for (int i = 0; i < 128; i++) {
                string pass = input + i.ToString ();

                string densehash = get_knothash (pass);

                binarystring += String.Join (String.Empty, densehash.Select (
                    c => Convert.ToString (Convert.ToInt32 (c.ToString (), 16), 2).PadLeft (4, '0')
                ));
            }

        }

        public static string get_knothash (string input_string) {
            byte[] orig = System.Text.Encoding.ASCII.GetBytes (input_string);

            byte[] add = new byte[5];
            add[1] = Convert.ToByte (17);
            add[2] = Convert.ToByte (31);
            add[3] = Convert.ToByte (73);
            add[4] = Convert.ToByte (47);
            add[5] = Convert.ToByte (23);

            byte[] lengths = new byte[orig.Length + add.Length];

            int[] list = Enumerable.Range (0, 254).Select (x => x).ToArray ();

            int curpos = 0;
            int skipsize = 0;

            int[] blocksize = Enumerable.Range (0, 63).Select (x => x).ToArray ();

            List<int> indexestoreverse = new List<int> ();

            foreach (int num in blocksize) {
                foreach (int len in lengths) {
                    for (int i = 0; i < num; i++) {
                        int tmp = (curpos + 1) % (int) (list.Count ());
                        indexestoreverse.Add (tmp);
                    }
                    for (int i = 0; i < (indexestoreverse.Count () / 2); i++) {
                        int temp = list[indexestoreverse[i]];
                        list[indexestoreverse[i]] = list[indexestoreverse[0 - (i + 1)]];
                        list[indexestoreverse[0 - (i + 1)]] = temp;

                    }
                    curpos = (curpos + len + skipsize) % list.Count ();
                }
            }

            int[] roundsize = Enumerable.Range (0, 63).Select (x => x).ToArray ();

            List<int> ind_sixteen = Enumerable.Range (0, 16).Select (x => x).ToList ();

            List<List<int>> sixteens = new List<List<int>> ();

            foreach (List<int> sixteen in sixteens) {
                sixteen.AddRange (ind_sixteen);
            }

            List<string> densehash = new List<string> ();
            List<int> short_sixteen = Enumerable.Range (1, 15).Select (x => x).ToList ();

            foreach (List<int> set in sixteens) {
                int outbound = list[set[0]];
                foreach (int index in short_sixteen) {
                    outbound = outbound ^ list[index];
                }
            }
            List<string> return_densehash = new List<string> ();

            foreach (string item in densehash) {
                string obj = String.Format ("{0:x2}", item);
                return_densehash.Add (obj);
            }

            return System.String.Join ("", return_densehash.ToArray ());

            //return System.String.Join(return_densehash);

        }

    }
}