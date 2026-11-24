from author_companions import A, B
HEAD = "female adult mid-twenties, {b}, (medium breasts:1.1), (small nipples:1.2), (tiny areola:1.4), head to body ratio 1 to 7"
for k, body in B.items():
    for pose in "tp":
        dst = A / ("anchor-" + k.lower() + "-female-" + pose)
        dst.mkdir(exist_ok=True)
        for f in (A / ("anchor-v1-female-" + pose)).glob("*.txt"):
            L = f.read_text().split("\n")
            if len(L) > 3:
                L[3] = HEAD.format(b=body)
            dst.joinpath(f.name).write_text("\n".join(L))
print("txt", len(list(A.glob("anchor-v[3-9]-female-*/*.txt"))) + len(list(A.glob("anchor-v10-female-*/*.txt"))))
