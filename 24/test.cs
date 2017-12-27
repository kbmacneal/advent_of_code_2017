var lines = (await AoC.GetLinesWeb()).ToList();

IImmutableList<(int,int)> edges = ImmutableList<(int,int)>.Empty;

foreach (var line in lines)
{
    var nums = line.Split('/');
    edges = edges.Add((int.Parse(nums[0]), int.Parse(nums[1])));
}

int Search(IImmutableList<(int,int)> e, int cur = 0, int strength = 0)
{
    return e.Where(x => x.Item1 == cur || x.Item2 == cur).Select(x => Search(e.Remove(x), x.Item1 == cur ? x.Item2 : x.Item1, strength + x.Item1 + x.Item2)).Concat(Enumerable.Repeat(strength,1)).Max();
}

(int,int) Search2(IImmutableList<(int, int)> e, int cur = 0, int strength = 0, int length = 0)
{
    return e.Where(x => x.Item1 == cur || x.Item2 == cur).Select(x => Search2(e.Remove(x), x.Item1 == cur ? x.Item2 : x.Item1, strength + x.Item1 + x.Item2, length + 1)).Concat(Enumerable.Repeat((strength,length),1)).OrderByDescending(x => x.Item2).ThenByDescending(x => x.Item1).First();
}

Search(edges).Dump("part 1");
Search2(edges).Item1.Dump("part 2");


void Main() {
    var components = new List<(int, int)>();
    GetDay(24).Select(ln => ln.Split('/')).ForEach(sa => components.Add((Convert.ToInt32(sa[0]), Convert.ToInt32(sa[1]))));
    Build((0, 0), 0, components, false).Item1.Dump("Part 1");
    Build((0, 0), 0, components, true ).Item1.Dump("Part 2");
}

(int, int) Build((int, int) StrLen, int port, List<(int, int)> available, bool useLength) {
    var usable = available.Where(x => x.Item1 == port || x.Item2 == port).ToList();
    if (!usable.Any()) return StrLen;
    var bridges = new List<(int, int)>();
    foreach ((int, int) comp in usable) {
        var str = StrLen.Item1 + comp.Item1 + comp.Item2;
        var len = StrLen.Item2 + 1;
        var nextPort = port == comp.Item1 ? comp.Item2 : comp.Item1;
        var remaining = available.ToList(); remaining.Remove(comp);
        bridges.Add(Build((str, len), nextPort, remaining, useLength));
    }
    return bridges.OrderBy(x => useLength ? x.Item2 : 0).ThenBy(x => x.Item1).Last();
}