BEGIN {
i = 0
while (getline line > 0) {
split (line, b, ",");
#print b[1]
a[i][0] = b[1]
a[i][1] = b[2]
a[i][2] = b[3]
i++;
}
}
END {
for (j = 1; j < i; j++) {
printf "ps2_clock <= '%d'; ps2_data <= '%d'; wait for %f * 1000 ms;\n", a[j][1], a[j][2], (a[j+1][0] - a[j][0])
}
}
