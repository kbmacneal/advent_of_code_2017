using System;
using System.IO;
using System.Linq;
using System.Numerics;
using System.Text.RegularExpressions;

namespace verify_results {
    class Program {
        static void Main () {

            var input = File.ReadAllLines (@"c:\advent_of_code_2017\20\input.txt");
            var lst = input.Select (v => new Particle (v)).ToList ();

            // Manhattan distance for a Vector3
            Func<Vector3, Single> mhDist = v3 => Math.Abs (v3.X) + Math.Abs (v3.Y) + Math.Abs (v3.Z);

            // Part 1 - Find slowest particle, break ties using initial (manhattan) proximity to origin
            Console.WriteLine ($"Part 1: {lst.OrderBy(p => mhDist(p.Acc)).ThenBy(p => mhDist(p.Vel)).First().ID}");

            // Part 2 - Move particles and remove colliding ones until all particles are receding from the origin
            do {
                // move particles
                lst.ForEach (p => p.Move ());

                // remove colliding particles
                var sorted = lst.OrderBy (p => p.Pos.X).ToList ();
                for (int i = sorted.Count - 1; i > 0; i--) {
                    if (sorted[i].Collide (sorted[i - 1])) {
                        lst.Remove (sorted[i]);
                        lst.Remove (sorted[i - 1]);
                    }
                }
            } while (lst.Where (p => !p.Receding).Any ());

            Console.WriteLine ($"Part 2: {lst.Count}");
        }

        class Particle {

            static int gen;

            public int ID {
                get;
            }
            public Vector3 Pos {
                get;
                set;
            }
            public Vector3 Vel {
                get;
                set;
            }
            public Vector3 Acc {
                get;
                set;
            }
            public bool Receding {
                get;
                set;
            }

            public Particle (string vectors) {
                var matches = Regex.Matches (vectors, "-?\\d+"); // should match 9 numbers.
                var n = matches.Cast<Match> ().Select (m => Convert.ToSingle (m.Value)).ToList ();
                Pos = new Vector3 (n[0], n[1], n[2]);
                Vel = new Vector3 (n[3], n[4], n[5]);
                Acc = new Vector3 (n[6], n[7], n[8]);
                ID = gen++;
            }

            public void Move () {
                var pls = Pos.LengthSquared ();
                Vel += Acc;
                Pos += Vel;
                Receding = Pos.LengthSquared () > pls;
            }

            public bool Collide (Particle other) {
                return Pos.X == other.Pos.X && Pos.Y == other.Pos.Y && Pos.Z == other.Pos.Z;
            }
        }
    }
}