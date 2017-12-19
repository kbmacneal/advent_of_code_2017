string[] map = File.ReadAllLines(@"N:\input.txt");
var pos = (y: 0, x: map[0].IndexOf('|')); var lastPos = pos;
var dir = (1, 0);  string word = ""; var steps = 1;
while (map[pos.y][pos.x] == '-' || map[pos.y][pos.x] == '|')
{
    pos = applyMov(pos.y, pos.x);
    steps++;
    if (char.IsLetter(map[pos.y][pos.x]))
    {
        word = word + map[pos.y][pos.x];
        pos = applyMov(pos.y, pos.x);
        if (map[pos.y][pos.x] == ' ') { break; } else { steps++; }
    }
    else if (map[pos.y][pos.x] == '+') { pos = makeTurn(pos.y, pos.x); steps++; }
}
Console.WriteLine($"Collected: {word}, steps: {steps}"); Console.ReadKey();
//helpers
ValueTuple<int, int> applyMov(int y, int x) { lastPos = (y,x); return(y + dir.Item1, x + dir.Item2); }
ValueTuple <int,int> makeTurn(int y, int x)
{
    if (map[y + 1][x] != ' ' && !(y + 1, x).Equals(lastPos)) { dir = (1, 0); return (y + 1, x); }
    else if (map[y - 1][x] != ' ' && !(y - 1, x).Equals(lastPos)) { dir = (-1, 0); return (y - 1, x); }
    else if (map[y][x + 1] != ' ' && !(y, x + 1).Equals(lastPos)) { dir = (0, 1); return (y, x + 1); }
    else if (map[y][x - 1] != ' ' && !(y, x - 1).Equals(lastPos)) { dir = (0, -1); return (y, x - 1); }
    else { Console.WriteLine($"Maketurn is fucked! Panic!"); return (-99, - 99);  }
}