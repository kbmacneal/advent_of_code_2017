public static string PartOneAndTwo (string input) {
	var letters = new List<char> ();
	var steps = 1;
	var lines = input.Lines ().ToList ();

	var direction = Direction.Down;
	var position = new Point (input.IndexOf ('|'), 0);

	while (true) {
		position = GetNextPoint (position, direction);
		steps++;
		var nextChar = lines[position.Y][position.X];

		if (nextChar == ' ') {
			steps--;
			return steps.ToString () + Environment.NewLine + string.Join (string.Empty, letters);
		}

		if (nextChar == '|' || nextChar == '-') {
			continue;
		}

		if (nextChar >= 'A' && nextChar <= 'Z') {
			letters.Add (nextChar);
			continue;
		}

		if (nextChar == '+') {
			direction = GetNextDirection (position, direction, lines);
			continue;
		}

		throw new Exception ();
	}

	throw new Exception ();
}

private static Direction GetNextDirection (Point pos, Direction direction, List<string> lines) {
	if (direction == Direction.Up || direction == Direction.Down) {
		if (lines[pos.Y][pos.X - 1] == '-') {
			return Direction.Left;
		}

		if (lines[pos.Y][pos.X + 1] == '-') {
			return Direction.Right;
		}

		throw new Exception ();
	}

	if (direction == Direction.Left || direction == Direction.Right) {
		if (lines[pos.Y - 1][pos.X] == '|') {
			return Direction.Up;
		}

		if (lines[pos.Y + 1][pos.X] == '|') {
			return Direction.Down;
		}

		throw new Exception ();
	}

	throw new Exception ();
}

private static Point GetNextPoint (Point pos, Direction direction) {
	switch (direction) {
		case Direction.Down:
			return new Point (pos.X, pos.Y + 1);
		case Direction.Up:
			return new Point (pos.X, pos.Y - 1);
		case Direction.Left:
			return new Point (pos.X - 1, pos.Y);
		case Direction.Right:
			return new Point (pos.X + 1, pos.Y);
		default:
			throw new Exception ();
	}
}