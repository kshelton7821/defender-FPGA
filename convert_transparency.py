from PIL import Image;
import sys;

if(len(sys.argv) != 2):
	print("USAGE: convert_transparency IMAGE");
	sys.exit(0);

i = Image.open(sys.argv[1], "r");
w, h = i.size;

data = list(i.getdata());

get_bin = lambda x, n: str(format(x, 'b').zfill(n));
converted = [];
for y in range(h):
	for x in range(w):
		converted.append(get_bin(data[w*y+x][0], 8)[0:4] + get_bin(data[w*y+x][1], 8)[0:4] + get_bin(data[w*y+x][2], 8)[0:4]);

with open("out.txt", "w") as out:
	converted = converted[::-1];
	out.write(str((w*h)-1) + " downto 0\n\n");
	out.write("\"" + "".join(["0" if x == "000000000000" else "1" for x in converted]) + "\";");