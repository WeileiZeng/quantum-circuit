(TeX-add-style-hook
 "xyqcirc"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("xy" "frame" "line" "arrow" "matrix" "tips")))
   (TeX-run-style-hooks
    "graphicx"
    "xy")
   (TeX-add-symbols
    "w"
    "W"
    "A"
    "op"
    "b"
    "o"
    "t"
    "sq"
    "m"
    "z"
    "discard"
    "slash"
    "N"
    "n"
    "ua"
    "meter"
    "q"
    "qv"
    "gspace"
    "gnqubit"
    "gtwo"
    "gthree"
    "dmeterwide"
    "dmeter"))
 :latex)

