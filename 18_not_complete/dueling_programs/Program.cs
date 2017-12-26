using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace dueling_programs {
    class Program {
        static void Main (string[] args) {
            string[] instructions = File.ReadAllLines ("C:\\advent_of_code_2017\\18\\input_test_2.txt");

            var p0 = new Program (0, instructions);
            var p1 = new Program (1, instructions);

            p0.OtherQueue = p1.Queue;
            p1.OtherQueue = p0.Queue;

            do {
                p1.Run ();
                p0.Run ();
            } while (p1.Queue.Count != 0);

            Console.WriteLine (p1.SendCounter);
        }

        const string SND = "snd";
        const string SET = "set";
        const string ADD = "add";
        const string MUL = "mul";
        const string MOD = "mod";
        const string RCV = "rcv";
        const string JGZ = "jgz";

        private long curr = 0;
        private string[] instructions;
        private Dictionary<string, long> registers = new Dictionary<string, long> ();

        public long SendCounter {
            get;
            set;
        }

        public Queue<long> Queue {
            get;
        }

        public Queue<long> OtherQueue {
            get;
            set;
        }

        public string Name {
            get;
            set;
        }

        public Program (int pValue, string[] instructions) {
            this.registers.Add ("p", pValue);
            this.instructions = instructions;
            this.Queue = new Queue<long> ();
            this.Name = pValue.ToString ();
        }

        public void Run () {
            string instruction = string.Empty;

            while (true) {
                Console.WriteLine ("Program {0}: {1}", this.Name, instructions[curr]);

                var tokens = instructions[curr].Split (' ', StringSplitOptions.RemoveEmptyEntries);
                instruction = tokens[0];

                string register = tokens[1];

                if (!registers.ContainsKey (register)) {
                    long literal;
                    if (!long.TryParse (register, out literal)) {
                        literal = 0;
                    }

                    registers.Add (register, literal);
                }

                long value = 0;
                if (tokens.Length > 2) {
                    if (registers.ContainsKey (tokens[2])) {
                        value = registers[tokens[2]];
                    } else {
                        value = long.Parse (tokens[2]);
                    }
                }

                long offset = 1;
                switch (instruction) {
                    case SND:
                        this.OtherQueue.Enqueue (registers[register]);
                        this.SendCounter++;
                        break;
                    case SET:
                        registers[register] = value;
                        break;
                    case ADD:
                        registers[register] += value;
                        break;
                    case MUL:
                        registers[register] *= value;
                        break;
                    case MOD:
                        registers[register] %= value;
                        break;
                    case RCV:
                        if (this.Queue.Count > 0) {
                            registers[register] = this.Queue.Dequeue ();
                        } else {
                            foreach (var pair in registers) {
                                Console.WriteLine ("{0} = {1}", pair.Key, pair.Value);
                            }

                            return;
                        }
                        break;
                    case JGZ:
                        if (registers[register] > 0) {
                            offset = value;
                        }
                        break;
                }

                curr += offset;
            }
        }
    }
}