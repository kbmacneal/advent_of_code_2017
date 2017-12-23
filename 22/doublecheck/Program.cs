using System;
using System.Collections.Generic;
using System.IO;

public class Coordinate : IEquatable<Coordinate>
{
    public Coordinate(long x, long y)
    {
        this.X = x;
        this.Y = y;
    }

    public long X { get; private set; }
    public long Y { get; private set; }

    public override string ToString()
    {
        return string.Format("X={0}, Y={1}", this.X, this.Y);
    }

    public bool Equals(Coordinate other)
    {
        return this.X == other.X && this.Y == other.Y;
    }

    public override bool Equals(object obj)
    {
        var other = obj as Coordinate;
        return this.X == other.X && this.Y == other.Y;
    }

    public override int GetHashCode()
    {
        long result = this.X;
        result = (result * 397) ^ this.Y;
        return (int)result;
    }
}

public static class Program
{
    const int UP = 0;
    const int RIGHT = 1;
    const int DOWN = 2;
    const int LEFT = 3;

    const int Clean = 0;
    const int Weakened = 1;
    const int Infected = 2;
    const int Flagged = 3;

    const int TURNLEFT = -1;
    const int TURNRIGHT = 1;

    static void Main(string[] args)
    {
        foreach(var fileName in new [] { "input.txt", "smallInput.txt" })
        {
            RunSolution(Part1, "Part 1", fileName);
            RunSolution(Part2V1, "Part 2 V1", fileName);
            RunSolution(Part2V2, "Part 2 V2", fileName);
        }
    }

    public static int Part2V2(HashSet<Coordinate> infected, Coordinate curr)
    {
        Dictionary<Coordinate, int> states = new Dictionary<Coordinate, int>();
        foreach(var i in infected)
        {
            states.Add(i, Infected);
        }

        int dir = UP;
        int infections = 0;
        for (int i = 0; i < 10000000; i++)
        {
            if (!states.ContainsKey(curr))
            {
                states.Add(curr, Clean);
            }

            int state = states[curr];
            switch(state)
            {
                case Clean:
                    dir = dir.Turn(TURNLEFT);
                    break;
                case Flagged:
                    dir = dir.Turn(TURNRIGHT);
                    dir = dir.Turn(TURNRIGHT);
                    break;
                case Infected:
                    dir = dir.Turn(TURNRIGHT);
                    break;
                case Weakened:
                    infections++;
                    break;
            }

            states[curr] = (state + 1) % 4;
            curr = curr.Move(dir);
        }

        return infections;
    }

    public static int Part2V1(HashSet<Coordinate> infected, Coordinate curr)
    {
        HashSet<Coordinate> weakened = new HashSet<Coordinate>();
        HashSet<Coordinate> flagged = new HashSet<Coordinate>();

        int dir = UP;
        int infections = 0;
        for (int i = 0; i < 10000000; i++)
        {
            if (flagged.Contains(curr))
            {
                flagged.Remove(curr);
                dir = dir.Turn(TURNRIGHT);
                dir = dir.Turn(TURNRIGHT);
            }
            else if (infected.Contains(curr))
            {
                dir = dir.Turn(TURNRIGHT);
                infected.Remove(curr);
                flagged.Add(curr);
            }
            else if (weakened.Contains(curr))
            {
                weakened.Remove(curr);
                infected.Add(curr);
                infections++;
            }
            else // Clean
            {
                dir = dir.Turn(TURNLEFT);
                weakened.Add(curr);
            }

            curr = curr.Move(dir);
        }

        return infections;
    }

    public static int Part1(HashSet<Coordinate> infected, Coordinate curr)
    {
        int dir = UP;
        int infections = 0;
        for (int i = 0; i < 10000; i++)
        {
            if (infected.Contains(curr))
            {
                dir = dir.Turn(TURNRIGHT);
                infected.Remove(curr);
            }
            else
            {
                dir = dir.Turn(TURNLEFT);
                infected.Add(curr);
                infections++;
            }

            curr = curr.Move(dir);
        }

        return infections;
    }

    public static Coordinate Move(this Coordinate curr, int dir)
    {
        switch(dir)
        {
            case UP:
                return new Coordinate(curr.X, curr.Y - 1);
            case DOWN:
                return new Coordinate(curr.X, curr.Y + 1);
            case RIGHT:
                return new Coordinate(curr.X + 1, curr.Y);
            case LEFT:
                return new Coordinate(curr.X - 1, curr.Y);
            default:
                throw new Exception("Unexpected direction value " + dir);
        }
    }

    public static int Turn(this int currDir, int direction)
    {
        int newDir = (currDir + direction) % 4;

        if (newDir < 0)
        {
            return 4 + newDir;
        }

        return newDir;
    }

    public static void RunSolution(Func<HashSet<Coordinate>, Coordinate, int> solve, string name, string fileName)
    {
        var lines = File.ReadAllLines(fileName);
        Coordinate center = new Coordinate(x: lines[0].Length / 2, y: lines.Length / 2);

        var infected = GetInitialState(lines);

        var start = DateTime.Now;
        int answer = solve(infected, center);
        Console.WriteLine("{1} took {0} to find the answer {3} on {2}", DateTime.Now - start, name, fileName, answer);
    }

    public static HashSet<Coordinate> GetInitialState(string[] lines)
    {
        HashSet<Coordinate> infected = new HashSet<Coordinate>();

        for (int i = 0; i < lines.Length; i++)
        {
            for (int j = 0; j < lines[0].Length; j++)
            {
                if (lines[i][j] == '#')
                {
                    infected.Add(new Coordinate(x: j, y: i));
                }
            }
        }

        return infected;
    }
}