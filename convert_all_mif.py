from PIL import Image;
import sys, os;

if(len(sys.argv) != 2):
	print("USAGE: convert_all_mif IMAGE_FOLDER");
	sys.exit(0);
	
offset = 0;

with open("init.mif", "w") as out:

	out.write("DEPTH = 65536;\n");
	out.write("WIDTH = 12;\n");
	out.write("ADDRESS_RADIX = BIN;\n");
	out.write("DATA_RADIX = BIN;\n");
	out.write("CONTENT\n");
	out.write("BEGIN\n");

	for f in os.listdir(sys.argv[1]):
	
		i = Image.open(sys.argv[1] + "/" + f, "r");
		w, h = i.size;

		data = list(i.getdata());

		get_bin = lambda x, n: str(format(x, 'b').zfill(n));
		converted = [];
		
		for y in range(h):
			for x in range(w):
				converted.append(get_bin(data[w*y+x][0], 8)[0:4] + get_bin(data[w*y+x][1], 8)[0:4] + get_bin(data[w*y+x][2], 8)[0:4]);
		
		out.write("--Starting index: " + str(offset) + "\n");
		out.write("--" + f + "\n");
		
		for i in range(len(converted)):
			out.write(get_bin(i + offset, 16) + "\t:\t" + converted[i] + ";\n");
		offset = len(converted) + offset;
		out.write("\n");
	out.write("END;");