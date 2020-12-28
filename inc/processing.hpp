/**
 * The functions required for running through the image processing is included
 * in this file. The functions provided are for modifying images and
 * extracting the needed information.
 *
 * @author Collin Bolles
 */

#ifndef _PROCESSING_HPP_
#define _PROCESSING_HPP_

namespace BLT {
    /**
     * Runs Canny Edge Detection on all images in a given folder and saves the
     * results to the provided output. The images will maintain the same name
     * as the original source image.
     *
     * @param srcDir The path to the source directory that has images that
     *      will have canny edge detection run on.
     * @param outDir The path to the directory where the canny edge images
     *      will be saved. The images will have the same name as the original.
     * @param blurSize The size to use for blurring the images before running
     *      Canny Edge.
     * @param threshold1 The first threshold for the hysteresis procedure.
     * @param threshold2 The second threshold for the hysteresis procedue.
     */
    void runCanny(const std::string srcDir, const std::string outDir,
            const int blurSize=3, const int thresold1=0, const int thresold2=3);
}
#endif
