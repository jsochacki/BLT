# BLT: a Boundary Limited Text extraction tool

[![Issues]()](https://github.com/jsochacki/BLT/issues)
[![Forks]()](https://github.com/jsochacki/BLT/network)
[![Stars]()](https://github.com/jsochacki/BLT/stargazers)
[![Downloads]()](https://github.com/jsochacki/BLT/releases)

**BLT** is a C++ based tool that is aimed at performing automatic list creating for cataloging books, videogames, and other objects that have text regions that are separated with clear and srong boundaries.  In order to use BLT one must only take pictures of the items that they want to catalog in their natural state like the following.

![Image Example](http://www.boston.com/business/innovation/state-of-play/assets_c/2013/12/library5-thumb-599x351-120892.jpg)

Once you have one of these or a whole set of these just place these in the directory you launch BLT from and run BLT.  THe result will be held in a .csv file in the same directory.  There are similar things for books out there and there are OCR apps but none that I could find that met this need specifically.

# Theory or operation:

1.	Use Canny edge detection from OpenCV(https://docs.opencv.org/trunk/da/d22/tutorial_py_canny.html) to get the edges
2.	Draw bounding boxes around each contour https://docs.opencv.org/3.4/da/d0c/tutorial_bounding_rects_circles.html
3.	Snap each enclosed area to it’s own image file
4.	Use tesseract-ocr https://github.com/tesseract-ocr/tesseract to get the text from each image
    1.	Take an image and use tesseract, run it for all 4 orientations (base, rot 90, rot 180, rot 270) and save the result with the highest score
5.	Write it all to a file using standard library calls
  
# Installation
Installation is automatically done with the provided .sh script for ubuntu systems


# Building the Project

The project can be built using the provided Makefile. Execute the command below
to create the main executable.

```bash
make
```

The Makefile will compile all contents of the `src` folder into a single
executable.

# Running the Application

After building the application, the executable will be named `main` and will be
in the root of the `build/` folder. Currently the executable can be used to run
Canny Edge on all images located inside of a folder. Below is an example
execution of the program.

```bash
./build/main --threshold1=0 --threshold2=4 --src=./images/ --out=./out/
```

The source folder needs to exist and contain images files, by default the
`images/` folder in the root of the project folder will be used. The output
folder does not need to exist and will be made if it does not exist. The
two thresholds control the two thresholds of the Canny Edge detection. For
more information, run the help command below.

```bash
./build/main --help
```

NOTE: Currently OpenCV filesystem tools do not process the `~` character in
paths properly. Instead use absolute path in situations where the home
directory is required.
