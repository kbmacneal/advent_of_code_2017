l = []
while True:
	try:
		s = raw_input()
		l.append(s)
	except EOFError:
		break

lx, ly = 0, 0
sx, sy = 0, 0
while l[sx][sy] == ' ':
	sy += 1
dx, dy = 1, 0

ddx = [1, -1, 0, 0]
ddy = [0, 0, -1, 1]
ans = 0
ret = ""
while True:
	ans += 1
	if l[sx][sy].isupper():
		ret += l[sx][sy]
	nx, ny = sx + dx, sy + dy
	if nx >= 0 and nx < len(l) and ny >= 0 and ny < len(l[nx]) and l[nx][ny] != ' ':
		lx, ly, sx, sy = sx, sy, nx, ny
	else:
		k = 0
		good = False
		while k < len(ddx):
			dx, dy = ddx[k], ddy[k]
			nx, ny = sx + dx, sy + dy
			if nx == lx and ny == ly:
				k += 1
				continue
			if nx >= 0 and nx < len(l) and ny >= 0 and ny < len(l[nx]) and l[nx][ny] != ' ':
				lx, ly, sx, sy = sx, sy, nx, ny
				good = True
				break
			k += 1
		if not good:
			print "trail ends at {} {} with string {} and length {}".format(sx, sy, ret, ans)
			break