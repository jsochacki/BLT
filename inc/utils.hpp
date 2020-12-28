/**
 * This file contains general utility functions needed for the application.
 * 
 * @author Collin Bolles
 */
#ifndef _BLT_UTILS_HPP_
#define _BLT_UTILS_HPP_

namespace BLT {
    /**
     * Handles extracting the filename from a UNIX style path.
     * ex) ~/samples/image.jpg => image.jpg
     *
     * @param filePath The whole path of the file
     * @return The image name without the rest of the path
     */
    std::string getFilename(std::string filePath);

    /**
     * Get all images found in a given directory. This does not search
     * subdirectories. Images that count will end in the following extensions.
     * jpeg, jpg, tiff, gif, png
     *
     * @param imageFolder The folder to search for images in
     * @param[out] imagePaths Vector that stores all the paths for the found
     *      images.
     * @return The number of images found
     */
    std::size_t getImages(std::string imageFolder, 
            std::vector<std::string>& imagePaths);
}

#endif
